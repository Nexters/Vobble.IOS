//
//  SignViewController.m
//  Vobble_IOS
//
//  Created by Rangken on 2014. 2. 23..
//  Copyright (c) 2014년 Nexters. All rights reserved.
//

#import "SignViewController.h"
#import "App.h"
#import "SignUpViewController.h"
@interface SignViewController ()
@property (nonatomic, weak) IBOutlet UIImageView* bgImgView;
@property (nonatomic, weak) IBOutlet UIImageView* vobbleImgView;
@end

@implementation SignViewController

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
    self.navigationItem.hidesBackButton = TRUE;
    
    _vobbleImgView.alpha = 0;
    NSString *filepath   =   [[NSBundle mainBundle] pathForResource:@"intro" ofType:@"mp4"];
    NSURL    *fileURL    =   [NSURL fileURLWithPath:filepath];
    moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:fileURL];
    [_bgImgView addSubview:moviePlayerController.view];
    
    moviePlayerController.scalingMode = MPMovieScalingModeAspectFill;
    moviePlayerController.controlStyle = MPMovieControlStyleNone;
    [moviePlayerController.view setFrame:[[UIScreen mainScreen] bounds]];
    [moviePlayerController prepareToPlay];
    [moviePlayerController play];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(finishedPlayerViewCont:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:nil];
}
- (void)viewDidAppear:(BOOL)animated{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"IsAgreeCheck"]) {
        [self performSegueWithIdentifier:@"ToAgreeSegue" sender:self];
    }
    if (moviePlayerController) {
        [moviePlayerController play];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    if (moviePlayerController) {
        [moviePlayerController pause];
    }
}

- (IBAction)signUpClick:(id)sender
{
    [self performSegueWithIdentifier:@"ToSignUpSegue" sender:self];
}

- (IBAction)signInClick:(id)sender
{
    [self performSegueWithIdentifier:@"ToSignInSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ToSignUpSegue"]) {
        //SignUpViewController* signUpViewCont = segue.destinationViewController;
    }
}

-(void)finishedPlayerViewCont:(NSNotification*)userInfo{
    [moviePlayerController.view removeFromSuperview];
    [UIView animateWithDuration:2.0f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
        _vobbleImgView.alpha = 1.0f;
    }completion:^(BOOL finished){
        
    }];
}
- (void)applicationDidBecomeActive:(UIApplication *)application{
    if (moviePlayerController) {
        [moviePlayerController pause];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
