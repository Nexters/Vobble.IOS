//
//  SignUpViewController.m
//  Vobble_IOS
//
//  Created by Rangken on 2014. 2. 23..
//  Copyright (c) 2014년 Nexters. All rights reserved.
//

#import "SignUpViewController.h"
#import <MHTextField/MHTextField.h>
#import <NSString+CJStringValidator.h>
@interface SignUpViewController ()
@property (nonatomic, weak) IBOutlet UILabel* titleLabel;
@property (nonatomic, weak) IBOutlet MHTextField* nameTextField;
@property (nonatomic, weak) IBOutlet MHTextField* emailTextField;
@property (nonatomic, weak) IBOutlet MHTextField* passwordTextField;
@property (nonatomic, weak) IBOutlet MHTextField* passwordConfirmTextField;
@end

@implementation SignUpViewController

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

    if (IOS6) {
        UIImage *leftBtnImg=[UIImage imageNamed:@"back_btn_m.png"];
        UIImage *leftBtnImgOn=[UIImage imageNamed:@"back_btn.png"];
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftBtn setImage:leftBtnImg forState:UIControlStateNormal];
        [leftBtn setImage:leftBtnImgOn forState:UIControlStateHighlighted];
        [leftBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
        leftBtn.frame = CGRectMake(-10, 0,50, 50);
        UIView* containView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50+10, 50)];
        [containView addSubview:leftBtn];
        
        if (IOS6) {
            leftBtn.frame = CGRectMake(-10, 20,50, 50);
        }
        
        UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc]
                                       initWithCustomView:containView];
        self.navigationItem.leftBarButtonItem = leftBarBtn;
    }else{
        UIImage *leftBtnImg=[UIImage imageNamed:@"back_btn_m.png"];
        UIImage *leftBtnImgOn=[UIImage imageNamed:@"back_btn.png"];
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftBtn setImage:leftBtnImg forState:UIControlStateNormal];
        [leftBtn setImage:leftBtnImgOn forState:UIControlStateHighlighted];
        [leftBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
        leftBtn.frame = CGRectMake(-10, 0,50, 50);
        UIView* containView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50+10, 50)];
        [containView addSubview:leftBtn];
        
        UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc]
                                       initWithCustomView:containView];
        self.navigationItem.leftBarButtonItem = leftBarBtn;
    }
}
- (void)viewDidAppear:(BOOL)animated{
    [_nameTextField resignFirstResponder];
    [_emailTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    [_passwordConfirmTextField resignFirstResponder];
}
- (IBAction)backClick:(id)sender{
    [self.navigationController popViewControllerAnimated:TRUE];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.4f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^(void){
        if (textField == _passwordTextField) {
            self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-30, self.view.frame.size.width, self.view.frame.size.height);
        }
        if (textField == _passwordConfirmTextField) {
            self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-80, self.view.frame.size.width, self.view.frame.size.height);
        }
    }completion:^(BOOL finished){
        
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.4f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^(void){
        if (textField == _passwordTextField) {
            self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+30, self.view.frame.size.width, self.view.frame.size.height);
        }
        if (textField == _passwordConfirmTextField) {
            self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+80, self.view.frame.size.width, self.view.frame.size.height);
        }
    }completion:^(BOOL finished){
        
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return TRUE;
}

- (IBAction)signUpClick:(id)sender{
    if (![_emailTextField.text isEmail]) {
        [self alertNetworkError:NSLocalizedString(@"EMAIL_VALID_ERROR", @"이메일 인증 실패")];
        return ;
    }else if(![_passwordTextField.text isMinLength:6]){
        [self alertNetworkError:NSLocalizedString(@"EMAIL_LENGTH_ERROR", @"패스워드 길이")];
        return ;
    }else if(![_passwordTextField.text isEqualToString:_passwordConfirmTextField.text]){
        [self alertNetworkError:NSLocalizedString(@"PASSWORD_VALID_ERROR", @"패스워드 확인")];
        return ;
    }else if (![_nameTextField.text isMinLength:1]){
        [self alertNetworkError:NSLocalizedString(@"NAME_VALID_ERROR", @"이름 입력")];
        return ;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *parameters = @{@"email": _emailTextField.text,@"username": _nameTextField.text, @"password": _passwordTextField.text};
    [[AFAppDotNetAPIClient sharedClient] postPath:[URL getSignUpURL]  parameters:parameters success:^(AFHTTPRequestOperation *response, id responseObject) {
        if ([[responseObject objectForKey:@"result"] integerValue] != 0) {
            _emailTextField.text = @"";
            _nameTextField.text = @"";
            _passwordTextField.text = @"";
            _passwordConfirmTextField.text = @"";
            [self  performSegueWithIdentifier:@"ToSignInSegue" sender:self];
        }else{
            [self alertNetworkError:[responseObject objectForKey:@"msg"]];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation,NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self alertNetworkError:NSLocalizedString(@"NETWORK_ERROR", @"네트워크 실패")];
    }];
    
    /*
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"email": _emailTextField.text,@"username": _nameTextField.text, @"password": _passwordTextField.text};
    [manager POST:[URL getSignUpURL] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"result"] integerValue] != 0) {
            _emailTextField.text = @"";
            _nameTextField.text = @"";
            _passwordTextField.text = @"";
            _passwordConfirmTextField.text = @"";
            [self  performSegueWithIdentifier:@"ToSignInSegue" sender:self];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
