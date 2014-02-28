//
//  AgreeViewController.m
//  Vobble_IOS
//
//  Created by Rangken on 2014. 2. 28..
//  Copyright (c) 2014년 Nexters. All rights reserved.
//

#import "AgreeViewController.h"

@interface AgreeViewController ()

@end

@implementation AgreeViewController

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
	// Do any additional setup after loading the view.
}

- (IBAction)disAgreeClick:(id)sender{
    exit(0);
}

- (IBAction)agreeClick:(id)sender{
    [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"IsAgreeCheck"];
    [self performSegueWithIdentifier:@"ToSignSegue" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
