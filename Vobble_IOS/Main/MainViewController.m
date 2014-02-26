//
//  MainViewController.m
//  Vobble_IOS
//
//  Created by Rangken on 2014. 2. 23..
//  Copyright (c) 2014년 Nexters. All rights reserved.
//

#import "MainViewController.h"
#import "App.h"
#import "User.h"
#import "VobbleViewController.h"
#import "FriendVobbleViewController.h"
#import <FSExtendedAlertKit.h>
@interface MainViewController ()
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation MainViewController

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
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    UIBarButtonItem *backBtn =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    [self.navigationItem setBackBarButtonItem:backBtn];
    
    self.navigationController.navigationBar.tintColor = MINT_COLOR;
    
    [[EKTabHostsContainer appearance] setBackgroundColor:[UIColor clearColor]];
    [[EKTabHost appearance] setSelectedColor:[UIColor clearColor]];
    [[EKTabHost appearance] setTitleColor:[UIColor whiteColor]];
    [[EKTabHost appearance] setTitleFont:[UIFont systemFontOfSize:14.0f]];
    [self.viewPager reloadData];
    
    EKTabHost* select_tab = [self.viewPager.tabHostsContainer.tabs objectAtIndex:0];
    [select_tab setBackgroundColor:CLICK_GRAY_COLOR];
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    //_locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    [_locationManager startUpdatingLocation];
}
- (void)viewDidAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:TRUE];
    if (_myVobbleViewCont && _allVobbleViewCont) {
        [_myVobbleViewCont initVobbles];
        [_allVobbleViewCont initVobbles];
    }
}
- (void)viewDidDisappear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:FALSE];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"ToVobbleSegue"]) {
        VobbleViewController *vobbleViewCont = segue.destinationViewController;
        vobbleViewCont.vobbleOrignalCenter = _clickVobbleBtn.center;
        vobbleViewCont.vobbleOriginalRect = _clickVobbleBtn.frame;
        vobbleViewCont.vobble = _clickVobble;
    }
}
- (IBAction)refreshClick:(id)sender{
    MainVobbleViewController* mainVobbleViewCont = NULL;
    if ([_viewPager currentIndex] == ALL) {
        mainVobbleViewCont = _allVobbleViewCont;
    }else if ([_viewPager currentIndex] == MY) {
        mainVobbleViewCont = _myVobbleViewCont;
    }else{
        return ;
    }
    [mainVobbleViewCont initVobbles];
}
- (IBAction)eventClick:(id)sender
{
    [self performSegueWithIdentifier:@"ToEventSegue" sender:self];
}
- (IBAction)vobbleClick:(id)sender
{
    long tag = ((UIButton*)sender).tag;
    MainVobbleViewController* mainVobbleViewCont = NULL;
    if ([_viewPager currentIndex] == ALL) {
        mainVobbleViewCont = _allVobbleViewCont;
    }else if ([_viewPager currentIndex] == MY) {
        mainVobbleViewCont = _myVobbleViewCont;
    }
    if (tag >= [[mainVobbleViewCont vobbleArray] count]) {
        return ;
    }
    _clickVobble = [[mainVobbleViewCont vobbleArray] objectAtIndex:tag];
    _clickVobbleBtn = (UIButton*)sender;
    [self performSegueWithIdentifier:@"ToVobbleSegue" sender:self];
}
- (IBAction)recordClick:(id)sender
{
    [self performSegueWithIdentifier:@"ToCreateVobbleSegue" sender:self];
}
- (IBAction)logOutClick:(id)sender{
    FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"Vobble" message:NSLocalizedString(@"LOGOUT_DESCRIPTION", @"로그아웃") cancelButton: [FSBlockButton blockButtonWithTitle:NSLocalizedString(@"CANCEL",@"취소") block:^ {
        
    }]otherButtons: [FSBlockButton blockButtonWithTitle:NSLocalizedString(@"CONFIRM",@"확인") block:^ {
        [self performSegueWithIdentifier:@"ToSignSegue" sender:self];
        
    }],nil];
    [alert show];
    
}
#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    if (newLocation != NULL) {
        if ([[User getLatitude] isEqualToString:@""]) {
            [User setLatitude:[NSString stringWithFormat:@"%lf",newLocation.coordinate.latitude]];
            [User setLongitude:[NSString stringWithFormat:@"%lf",newLocation.coordinate.longitude]];
            [_myVobbleViewCont initVobbles];
            [_allVobbleViewCont initVobbles];
        }
        
    }
}
- (void)locationManager:(CLLocationManager *)manager
	 didUpdateLocations:(NSArray *)locations{
    CLLocation* location = [locations lastObject];
    if (location != NULL) {
        if ([[User getLatitude] isEqualToString:@""]) {
            [User setLatitude:[NSString stringWithFormat:@"%lf",location.coordinate.latitude]];
            [User setLongitude:[NSString stringWithFormat:@"%lf",location.coordinate.longitude]];
            [_myVobbleViewCont initVobbles];
            [_allVobbleViewCont initVobbles];
        }
        
    }
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    JY_LOG(@"didFailWithError");
    [User setLatitude:[NSString stringWithFormat:@"%lf",126.977969]];
    [User setLongitude:[NSString stringWithFormat:@"%lf",37.566535]];
    [_myVobbleViewCont initVobbles];
    [_allVobbleViewCont initVobbles];
}
#pragma mark - EKViewPagerDataSource
- (NSInteger)numberOfItemsForViewPager:(EKViewPager *)viewPager
{
    return 3;
}

