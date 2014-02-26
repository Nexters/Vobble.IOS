//
//  CreateVobbleViewController.m
//  Vobble_IOS
//
//  Created by Rangken on 2014. 2. 23..
//  Copyright (c) 2014년 Nexters. All rights reserved.
//

#import "CreateVobbleViewController.h"
#import "App.h"
#import "NZCircularImageView.h"
#import <M13ProgressSuite/M13ProgressViewRing.h>
#import "MainViewController.h"
#import "DOUAudioStreamer.h"
#import "DOUAudioStreamer.h"
#import "DOUAudioStreamer+Options.h"
#import "DBCameraViewController.h"
#import "DoActionSheet.h"
#import "User.h"
#import "AppDelegate.h"
#import "ConfirmVobbleViewController.h"
#import <AFNetworking/AFNetworking.h>
#define MAX_AUDIO_TIME 7.0f
#define VOBBLE_AUDIO @"vobble.m4a"
#define VOBBLE_IMG @"vobble.png"
@interface CreateVobbleViewController () < DBCameraViewControllerDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate >
{
    @private
    AVAudioRecorder* _recorder;
    AVAudioPlayer* _player;
    NSTimer *_timer;
    float _accTime;
    BOOL _isAttachedImg;
}
@property (nonatomic, weak) IBOutlet UIImageView* bgImgView;
@property (nonatomic, weak) IBOutlet M13ProgressViewRing *progressView;
@property (nonatomic, weak) IBOutlet NZCircularImageView* vobbleImgView;
@property (nonatomic, weak) IBOutlet UIButton* playBtn;
@property (nonatomic, weak) IBOutlet UIButton* recordBtn;
@end

@implementation CreateVobbleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _isAttachedImg = FALSE;
    [_progressView setShowPercentage:NO];
    //[_progressView setBackgroundRingWidth:15];
    [_progressView setProgressRingWidth:10];
    [_progressView setProgress:0.0f animated:NO];
    [_progressView setPrimaryColor:ORANGE_COLOR];
    [_progressView setSecondaryColor:[UIColor whiteColor]];
}
- (void)viewDidAppear:(BOOL)animated{
    [self deleteAudioFile];
}
- (void)viewDidDisappear:(BOOL)animated{
    if (_timer) {
        [_timer invalidate];
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"ToConfirmSegue"]) {
        ConfirmVobbleViewController *confirmViewCont = segue.destinationViewController;
        confirmViewCont.voiceURL = [self getRecordURL];
        confirmViewCont.imageURL = [self getImgURL];
    }
}
- (IBAction)pictureClick:(id)sender{
    if (!_isAttachedImg) {
        _vobbleImgView.image = [UIImage imageNamed:@"record_camera_icon.png"];
    }
   
    DoActionSheet *vActionSheet = [[DoActionSheet alloc] init];
    
    vActionSheet.nAnimationType = DoTransitionStylePop;
    vActionSheet.nContentMode = DoContentNone;
    /*
    vActionSheet.nContentMode = DoContentMap;
    vActionSheet.dLocation = @{@"latitude" : @(37.78275123), @"longitude" : @(-122.40416442), @"altitude" : @200};
    */
    //vActionSheet.nDestructiveIndex = 2;
    [vActionSheet showC:@""
                 cancel:NSLocalizedString(@"CANCEL",@"취소")
                buttons:@[NSLocalizedString(@"IMG_SELECT_CAMERA", @"카메라에서 선택"),
                          NSLocalizedString(@"IMG_SELECT_GALLERY", @"갤러리 선택"),
                          NSLocalizedString(@"IMG_SELECT_WEB", @"웹에서 선택")]
                 result:^(int nResult) {
                     
                     NSLog(@"---------------> result : %d", nResult);
                     if (nResult == 0) {
                         UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[DBCameraViewController initWithDelegate:self]];
                         [nav setNavigationBarHidden:YES];
                         [self presentViewController:nav animated:YES completion:nil];
                     }else if (nResult == 1) {
                         UIImagePickerController* imagePickerViewCont = [[UIImagePickerController alloc] init];
                         [imagePickerViewCont setDelegate:self];
                         [imagePickerViewCont setAllowsEditing:YES];
                         [imagePickerViewCont setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                         [self presentViewController:imagePickerViewCont animated:TRUE completion:^(void){
                             
                         }];
                     }else if (nResult == 2) {
                         
                     }
                 }];
}
- (IBAction)pictureClickDown:(id)sender{
    if (!_isAttachedImg) {
        _vobbleImgView.image = [UIImage imageNamed:@"record_camera_icon_o.png"];
    }
}

- (IBAction)recordClick:(id)sender{
    if (_recorder && [_recorder isRecording]) {
        [self stopRecord];
        return ;
    }
    NSMutableDictionary* recordSetting = [[NSMutableDictionary alloc] init];
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:16000.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
    //[recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    //[recordSetting setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
    //[recordSetting setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    
    NSError *err = nil;
    _recorder = [[ AVAudioRecorder alloc] initWithURL:[self getRecordURL] settings:recordSetting error:&err];
    [_recorder setDelegate:self];
    if (![_recorder prepareToRecord]) {
        [self alertNetworkError:NSLocalizedString(@"RECORDER_FAIL", @"녹음 실패")];
        return ;
    }
    _recorder.meteringEnabled = YES;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    [audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&err];
    if(err){
        JY_LOG(@"audioSession: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
        return;
    }
    err = nil;
    [audioSession setActive:YES error:&err];
    if(err){
        JY_LOG(@"audioSession: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
        return;
    }
    if (![_recorder record]) {
        [self alertNetworkError:NSLocalizedString(@"RECORDER_FAIL", @"녹음 실패")];
        return ;
    }
    [_recordBtn setSelected:TRUE];
     _timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(_timerAction:) userInfo:nil repeats:YES];
}
- (IBAction)playClick:(id)sender{
    NSError *err = nil;
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[self getRecordURL] error:&err];
    [_player setDelegate:self];
    [_player setMeteringEnabled:YES];
    [_player play];
    [_playBtn setSelected:TRUE];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(_audioTimerAction:) userInfo:nil repeats:YES];
}

