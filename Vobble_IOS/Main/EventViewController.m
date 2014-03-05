//
//  EventViewController.m
//  Vobble_IOS
//
//  Created by Rangken on 2014. 2. 23..
//  Copyright (c) 2014년 Nexters. All rights reserved.
//

#import "EventViewController.h"
#import "BlurryModalSegue.h"
#import "App.h"
@interface EventViewController ()
@property (nonatomic, weak) IBOutlet UIButton* exitBtn;
@end

@implementation EventViewController

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
    if (_type == EVENT_NOTICE) {
        NSURLRequest* request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[URL getEventURL]]];
        [_webView loadRequest:request];
        [self.view setBackgroundColor:[UIColor blackColor]];
        [self.view setTintColor:[UIColor blackColor]];
        [_webView setFrame:CGRectMake(_webView.frame.origin.x, _webView.frame.origin.y+20, _webView.frame.size.width, _webView.frame.size.height)];
        [_exitBtn setFrame:CGRectMake(_exitBtn.frame.origin.x, _exitBtn.frame.origin.y+5, _exitBtn.frame.size.width, _exitBtn.frame.size.height)];
    }else if (_type == EVENT_APPS){
        NSURLRequest* request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:NEXTERS_APPS_URL]];
        [_webView loadRequest:request];
        [_webView loadRequest:request];
        [_webView setFrame:CGRectMake(_webView.frame.origin.x, _webView.frame.origin.y+30, _webView.frame.size.width, _webView.frame.size.height)];
        [_exitBtn setSelected:TRUE];
    }
    
}

- (IBAction)backClick:(id)sender{
    [self.presentingViewController dismissViewControllerAnimated:TRUE completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
