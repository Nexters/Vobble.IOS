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
#import <M13ProgressSuite/M13ProgressViewRing.h>
#import <AFNetworking/AFNetworking.h>
@interface ConfirmVobbleViewController ()
@property (nonatomic, weak) IBOutlet UIImageView* bgImgView;
@property (nonatomic, weak) IBOutlet M13ProgressViewRing *progressView;
@property (nonatomic, weak) IBOutlet NZCircularImageView* vobbleImgView;
@property (nonatomic, weak) IBOutlet MKMapView* mapView;
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
    [self.navigationItem setHidesBackButton:YES];
    [_mapView showsUserLocation];
	[_progressView setShowPercentage:NO];
    //[_progressView setBackgroundRingWidth:15];
    [_progressView setProgressRingWidth:10];
    [_progressView setProgress:0.0f animated:NO];
    [_progressView setPrimaryColor:ORANGE_COLOR];
    [_progressView setSecondaryColor:[UIColor whiteColor]];
    NSData* vobbleImgData = [[NSData alloc] initWithContentsOfURL:_imageURL];
    UIImage* vobbleImg = [[UIImage alloc] initWithData:vobbleImgData];
    _vobbleImgView.image = vobbleImg;
}

- (IBAction)saveClick:(id)sender{
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
