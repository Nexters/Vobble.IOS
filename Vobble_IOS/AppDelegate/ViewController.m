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
#import <MediaPlayer/MediaPlayer.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(finishedPlayerViewCont:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:nil];
    
	NSTimer* timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(AfterSplash:) userInfo:nil repeats:FALSE];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}
- (void)viewDidAppear:(BOOL)animated{
    
}

- (void)viewDidDisappear:(BOOL)animated{
}
- (void)AfterSplash:(id)sender{
    BOOL isViewIntro = [[NSUserDefaults standardUserDefaults] boolForKey:@"IsViewIntro"];
    if (!isViewIntro) {
        MPMoviePlayerViewController *playerView = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:INTRO_MOVIE_URL]];
        [self presentMoviePlayerViewControllerAnimated:playerView];
    }else{
        [self performSegueWithIdentifier:@"ToSignSegue" sender:self];
    }
}

-(void)finishedPlayerViewCont:(NSNotification*)userInfo{
    [self performSegueWithIdentifier:@"ToIntroSegue" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
