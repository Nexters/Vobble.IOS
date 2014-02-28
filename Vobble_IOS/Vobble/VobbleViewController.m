//
//  VobbleViewController.m
//  Vobble_IOS
//
//  Created by Rangken on 2014. 2. 23..
//  Copyright (c) 2014년 Nexters. All rights reserved.
//

#import "VobbleViewController.h"
#import "App.h"
#import "NZCircularImageView.h"
#import <M13ProgressSuite/M13ProgressViewRing.h>
#import "MainViewController.h"
#import "DOUAudioStreamer.h"
#import "DOUAudioStreamer.h"
#import "DOUAudioStreamer+Options.h"
#import "Track.h"
#import "User.h"
#import "Pin.h"
#import "TTTAttributedLabel.h"

#define METERS_PER_MILE 1609.344

static void *kStatusKVOKey = &kStatusKVOKey;
static void *kDurationKVOKey = &kDurationKVOKey;
static void *kBufferingRatioKVOKey = &kBufferingRatioKVOKey;

@interface VobbleViewController (){
    @private
    DOUAudioStreamer *_streamer;
    NSTimer *_timer;
    User* _user;
}
@property (nonatomic, weak) IBOutlet UIImageView* bgImgView;
@property (nonatomic, weak) IBOutlet MKMapView* mapView;
@property (nonatomic, weak) IBOutlet UIView* progressBackView;
@property (nonatomic, weak) IBOutlet M13ProgressViewRing *progressView;
@property (nonatomic, weak) IBOutlet NZCircularImageView* vobbleImgView;
@property (nonatomic, weak) IBOutlet TTTAttributedLabel* vobbleInfoLabel;
@end

@implementation VobbleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[DOUAudioStreamer setOptions:[DOUAudioStreamer options] | DOUAudioStreamerDefaultOptions];
    [_mapView showsUserLocation];
    [_progressView setShowPercentage:NO];
    //[_progressView setBackgroundRingWidth:15];
    [_progressView setProgressRingWidth:10];
    [_progressView setProgress:0.0f animated:NO];
    [_progressView setPrimaryColor:ORANGE_COLOR];
    [_progressView setSecondaryColor:[UIColor whiteColor]];
    [_vobbleImgView setImageWithResizeURL:[_vobble getImgUrl]];
    
	[self animateOnEntry];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[URL getUserURL:_vobble.userId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        JY_LOG(@"%@ : %@",[URL getUserURL:_vobble.userId],responseObject);
        if ([[responseObject objectForKey:@"result"] integerValue] != 0) {
            NSDictionary* dic = [responseObject objectForKey:@"user"];
            _user = [User new];
            _user.userId = [dic objectForKey:@"user_id"];
            _user.email = [dic objectForKey:@"email"];
            _user.userName = [dic objectForKey:@"username"];

            [_vobbleInfoLabel setText:[NSString stringWithFormat:NSLocalizedString(@"VOBBLE_NAME_TIME_DESCTIPTION", @"보블 설명"),_user.userName ,_vobble.createdAt] afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
                
                NSRange boldRange = [[mutableAttributedString string] rangeOfString:_user.userName options:NSCaseInsensitiveSearch];
                
                UIFont *boldSystemFont = [UIFont boldSystemFontOfSize:19];
                CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
                if (font) {
                    [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:boldRange];
                    //[mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(__bridge id)[[UIColor redColor] CGColor] range:redRange];
                    CFRelease(font);
                }
                
                return mutableAttributedString;
            }];
             
        }else{
            [self alertNetworkError:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self alertNetworkError:NSLocalizedString(@"NETWORK_ERROR", @"네트워크 실패")];
    }];
}
- (void)viewDidAppear:(BOOL)animated{
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = _vobble.latitude;
    zoomLocation.longitude= _vobble.longitude;
    JY_LOG(@" _vobble.latitude : %lf", _vobble.latitude);
    JY_LOG(@" _vobble.longitude : %lf", _vobble.longitude);
    
    CLLocationDistance mapSizeMeters = 5000;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, mapSizeMeters, mapSizeMeters);
    
    MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
    if(adjustedRegion.center.longitude != -180.00000000){
        if (isnan(adjustedRegion.center.latitude)) {
            // iOS 6 will result in nan. 2012-10-15
            adjustedRegion.center.latitude = viewRegion.center.latitude;
            adjustedRegion.center.longitude = viewRegion.center.longitude;
            adjustedRegion.span.latitudeDelta = 0;
            adjustedRegion.span.longitudeDelta = 0;
        }
        
        
        [_mapView setRegion:adjustedRegion animated:YES];
    }
    /*
     MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
     [_mapView setRegion:viewRegion animated:YES];
    */
    
    Pin* pin = [[Pin alloc] initWithCoordinates:zoomLocation placeName:@"Start" description:@""];
    [_mapView addAnnotation:pin];
    
    [self resetStreamer];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_timer) {
        [_timer invalidate];
    }
    [_streamer stop];
    [self cancelStreamer];

}
- (IBAction)playClick:(id)sender
{
    if ([_streamer status] == DOUAudioStreamerPaused ||
        [_streamer status] == DOUAudioStreamerIdle) {
        [_streamer play];
    }else if ( [_streamer status] == DOUAudioStreamerFinished){
        [self resetStreamer];
    }
    else {
        [_streamer pause];
    }
}
- (IBAction)backClick:(id)sender{
    //CGPoint originalProgressCenter = _progressBackView.center;
    CGRect originalProgressRect = _progressBackView.frame;
    //_progressBackView.center = CGPointMake(_vobbleOrignalCenter.x, _vobbleOrignalCenter.y+60);
    _progressBackView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0f,1.0f);
    
    [UIView animateWithDuration:0.4f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void){
        _progressBackView.center = CGPointMake(_vobbleOrignalCenter.x, _vobbleOrignalCenter.y+60);
        _progressBackView.transform = CGAffineTransformScale(CGAffineTransformIdentity,_vobbleOriginalRect.size.width/originalProgressRect.size.width, _vobbleOriginalRect.size.height/originalProgressRect.size.height);
        _vobbleInfoLabel.alpha = 0.0f;
    }completion:^(BOOL finished){
        
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:NO completion:nil];
    });
}
- (void) animateOnEntry
{
    CGPoint originalProgressCenter = _progressBackView.center;
    CGRect originalProgressRect = _progressBackView.frame;
    _progressBackView.center = CGPointMake(_vobbleOrignalCenter.x, _vobbleOrignalCenter.y+60);
    _progressBackView.transform = CGAffineTransformScale(CGAffineTransformIdentity, _vobbleOriginalRect.size.width/originalProgressRect.size.width,_vobbleOriginalRect.size.height/originalProgressRect.size.height);
    _vobbleInfoLabel.alpha = 0.0f;
    [UIView animateWithDuration:0.4f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
        _progressBackView.center = originalProgressCenter;
        _progressBackView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0f, 1.0f);
        _vobbleInfoLabel.alpha = 1.0f;
    }completion:^(BOOL finished){
        
    }];
}

