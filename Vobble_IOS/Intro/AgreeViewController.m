//
//  AgreeViewController.m
//  Vobble_IOS
//
//  Created by Rangken on 2014. 2. 28..
//  Copyright (c) 2014년 Nexters. All rights reserved.
//

#import "AgreeViewController.h"
#import "IntroViewController.h"
#import "AMBlurView.h"
@interface AgreeViewController ()
@property (nonatomic, weak) IBOutlet UIImageView* bgImgView;
@property (nonatomic, weak) IBOutlet UIButton* agreeBtn;
@property (nonatomic, weak) IBOutlet UIButton* disAgreeBtn;
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
    if (IOS7) {
        AMBlurView* blurView = [AMBlurView new];
        if (IPHONE4) {
            [blurView setFrame:CGRectMake(15, 45, 290, 498-100)];
        }else{
            [blurView setFrame:CGRectMake(15, 45, 290, 498)];
        }
        //blurView.layer.cornerRadius = 8;
        blurView.alpha = 0.7;
        [_bgImgView addSubview:blurView];
    }else{
        UIView* blurView = [UIView new];
        if (IPHONE4) {
            [blurView setFrame:CGRectMake(15, 45, 290, 498-100)];
        }else{
            [blurView setFrame:CGRectMake(15, 45, 290, 498)];
        }
        //blurView.layer.cornerRadius = 8;
        blurView.alpha = 0.7;
        [blurView setBackgroundColor:[UIColor whiteColor]];
        [_bgImgView addSubview:blurView];
    }
    
    //_agreeBtn.layer.cornerRadius = 4;
    //_disAgreeBtn.layer.cornerRadius = 4;
    if (IPHONE4) {
        _agreeBtn.frame = CGRectMake(_agreeBtn.frame.origin.x, _agreeBtn.frame.origin.y+20, _agreeBtn.frame.size.width, _agreeBtn.frame.size.height);
        _disAgreeBtn.frame = CGRectMake(_disAgreeBtn.frame.origin.x, _disAgreeBtn.frame.origin.y+20, _disAgreeBtn.frame.size.width, _disAgreeBtn.frame.size.height);
    }
	// Do any additional setup after loading the view.
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"ToIntroSegue"]) {
        IntroViewController *introViewCont = segue.destinationViewController;
        introViewCont.type = INTRO_FIRST;
    }
}

- (IBAction)agreeClick:(id)sender{
    [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"IsAgreeCheck"];
    [self performSegueWithIdentifier:@"ToIntroSegue" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
