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
    UIBarButtonItem *backBtn =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    [self.navigationItem setBackBarButtonItem:backBtn];
    
    self.navigationController.navigationBar.tintColor = MINT_COLOR;
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