- (void)cancelStreamer
{
    if (_streamer != nil) {
        [_streamer pause];
        [_streamer removeObserver:self forKeyPath:@"status"];
        [_streamer removeObserver:self forKeyPath:@"duration"];
        [_streamer removeObserver:self forKeyPath:@"bufferingRatio"];
        _streamer = nil;
    }
}

- (void)resetStreamer
{
    [self cancelStreamer];
    
    Track *track = [[Track alloc] init];
    [track setUserId:_vobble.userId];
    [track setAudioFileURL:[NSURL URLWithString:[_vobble getVoiceUrl]]];
    _streamer = [DOUAudioStreamer streamerWithAudioFile:track];
    [_streamer addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:kStatusKVOKey];
    [_streamer addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:kDurationKVOKey];
    [_streamer addObserver:self forKeyPath:@"bufferingRatio" options:NSKeyValueObservingOptionNew context:kBufferingRatioKVOKey];
    [_streamer play];

    _timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(_timerAction:) userInfo:nil repeats:YES];
    
}
- (void)_timerAction:(id)timer
{
    if (_streamer) {
        //NSLog(@"%lf",[_streamer currentTime] / [_streamer duration]);
        [_progressView setProgress:[_streamer currentTime] / [_streamer duration] + 0.05f animated:NO];
    }
}

- (void)_updateStatus
{
    switch ([_streamer status]) {
        case DOUAudioStreamerPlaying:
            break;
            
        case DOUAudioStreamerPaused:
            break;
            
        case DOUAudioStreamerIdle:
         
            break;
            
        case DOUAudioStreamerFinished:
            [_timer invalidate];
            [_progressView setProgress:0 animated:NO];
            break;
            
        case DOUAudioStreamerBuffering:
            break;
            
        case DOUAudioStreamerError:
            break;
    }
}

- (void)_updateBufferingStatus
{
    /*
    [_miscLabel setText:[NSString stringWithFormat:@"Received %.2f/%.2f MB (%.2f %%), Speed %.2f MB/s", (double)[_streamer receivedLength] / 1024 / 1024, (double)[_streamer expectedLength] / 1024 / 1024, [_streamer bufferingRatio] * 100.0, (double)[_streamer downloadSpeed] / 1024 / 1024]];
    
    if ([_streamer bufferingRatio] >= 1.0) {
        NSLog(@"sha256: %@", [_streamer sha256]);
    }
     */
    JY_LOG(@"BUFFER : %@",[NSString stringWithFormat:@"Received %.2f/%.2f MB (%.2f %%), Speed %.2f MB/s", (double)[_streamer receivedLength] / 1024 / 1024, (double)[_streamer expectedLength] / 1024 / 1024, [_streamer bufferingRatio] * 100.0, (double)[_streamer downloadSpeed] / 1024 / 1024]);
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == kStatusKVOKey) {
        [self performSelector:@selector(_updateStatus)
                     onThread:[NSThread mainThread]
                   withObject:nil
                waitUntilDone:NO];
    }
    else if (context == kDurationKVOKey) {
        [self performSelector:@selector(_timerAction:)
                     onThread:[NSThread mainThread]
                   withObject:nil
                waitUntilDone:NO];
    }
    else if (context == kBufferingRatioKVOKey) {
        [self performSelector:@selector(_updateBufferingStatus)
                     onThread:[NSThread mainThread]
                   withObject:nil
                waitUntilDone:NO];
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
