//
//  SignInViewController.m
//  Vobble_IOS
//
//  Created by Rangken on 2014. 2. 23..
//  Copyright (c) 2014년 Nexters. All rights reserved.
//

#import "SignInViewController.h"
#import "URL.h"
#import <MHTextField/MHTextField.h>
#import <NSString+CJStringValidator.h>
@interface SignInViewController ()
@property (nonatomic, weak) IBOutlet MHTextField* emailTextField;
@property (nonatomic, weak) IBOutlet MHTextField* passwordTextField;
@end

@implementation SignInViewController

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
    UIBarButtonItem *backBtn =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    [self.navigationItem setBackBarButtonItem:backBtn];
}
- (void)viewDidAppear:(BOOL)animated{
    [_emailTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}
- (IBAction)signInClick:(id)sender{
    if (![_emailTextField.text isEmail]) {
        [self alertNetworkError:NSLocalizedString(@"EMAIL_VALID_ERROR", @"이메일 인증 실패")];
        return ;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *parameters = @{@"email": _emailTextField.text,@"password": _passwordTextField.text};
    [[AFAppDotNetAPIClient sharedClient] postPath:[URL getLoginURL] parameters:parameters success:^(AFHTTPRequestOperation *response, id responseObject) {
        JY_LOG(@"%@ : %@",[URL getLoginURL],responseObject);
        if ([[responseObject objectForKey:@"result"] integerValue] != 0) {
            [[NSUserDefaults standardUserDefaults] setValue:[responseObject objectForKey:@"token"] forKey:@"Token"];
            [[NSUserDefaults standardUserDefaults] setValue:[responseObject objectForKey:@"user_id"] forKey:@"UserId"];
            [self  performSegueWithIdentifier:@"ToMainInSegue" sender:self];
        }else{
            [self alertNetworkError:[responseObject objectForKey:@"msg"]];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self alertNetworkError:NSLocalizedString(@"NETWORK_ERROR", @"네트워크 실패")];
    }];
    /*
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"email": _emailTextField.text,@"password": _passwordTextField.text};
    [manager POST:[URL getLoginURL] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        JY_LOG(@"%@ : %@",[URL getLoginURL],responseObject);
        if ([[responseObject objectForKey:@"result"] integerValue] != 0) {
            [[NSUserDefaults standardUserDefaults] setValue:[responseObject objectForKey:@"token"] forKey:@"Token"];
            [[NSUserDefaults standardUserDefaults] setValue:[responseObject objectForKey:@"user_id"] forKey:@"UserId"];
            [self  performSegueWithIdentifier:@"ToMainInSegue" sender:self];
        }else{
            [self alertNetworkError:[responseObject objectForKey:@"msg"]];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self alertNetworkError:NSLocalizedString(@"NETWORK_ERROR", @"네트워크 실패")];
    }];
     */
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return TRUE;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