- (NSString *)viewPager:(EKViewPager *)viewPager titleForItemAtIndex:(NSInteger)index
{
    if (index == 0) {
        return @"ALL";
    }
    if (index == 1) {
        return @"MY";
    }
    if (index == 2) {
        return @"FRIEND";
    }
    return @"";
}

- (UIViewController *)viewPager:(EKViewPager *)viewPager controllerAtIndex:(NSInteger)index
{
    if (index == ALL || index == MY) {
        MainVobbleViewController *mainVobbleViewCont = [self.storyboard instantiateViewControllerWithIdentifier:@"MainVobbleViewController"];
        mainVobbleViewCont.type = (eVobbleType)index;
        [mainVobbleViewCont view];
        mainVobbleViewCont.mainViewCont = self;
        if (index == ALL) {
            _allVobbleViewCont = mainVobbleViewCont;
        }else if (index == MY){
            _myVobbleViewCont = mainVobbleViewCont;
        }
        return mainVobbleViewCont;
    }else if (index == FRIEND){
        FriendVobbleViewController* friendVobbleViewCont = [self.storyboard instantiateViewControllerWithIdentifier:@"FriendVobbleViewController"];
        return friendVobbleViewCont;
    }
    return NULL;
}

- (void)viewPager:(EKViewPager *)viewPager tabHostClickedAtIndex:(NSInteger)index
{
    EKTabHost* select_tab = [viewPager.tabHostsContainer.tabs objectAtIndex:index];
    for (EKTabHost* tab in viewPager.tabHostsContainer.tabs) {
        if (select_tab == tab) {
            [tab setBackgroundColor:CLICK_GRAY_COLOR];
        }else{
            [tab setBackgroundColor:[UIColor clearColor]];
        }
    }
    
}

- (void)viewPager:(EKViewPager *)viewPager willMoveFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
}

- (void)viewPager:(EKViewPager *)viewPager didMoveFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    EKTabHost* select_tab = [viewPager.tabHostsContainer.tabs objectAtIndex:toIndex];
    for (EKTabHost* tab in viewPager.tabHostsContainer.tabs) {
        if (select_tab == tab) {
            [tab setBackgroundColor:CLICK_GRAY_COLOR];
        }else{
            [tab setBackgroundColor:[UIColor clearColor]];
        }
    }
    if (toIndex == ALL) {
        _vobbleCntLabel.text = [NSString stringWithFormat:@"%ld",_allVobbleViewCont.vobbleCnt];
        _vobbleDescLabel.text = @"All vobbles";
    }
    if (toIndex == MY) {
        _vobbleCntLabel.text = [NSString stringWithFormat:@"%ld",_myVobbleViewCont.vobbleCnt];
        _vobbleDescLabel.text = @"My vobbles";
    }
}
@end
