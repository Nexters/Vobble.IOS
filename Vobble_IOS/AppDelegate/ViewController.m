//
//  ViewController.m
//  Vobble_IOS
//
//  Created by Rangken on 2014. 2. 23..
//  Copyright (c) 2014년 Nexters. All rights reserved.
//

#import "ViewController.h"
#import "IntroViewController.h"
#import "AppDelegate.h"
#import "User.h"
#import <MediaPlayer/MediaPlayer.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    /*
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(finishedPlayerViewCont:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:nil];
    */
	NSTimer* timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(AfterSplash:) userInfo:nil repeats:FALSE];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}
- (void)viewDidAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated{
}
- (void)AfterSplash:(id)sender{
    
    /*
    BOOL isViewIntro = [[NSUserDefaults standardUserDefaults] boolForKey:@"IsViewIntro"];
    if (!isViewIntro) {
        MPMoviePlayerViewController *playerView = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:[URL getMovieURL]]];
        [self presentMoviePlayerViewControllerAnimated:playerView];
    }else{
        if ([[User getToken] length] == 0) {
            [self performSegueWithIdentifier:@"ToSignSegue" sender:self];
        }else{
            [self performSegueWithIdentifier:@"ToMainSegue" sender:self];
        }
        
    }*/
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"IsAgreeCheck"]) {
        [self performSegueWithIdentifier:@"ToAgreeSegue" sender:self];
    }else if ([[User getToken] length] == 0) {
        [self performSegueWithIdentifier:@"ToSignSegue" sender:self];
    }else{
        [self performSegueWithIdentifier:@"ToMainSegue" sender:self];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
