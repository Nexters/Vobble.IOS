//
//  ConfirmVobbleViewController.m
//  Vobble_IOS
//
//  Created by Rangken on 2014. 2. 23..
//  Copyright (c) 2014년 Nexters. All rights reserved.
//

#import "ConfirmVobbleViewController.h"
#import "App.h"
#import "User.h"
#import "NZCircularImageView.h"
#import "Pin.h"
#import <M13ProgressSuite/M13ProgressViewRing.h>
#import <AFNetworking/AFNetworking.h>
#import <FSExtendedAlertKit.h>
#import <AVFoundation/AVFoundation.h>
@interface ConfirmVobbleViewController () < AVAudioPlayerDelegate>
{
    @private
    AVAudioPlayer* _player;
    NSTimer *_timer;
}
@property (nonatomic, weak) IBOutlet UIImageView* bgImgView;
@property (nonatomic, weak) IBOutlet M13ProgressViewRing *progressView;
@property (nonatomic, weak) IBOutlet NZCircularImageView* vobbleImgView;
@property (nonatomic, weak) IBOutlet MKMapView* mapView;
@property (nonatomic, weak) IBOutlet UIButton* locationBtn;
@property (nonatomic, weak) IBOutlet UIImageView* shadowImgView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation ConfirmVobbleViewController

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
    self.navigationController.navigationBarHidden = TRUE;
    self.navigationItem.hidesBackButton = TRUE;
    if (IPHONE4) {
        _shadowImgView.frame = CGRectMake(_shadowImgView.frame.origin.x, _shadowImgView.frame.origin.y+53, _shadowImgView.frame.size.width, _shadowImgView.frame.size.height);
    }
    UIBarButtonItem *backBtn =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    [self.navigationItem setBackBarButtonItem:backBtn];
    self.navigationItem.backBarButtonItem.title = @"";
    self.navigationController.navigationBar.topItem.title = @"";
    //[self.navigationItem setHidesBackButton:YES];
    [_mapView showsUserLocation];
	[_progressView setShowPercentage:NO];
    [_progressView setBackgroundRingWidth:10];
    [_progressView setProgressRingWidth:10];
    [_progressView setProgress:0.0f animated:NO];
    [_progressView setPrimaryColor:MINT_COLOR];
    [_progressView setSecondaryColor:[UIColor whiteColor]];
    NSData* vobbleImgData = [[NSData alloc] initWithContentsOfURL:_imageURL];
    UIImage* vobbleImg = [[UIImage alloc] initWithData:vobbleImgData];
    _vobbleImgView.image = vobbleImg;
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    //_locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    [_locationManager startUpdatingLocation];
    
    if (IPHONE4) {
        [_mapView setFrame:CGRectMake(_mapView.frame.origin.x, _mapView.frame.origin.y+30, _mapView.frame.size.width, _mapView.frame.size.height-30)];
        [_locationBtn setFrame:CGRectMake(_locationBtn.frame.origin.x, _locationBtn.frame.origin.y-30, _locationBtn.frame.size.width, _locationBtn.frame.size.height)];
    }
    [self playClick:NULL];
}
- (void)viewDidAppear:(BOOL)animated{
    [self reloadMap];
    /*
     MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
     [_mapView setRegion:viewRegion animated:YES];
     */
}
- (IBAction)backClick:(id)sender{
    [self.navigationController popViewControllerAnimated:TRUE];
}
- (IBAction)saveClick:(id)sender{
    NSData *voiceData = [NSData dataWithContentsOfURL:_voiceURL];
    NSData *imageData = [NSData dataWithContentsOfURL:_imageURL];
    NSDictionary *parameters = @{@"token": [User getToken],
                                 @"latitude": [User getLatitude],
                                 @"longitude": [User getLongitude]};
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableURLRequest* request = [[AFAppDotNetAPIClient sharedClient]  multipartFormRequestWithMethod:@"POST" path:[URL getUploadVobbleURL] parameters:parameters constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        [formData appendPartWithFileData:voiceData name:@"voice" fileName:[_voiceURL lastPathComponent] mimeType:@"image/m4a"];
        [formData appendPartWithFileData:imageData name:@"image" fileName:[_imageURL lastPathComponent] mimeType:@"image/jpeg"];
    }];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        JY_LOG(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
    }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id JSON) {
        id jsonResponse = [NSJSONSerialization JSONObjectWithData:JSON
                                                          options:NSJSONReadingAllowFragments | NSJSONReadingMutableContainers
                                                            error:nil];
        JY_LOG(@"%@ : %@",[URL getUploadVobbleURL] ,jsonResponse);
        if ([[jsonResponse objectForKey:@"result"] integerValue] != 0) {
            [self performSegueWithIdentifier:@"ToMainSegue" sender:self];
        }else{
            [self alertNetworkError:[jsonResponse objectForKey:@"msg"]];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [self alertNetworkError:NSLocalizedString(@"NETWORK_ERROR", @"")];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    [operation start];
    /*
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"token": [User getToken],
                                 @"latitude": [User getLatitude],
                                 @"longitude": [User getLongitude]};
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager POST:[URL getUploadVobbleURL] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:_voiceURL name:@"voice" error:nil];
        [formData appendPartWithFileURL:_imageURL name:@"image" error:nil];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
        if ([[responseObject objectForKey:@"result"] integerValue] != 0) {
            [self performSegueWithIdentifier:@"ToMainSegue" sender:self];
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

- (IBAction)playClick:(id)sender{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    NSError *err = nil;
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:_voiceURL error:&err];
    [_player setDelegate:self];
    [_player setMeteringEnabled:YES];
    [_player setVolume:1.0f];
    [_player play];
    if (_timer) {
        [_timer invalidate];
        _timer = NULL;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(_audioTimerAction:) userInfo:nil repeats:YES];
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

- (void)stopPlay{
    [_timer invalidate];
    [_player stop];
    _player = NULL;
    [_progressView setProgress:1.0f animated:FALSE];
}

- (void)reloadMap{
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = [[User getLatitude] floatValue];
    zoomLocation.longitude= [[User getLongitude] floatValue];
    
    CLLocationDistance mapSizeMeters = 1000;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, mapSizeMeters, mapSizeMeters);
    
    MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
    if(adjustedRegion.center.longitude != -180.00000000){
        if (isnan(adjustedRegion.center.latitude)) {
            adjustedRegion.center.latitude = viewRegion.center.latitude;
            adjustedRegion.center.longitude = viewRegion.center.longitude;
            adjustedRegion.span.latitudeDelta = 0;
            adjustedRegion.span.longitudeDelta = 0;
        }
        
        
        [_mapView setRegion:adjustedRegion animated:YES];
    }
    Pin* pin = [[Pin alloc] initWithCoordinates:zoomLocation placeName:@"Start" description:@""];
    [_mapView addAnnotation:pin];
}
- (IBAction)reloadLocationClick:(id)sender{
    [self reloadMap];
    [_locationManager startUpdatingLocation];
}
#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    if (newLocation != NULL) {
 
    }
}
- (void)locationManager:(CLLocationManager *)manager
	 didUpdateLocations:(NSArray *)locations{
    CLLocation* location = [locations lastObject];
    if (location != NULL) {
        [_locationBtn setSelected:FALSE];
        [User setLatitude:[NSString stringWithFormat:@"%lf",location.coordinate.latitude]];
        [User setLongitude:[NSString stringWithFormat:@"%lf",location.coordinate.longitude]];
        [self reloadMap];
    }
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    JY_LOG(@"didFailWithError");
    FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"Vobble" message:NSLocalizedString(@"LOCATION_NOTFOOUND", @"위치정보 못 가져옴") cancelButton: [FSBlockButton blockButtonWithTitle:NSLocalizedString(@"CONFIRM",@"취소") block:^ {
        
    }]otherButtons:nil];
    [alert show];
    //[_locationBtn setImage:[UIImage imageNamed:@"04.png"] forState:UIControlStateNormal];
    [_locationBtn setSelected:TRUE];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [self stopPlay];
}
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    [self alertNetworkError:NSLocalizedString(@"PLAY_FAIL", @"플레이 실패")];
}

@end
