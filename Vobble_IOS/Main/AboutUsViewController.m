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
    NSArray* nameArr;
    NSArray* descriptionArr;
    NSString* nameStr;
    NSString* descriptionStr;
    
    NSTimer* timer;
}
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *buttons;
@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *titleLabels;
@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *nameLabels;
@property (nonatomic, weak) IBOutlet UILabel* nameLabel;
@property (nonatomic, weak) IBOutlet UILabel* descriptionLabel;
@property (nonatomic, weak) IBOutlet UIButton* moreAppBtn;
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
    if (IPHONE4) {
        _moreAppBtn.hidden = TRUE;
    }
    int i = 0;
    nameArr = @[@"Hansol Shin",@"",@"Soyoon Kim",@"blaswan",@"ksjin"];
    descriptionArr = @[@"넥터 크리스탈!!!",@"넥터 상남자!!!",@"넥터 귀염둥이!!!",@"넥터 엄친남!!!",@"넥터 최고미녀!!!"];
    
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
    _nameLabel.text = @"";
    _descriptionLabel.text = @"";
    
    UIButton* sel_btn = (UIButton*)sender;
    int i = 0;
	for (UIButton* btn in _buttons) {
        btn.userInteractionEnabled = FALSE;
        UILabel* title_label = [_titleLabels objectAtIndex:i];
        UILabel* name_label = [_nameLabels objectAtIndex:i];
        if (sel_btn == btn) {
            [self.view bringSubviewToFront:btn];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.13 * i * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5f delay:0.0f usingSpringWithDamping:0.5f initialSpringVelocity:5.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void){
                if (CGRectEqualToRect(btn.frame, frames[i])) {
                    // 얼레 위치 - 합치기
                    btn.frame = sel_btn.frame;
                    if (sel_btn != btn) {
                        title_label.alpha = 0.0f;
                        name_label.alpha = 0.0f;
                    }
                }else{
                    // 합쳐진 위치 - 펼치기
                    btn.frame = frames[i];
                    title_label.alpha = 1.0f;
                    name_label.alpha = 1.0f;
                }
            }completion:^(BOOL finished){
                UIButton* btn1 = [_buttons objectAtIndex:0];
                UIButton* btn2 = [_buttons objectAtIndex:1];
                if (btn.tag == 4) {
                    if (CGRectEqualToRect(btn1.frame, btn2.frame)) {
                        switch (sel_btn.tag) {
                            case 0:
                                _descriptionLabel.center = CGPointMake(160, 360);
                                break;
                            case 1:
                                _descriptionLabel.center = CGPointMake(160, 360);
                                break;
                            case 2:
                                _descriptionLabel.center = CGPointMake(160, 360);
                                break;
                            case 3:
                                _descriptionLabel.center = CGPointMake(160, 196);
                                break;
                            case 4:
                                _descriptionLabel.center = CGPointMake(160, 196);
                                break;
                            default:
                                break;
                        }
                        descriptionStr = [descriptionArr objectAtIndex:sel_btn.tag];
                        timer = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(updateText:) userInfo:nil repeats:YES];
                    }else{
                        for (UIButton* btn in _buttons){
                            btn.userInteractionEnabled = TRUE;
                        }
                    }
                    
                }
            }];
        });
        i++;
    }
}
- (void)updateText:(id)sender{
    NSUInteger textCnt = _descriptionLabel.text.length;
    if (textCnt == descriptionStr.length) {
        for (UIButton* btn in _buttons){
            btn.userInteractionEnabled = TRUE;
        }
        [timer invalidate];
        return ;
    }
    _descriptionLabel.text = [descriptionStr substringToIndex:textCnt+1];
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