- (IBAction)rewindClick:(id)sender{
    
    [self stopRecord];
    [self stopPlay];
    [_recordBtn setHidden:FALSE];
    [_playBtn setHidden:TRUE];
    [_progressView setProgress:0 animated:FALSE];
    BOOL isFileExist = [self deleteAudioFile];
    if (isFileExist) {
        [self recordClick:NULL];
    }
}

- (IBAction)confirmClick:(id)sender{
    if (!_isAttachedImg) {
        [self alertNetworkError:NSLocalizedString(@"IMG_NOT_ATTACHED_ERROR", @"이미지 첨부")];
    }else if (![self isExistAudioFile]){
        [self alertNetworkError:NSLocalizedString(@"VOICE_NOT_ATTACHED_ERROR", @"음성 첨부")];
    }else{
        [self performSegueWithIdentifier:@"ToConfirmSegue" sender:self];
        /*
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSDictionary *parameters = @{@"token": [User getToken],
                                     @"latitude": [User getLatitude],
                                     @"longitude": [User getLongitude]};
        NSURL *voiceURL = [self getRecordURL];
        NSURL *imgURL = [self getImgURL];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [manager POST:[URL getUploadVobbleURL] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileURL:voiceURL name:@"voice" error:nil];
            [formData appendPartWithFileURL:imgURL name:@"image" error:nil];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Success: %@", responseObject);
            if ([[responseObject objectForKey:@"result"] integerValue] != 0) {
                [self performSegueWithIdentifier:@"ToConfirmSegue" sender:self];
            }else{
                [self alertNetworkError:[responseObject objectForKey:@"msg"]];
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [self alertNetworkError:NSLocalizedString(@"NETWORK_ERROR", @"")];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
         */
    }
}
- (void)_timerAction:(id)timer
{
    _accTime+=0.02f;
    [_progressView setProgress:_accTime/MAX_AUDIO_TIME animated:TRUE];
    if (_accTime > MAX_AUDIO_TIME) {
        [self stopRecord];
    }
}
- (void)_audioTimerAction:(id)timer
{
    if (_player) {
        float total=_player.duration;
        float f=_player.currentTime / total;
        [_progressView setProgress:f animated:NO];
        if (f > 0.99) {
            [self stopPlay];
        }
    }
}
- (NSURL*)getRecordURL{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString * soundsDirectoryPath = [documentsDirectory stringByAppendingPathComponent:@"record"];
    [[NSFileManager defaultManager] createDirectoryAtPath:soundsDirectoryPath withIntermediateDirectories:YES attributes:nil error:NULL];
    
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", soundsDirectoryPath,VOBBLE_AUDIO]];
    return url;
}
- (NSURL*)getImgURL{
   
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString * imageDirectoryPath = [documentsDirectory stringByAppendingPathComponent:@"image"];
    [[NSFileManager defaultManager] createDirectoryAtPath:imageDirectoryPath withIntermediateDirectories:YES attributes:nil error:NULL];
    NSString* path = [NSString stringWithFormat:@"%@/%@", imageDirectoryPath,VOBBLE_IMG];
    NSURL *url = [NSURL fileURLWithPath:path];
    [UIImageJPEGRepresentation(_vobbleImgView.image, 1.0) writeToFile:path atomically:YES];
    return url;
}

- (void)stopRecord{
    _accTime = 0.0f;
    [_timer invalidate];
    [_recorder stop];
    _recorder = NULL;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:NO withFlags:AVAudioSessionSetActiveFlags_NotifyOthersOnDeactivation error:nil];
    
    [_recordBtn setSelected:FALSE];
    [_recordBtn setHidden:TRUE];
    [_playBtn setHidden:FALSE];
}
- (void)stopPlay{
    [_timer invalidate];
    [_player stop];
    _player = NULL;
    [_playBtn setSelected:FALSE];
    [_progressView setProgress:1.0f animated:FALSE];
}
- (BOOL)deleteAudioFile{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* soundsDirectoryPath = [documentsDirectory stringByAppendingPathComponent:@"record"];
    NSString* path = [NSString stringWithFormat:@"%@/%@", soundsDirectoryPath,VOBBLE_AUDIO];
    NSError *error;
    if ([[NSFileManager defaultManager] isDeletableFileAtPath:path]) {
        BOOL success = [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        if (!success) {
            JY_LOG(@"Error removing file at path: %@", error.localizedDescription);
            return FALSE;
        }
        return TRUE;
    }
    return FALSE;
}
- (BOOL)isExistAudioFile{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* soundsDirectoryPath = [documentsDirectory stringByAppendingPathComponent:@"record"];
    NSString* path = [NSString stringWithFormat:@"%@/%@", soundsDirectoryPath,VOBBLE_AUDIO];
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}
#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [self stopPlay];
}
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    [self alertNetworkError:NSLocalizedString(@"PLAY_FAIL", @"플레이 실패")];
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInf{
    _vobbleImgView.image = image;
    _isAttachedImg = TRUE;
    [self dismissViewControllerAnimated:TRUE completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:TRUE completion:nil];
}
#pragma mark - DBCameraViewControllerDelegate
- (void) captureImageDidFinish:(UIImage *)image withMetadata:(NSDictionary *)metadata
{
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
#endif
    _vobbleImgView.image = image;
    _isAttachedImg = TRUE;
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
