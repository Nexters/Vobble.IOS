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
#import "ConfirmVobbleViewController.h"
#import "EventViewController.h"
#import <FSExtendedAlertKit.h>
#import "DoActionSheet.h"
#import "IntroViewController.h"
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
    [self.navigationController setDelegate:self];
    UIBarButtonItem *backBtn =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    [self.navigationItem setBackBarButtonItem:backBtn];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [[EKTabHostsContainer appearance] setBackgroundColor:[UIColor clearColor]];
    [[EKTabHost appearance] setSelectedColor:[UIColor clearColor]];
    [[EKTabHost appearance] setTitleColor:[UIColor whiteColor]];
    [[EKTabHost appearance] setTitleFont:[UIFont systemFontOfSize:10.5]];
    [self.viewPager reloadData];
    
    EKTabHost* select_tab = [self.viewPager.tabHostsContainer.tabs objectAtIndex:0];
    [select_tab setBackgroundColor:CLICK_GRAY_COLOR];
    [User setLatitude:@""];
    [User setLongitude:@""];
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    //_locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    [_locationManager startUpdatingLocation];
}
- (void)viewDidAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:TRUE];
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
    if ([[segue identifier] isEqualToString:@"ToEventSegue"]) {
        EventViewController *eventViewCont = segue.destinationViewController;
        eventViewCont.type = EVENT_NOTICE;
    }
    if ([[segue identifier] isEqualToString:@"ToIntroSegue"]) {
        IntroViewController *introViewCont = segue.destinationViewController;
        introViewCont.type = INTRO_MENU;
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
    [mainVobbleViewCont resetVobbleImgs];
    [mainVobbleViewCont initVobbles];
}
- (IBAction)eventClick:(id)sender
{
    [self performSegueWithIdentifier:@"ToEventSegue" sender:self];
}
- (IBAction)vobbleClick:(id)sender
{
    long tag = ((UIButton*)sender).tag;
    if ([_viewPager currentIndex] == MY) {
        UIButton* deleteBtn = [_myVobbleViewCont.deleteBtns objectAtIndex:tag];
        if (!deleteBtn.hidden) {
            [self vobbleDelete:sender];
        }else{
            MainVobbleViewController* mainVobbleViewCont = NULL;
            if ([_viewPager currentIndex] == ALL) {
                mainVobbleViewCont = _allVobbleViewCont;
            }else if ([_viewPager currentIndex] == MY) {
                mainVobbleViewCont = _myVobbleViewCont;
            }
            if (tag >= [[mainVobbleViewCont vobbleArray] count]) {
                [mainVobbleViewCont stopAllAnimation];
                return ;
            }
            _clickVobble = [[mainVobbleViewCont vobbleArray] objectAtIndex:tag];
            _clickVobbleBtn = (UIButton*)sender;
            [self performSegueWithIdentifier:@"ToVobbleSegue" sender:self];
        }
    }else{
        MainVobbleViewController* mainVobbleViewCont = NULL;
        if ([_viewPager currentIndex] == ALL) {
            mainVobbleViewCont = _allVobbleViewCont;
        }else if ([_viewPager currentIndex] == MY) {
            mainVobbleViewCont = _myVobbleViewCont;
        }
        if (tag >= [[mainVobbleViewCont vobbleArray] count]) {
            [mainVobbleViewCont stopAllAnimation];
            return ;
        }
        _clickVobble = [[mainVobbleViewCont vobbleArray] objectAtIndex:tag];
        _clickVobbleBtn = (UIButton*)sender;
        [self performSegueWithIdentifier:@"ToVobbleSegue" sender:self];
    }
}
- (IBAction)vobbleDelete:(id)sender{
    long tag = ((UIButton*)sender).tag;
    UIButton* deleteBtn = [_myVobbleViewCont.deleteBtns objectAtIndex:tag];
    if (!deleteBtn.hidden) {
        FSAlertView *alert = [[FSAlertView alloc] initWithTitle:@"Vobble" message:NSLocalizedString(@"VOBBLE_DELETE_QUESTION", @"보블삭제?") cancelButton: [FSBlockButton blockButtonWithTitle:NSLocalizedString(@"CANCEL",@"취소") block:^ {
            
        }] otherButtons:[FSBlockButton blockButtonWithTitle:NSLocalizedString(@"CONFIRM",@"확인") block:^ {
            Vobble* deleteVobble = [[_myVobbleViewCont vobbleArray] objectAtIndex:tag];
            NSDictionary *parameters = @{@"token": [User getToken]};
            [[AFAppDotNetAPIClient sharedClient] postPath:[URL getVobbleDeleteURL:deleteVobble.vobbleId] parameters:parameters success:^(AFHTTPRequestOperation *response, id responseObject) {
                JY_LOG(@"%@ : %@",[URL getVobbleDeleteURL:deleteVobble.vobbleId],responseObject);
                if ([[responseObject objectForKey:@"result"] integerValue] != 0) {
                    [_myVobbleViewCont resetVobbleImgs];
                    [_myVobbleViewCont initVobbles];
                    [_myVobbleViewCont stopAllAnimation];
                }else{
                    [self alertNetworkError:[responseObject objectForKey:@"msg"]];
                }
            } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self alertNetworkError:NSLocalizedString(@"NETWORK_ERROR", @"네트워크 실패")];
            }];
            
            /*
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            Vobble* deleteVobble = [[_myVobbleViewCont vobbleArray] objectAtIndex:tag];
            NSDictionary *parameters = @{@"token": [User getToken]};
            [manager POST:[URL getVobbleDeleteURL:deleteVobble.vobbleId] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                JY_LOG(@"%@ : %@",[URL getVobbleDeleteURL:deleteVobble.vobbleId],responseObject);
                if ([[responseObject objectForKey:@"result"] integerValue] != 0) {
                    [_myVobbleViewCont resetVobbleImgs];
                    [_myVobbleViewCont initVobbles];
                    [_myVobbleViewCont stopAllAnimation];
                }else{
                    [self alertNetworkError:[responseObject objectForKey:@"msg"]];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self alertNetworkError:NSLocalizedString(@"NETWORK_ERROR", @"네트워크 실패")];
            }];
             */
        }],nil];
        [alert show];
    }
}
- (IBAction)recordClick:(id)sender
{
    [self performSegueWithIdentifier:@"ToCreateVobbleSegue" sender:self];
}
- (IBAction)settingClick:(id)sender{
    DoActionSheet *vActionSheet = [[DoActionSheet alloc] init];
    
    //vActionSheet.nAnimationType = DoTransitionStylePop;
    vActionSheet.nContentMode = DoContentNone;
    
    [vActionSheet showC:@""
                 cancel:@"Cancel"
                buttons:@[@"Feedback",
                          @"Tutorial",
                          @"AboutUs",
                          @"Logout"]
                 result:^(int nResult) {
                     
                     if (nResult == 0) {
                         if ([MFMailComposeViewController canSendMail]) {
                             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                 MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
                                 
                                 controller.mailComposeDelegate = self;
                                 [controller setSubject:@"Vobble Feedback!!!"];
                                 //[controller setMessageBody:[NSString stringWithFormat:@"%@ 님으로부터!",[User getUserId]] isHTML:FALSE];
                                 [controller setToRecipients:@[@"nexters.vobble@gmail.com"]];
                                 [self presentViewController:controller animated:TRUE completion:NULL];
                             });
                         }
                     }else if (nResult == 1) {
                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                             [self performSegueWithIdentifier:@"ToIntroSegue" sender:self];
                         });
                     }else if (nResult == 2) {
                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                             [self performSegueWithIdentifier:@"ToAboutSegue" sender:self];
                         });
                     }else if (nResult == 3) {
                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                             [User setLogOut];
                             [self performSegueWithIdentifier:@"ToSignSegue" sender:self];
                         });
                     }
                 }];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    if (newLocation != NULL) {
        if ([[User getLatitude] isEqualToString:@""]) {
            [User setLatitude:[NSString stringWithFormat:@"%lf",newLocation.coordinate.latitude]];
            [User setLongitude:[NSString stringWithFormat:@"%lf",newLocation.coordinate.longitude]];
            [_myVobbleViewCont initVobbles];
            [_allVobbleViewCont initVobbles];
        }else{
            float latitude = [[User getLatitude] floatValue];
            float longitude = [[User getLongitude] floatValue];
            float latitude_sub = newLocation.coordinate.latitude-latitude;
            float longitude_sub = newLocation.coordinate.longitude-longitude;
            if (sqrt(latitude_sub*latitude_sub+longitude_sub*longitude_sub) > 0.1) {
                [_myVobbleViewCont initVobbles];
                [_allVobbleViewCont initVobbles];
            }
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
#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    NSLog(@"%@",[viewController class]);
    if ([viewController isKindOfClass:[MainViewController class]]) {
        if (_prevNaviClass == [ConfirmVobbleViewController class]) {
            if (_myVobbleViewCont && _allVobbleViewCont) {
                [_myVobbleViewCont resetVobbleImgs];
                [_myVobbleViewCont initVobbles];
                [_allVobbleViewCont resetVobbleImgs];
                [_allVobbleViewCont initVobbles];
            }
        }
    }
    _prevNaviClass = [viewController class];
}
- (void)changeVobbleCnt{
    if ([_viewPager currentIndex] == ALL) {
        _vobbleCntLabel.text = [NSString stringWithFormat:@"%ld",_allVobbleViewCont.vobbleCnt];
        _vobbleDescLabel.text = @"All vobbles";
        [_vobbleCntLabel setHidden:FALSE];
        [_vobbleDescLabel setHidden:FALSE];
    }
    if ([_viewPager currentIndex] == MY) {
        _vobbleCntLabel.text = [NSString stringWithFormat:@"%ld",_myVobbleViewCont.vobbleCnt];
        _vobbleDescLabel.text = @"My vobbles";
        [_vobbleCntLabel setHidden:FALSE];
        [_vobbleDescLabel setHidden:FALSE];
    }
    if ([_viewPager currentIndex] == FRIEND) {
        [_vobbleCntLabel setHidden:TRUE];
        [_vobbleDescLabel setHidden:TRUE];
    }
}
#pragma mark - EKViewPagerDataSource
- (NSInteger)numberOfItemsForViewPager:(EKViewPager *)viewPager
{
    return 3;
}

- (NSString *)viewPager:(EKViewPager *)viewPager titleForItemAtIndex:(NSInteger)index
{
    if (index == 0) {
        return @"Everyone";
    }
    if (index == 1) {
        return @" My";
    }
    if (index == 2) {
        return @"Friend";
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
    if (index == ALL) {
        _vobbleCntLabel.text = [NSString stringWithFormat:@"%ld",_allVobbleViewCont.vobbleCnt];
        _vobbleDescLabel.text = @"All vobbles";
        [_vobbleCntLabel setHidden:FALSE];
        [_vobbleDescLabel setHidden:FALSE];
    }
    if (index == MY) {
        _vobbleCntLabel.text = [NSString stringWithFormat:@"%ld",_myVobbleViewCont.vobbleCnt];
        _vobbleDescLabel.text = @"My vobbles";
        [_vobbleCntLabel setHidden:FALSE];
        [_vobbleDescLabel setHidden:FALSE];
    }
    if (index == FRIEND) {
        [_vobbleCntLabel setHidden:TRUE];
        [_vobbleDescLabel setHidden:TRUE];
    }
}

- (void)viewPager:(EKViewPager *)viewPager willMoveFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    [_myVobbleViewCont stopAllAnimation];
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
        [_vobbleCntLabel setHidden:FALSE];
        [_vobbleDescLabel setHidden:FALSE];
    }
    if (toIndex == MY) {
        _vobbleCntLabel.text = [NSString stringWithFormat:@"%ld",_myVobbleViewCont.vobbleCnt];
        _vobbleDescLabel.text = @"My vobbles";
        [_vobbleCntLabel setHidden:FALSE];
        [_vobbleDescLabel setHidden:FALSE];
    }
    if (toIndex == FRIEND) {
        [_vobbleCntLabel setHidden:TRUE];
        [_vobbleDescLabel setHidden:TRUE];
    }
}
#pragma mark -- MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
    }
    [self dismissViewControllerAnimated:TRUE completion:NULL];
}
@end
