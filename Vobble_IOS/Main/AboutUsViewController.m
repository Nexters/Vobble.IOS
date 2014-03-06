//
//  AboutUsViewController.m
//  Vobble_IOS
//
//  Created by Rangken on 2014. 3. 6..
//  Copyright (c) 2014년 Nexters. All rights reserved.
//

#import "AboutUsViewController.h"
#import "SKBounceAnimation.h"
#import "EventViewController.h"
@interface AboutUsViewController ()
{
    CGRect frames[5];
}
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *buttons;
@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *titleLabels;
@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *nameLabels;
@property (nonatomic, weak) IBOutlet UILabel* descriptionLabel;
@end

@implementation AboutUsViewController

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
    int i = 0;
	for (UIButton* btn in _buttons) {
        btn.tag = i;
        frames[i] = btn.frame;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.13 * i * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            
            NSString *keyPath = @"transform";
            CATransform3D transform = btn.layer.transform;
            id fromValue = [NSValue valueWithCATransform3D:
                            CATransform3DScale(transform, 0.2, 0.2, 0.2)
                            ];
            id finalValue = [NSValue valueWithCATransform3D:
                             CATransform3DScale(transform, 1.0, 1.0, 1.0)
                             ];
            
            SKBounceAnimation *bounceAnimation = [SKBounceAnimation animationWithKeyPath:keyPath];
            bounceAnimation.fromValue = fromValue;
            bounceAnimation.toValue = finalValue;
            bounceAnimation.duration = 0.5f;
            bounceAnimation.numberOfBounces = 2;
            //bounceAnimation.shouldOvershoot = YES;
            //bounceAnimation.beginTime = CACurrentMediaTime() + 0.2*i;
            [btn.layer addAnimation:bounceAnimation forKey:@"scale"];
            
            [btn.layer setValue:finalValue forKeyPath:keyPath];
            
            CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
            fadeInAnimation.fromValue = [NSNumber numberWithFloat:0.0];
            fadeInAnimation.toValue = [NSNumber numberWithFloat:1.0];
            //fadeInAnimation.beginTime = CACurrentMediaTime() + 0.2*i;
            [btn.layer addAnimation:fadeInAnimation forKey:@"opacity"];
        });
        i++;
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"ToWebSegue"]) {
        EventViewController *eventViewCont = segue.destinationViewController;
        eventViewCont.type = EVENT_APPS;
    }
}
- (IBAction)memberClick:(id)sender{
    UIButton* sel_btn = (UIButton*)sender;
    int i = 0;
	for (UIButton* btn in _buttons) {
        UILabel* title_label = [_titleLabels objectAtIndex:i];
        UILabel* name_label = [_nameLabels objectAtIndex:i];
        if (sel_btn == btn) {
            [self.view bringSubviewToFront:btn];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.13 * i * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5f delay:0.0f usingSpringWithDamping:0.5f initialSpringVelocity:5.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void){
                if (CGRectEqualToRect(btn.frame, frames[i])) {
                    // 얼레 위치
                    btn.frame = sel_btn.frame;
                    if (sel_btn != btn) {
                        title_label.alpha = 0.0f;
                        name_label.alpha = 0.0f;
                    }
                }else{
                    // 합쳐진 위치
                    btn.frame = frames[i];
                    title_label.alpha = 1.0f;
                    name_label.alpha = 1.0f;
                }
            }completion:^(BOOL finished){
                
            }];
        });
        i++;
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
