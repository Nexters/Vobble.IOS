//
//  MainVobbleViewController.m
//  vobble_ios
//
//  Created by Rangken on 2014. 2. 23..
//  Copyright (c) 2014년 Nexters. All rights reserved.
//

#import "MainVobbleViewController.h"
#import "MainViewController.h"
#import "IBCellFlipSegue.h"
#import "NZCircularImageView.h"
#import "SKBounceAnimation.h"
#import "App.h"
#import "User.h"
#import "Vobble.h"
#define MAX_VOBBLE_CNT 12
@interface MainVobbleViewController (){
    BOOL isConnecting;
}
@property (nonatomic, weak) IBOutlet UIButton* recordBtn;
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *buttons;
@property (nonatomic, strong) IBOutletCollection(NZCircularImageView) NSArray *imgViews;
@property (nonatomic, strong) IBOutletCollection(UIView) NSArray *vobbleViews;
@end

@implementation MainVobbleViewController

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
    isConnecting = FALSE;
    _vobbleArray = [NSMutableArray new];
    _deleteBtns = [NSMutableArray new];
    NSInteger idx = 0;
    for (UIView* vobbleView in _vobbleViews) {
        if ([[UIScreen mainScreen] bounds].size.height == 480) {
            if (idx == 3 || idx == 8 || idx == 9) {
                [vobbleView setHidden:TRUE];
            }
        }
        if (idx >= 6) {
            vobbleView.alpha = 0.5f;
        }
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:vobbleView.frame];
        [button setTag:idx++];
        [button addTarget:self.mainViewCont action:@selector(vobbleClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        if (_type == MY) {
            UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]
                                                               initWithTarget:self
                                                               action:@selector(longPress:)];
            [longPressGesture setMinimumPressDuration:1];
            [button addGestureRecognizer:longPressGesture];
            
            UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
            [button2 setFrame:CGRectMake(vobbleView.frame.origin.x+60, vobbleView.frame.origin.y-3, 25, 25)];
            [button2 setImage:[UIImage imageNamed:@"voice_remove_btn.png"] forState:UIControlStateNormal];
            [button2 setImage:[UIImage imageNamed:@"voice_remove_btn_o.png"] forState:UIControlStateSelected];
            [button2 addTarget:self.mainViewCont action:@selector(vobbleDelete:) forControlEvents:UIControlEventTouchUpInside];
            [button2 setHidden:TRUE];
            [button2 setTag:button.tag];
            [_deleteBtns addObject:button2];
            [self.view addSubview:button2];
        }
    }
    [_recordBtn addTarget:self.mainViewCont action:@selector(recordClick:) forControlEvents:UIControlEventTouchUpInside];
  
    
    [self resetVobbleImgs];
}
- (void)viewDidDisappear:(BOOL)animated{
    [self stopAllAnimation];
}
- (IBAction)tap:(UITapGestureRecognizer*)sender{
    [self stopAllAnimation];
}
- (void)longPress:(UILongPressGestureRecognizer*)gesture {
    if ( gesture.state == UIGestureRecognizerStateBegan ) {
        UIView* imgView = [_vobbleViews objectAtIndex:gesture.view.tag];
        UIButton* deleteBtn = [_deleteBtns objectAtIndex:gesture.view.tag];
        [deleteBtn setHidden:FALSE];
        [self earthquake:imgView];
        [self earthquake:deleteBtn];
    }
}

- (void)resetVobbleImgs{
    for (int i=0; i < MAX_VOBBLE_CNT; i++) {
        NZCircularImageView* imgView = [_imgViews objectAtIndex:i];
        imgView.image = NULL;
    }
}
- (void)initVobbles{
    if (isConnecting) {
        return ;
    }
    NSString* url = @"";
    if (_type == ALL) {
        url = [URL getAllVobbleURL];
        self.view.clipsToBounds = FALSE;
    }else if (_type == MY){
        url = [URL getMyVobbleURL];
        self.view.clipsToBounds = TRUE;
    }else if (_type == FRIEND){
        url = [URL getMyVobbleURL];
    }
    NSString* latitude = [User getLatitude];
    NSString* longitude = [User getLongitude];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    isConnecting = TRUE;
    
    NSDictionary *parameters = @{@"latitude": latitude,@"longitude": longitude, @"limit": @"12"};
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        JY_LOG(@"%@ : %@",[URL getAllVobbleURL],responseObject);
        if ([[responseObject objectForKey:@"result"] integerValue] != 0) {
            [_vobbleArray removeAllObjects];
            for (NSDictionary* dic in [responseObject objectForKey:@"vobbles"]) {
                Vobble* vobble = [Vobble new];
                [vobble setVobble:dic];
                [_vobbleArray addObject:vobble];
            }
            [self initVobblesAnimation];
        }else{
            [self alertNetworkError:[responseObject objectForKey:@"msg"]];
        }
        isConnecting = FALSE;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self alertNetworkError:NSLocalizedString(@"NETWORK_ERROR", @"네트워크 실패")];
        isConnecting = FALSE;
    }];
    if (_type == ALL) {
        url = [URL getAllVobbleCountURL];
        self.view.clipsToBounds = FALSE;
    }else if (_type == MY){
        url = [URL getMyVobbleCountURL];
        self.view.clipsToBounds = TRUE;
    }else if (_type == FRIEND){
        url = [URL getMyVobbleCountURL];
    }
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        JY_LOG(@"%@ : %@",[URL getAllVobbleURL],responseObject);
        if ([[responseObject objectForKey:@"result"] integerValue] != 0) {
            _vobbleCnt = [[responseObject objectForKey:@"count"] integerValue];
            [_mainViewCont changeVobbleCnt];
        }else{
            //[self alertNetworkError:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //[self alertNetworkError:NSLocalizedString(@"NETWORK_ERROR", @"네트워크 실패")];
    }];
}
- (void)initVobblesAnimation{
    for (int i=0; i < MAX_VOBBLE_CNT; i++) {
        NZCircularImageView* imgView = [_imgViews objectAtIndex:i];
        if (i >= [_vobbleArray count]) {
            imgView.image = NULL;
            return ;
        }else{
            imgView.image = [UIImage imageNamed:@"vobble_loading_icon.png"];
        }
        Vobble* vobble = [_vobbleArray objectAtIndex:i];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.13 * i * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            //[imgView setHidden:FALSE];
            [imgView setImageWithResizeURL:[vobble getImgUrl]];
            
            NSString *keyPath = @"transform";
            CATransform3D transform = imgView.layer.transform;
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
            [imgView.layer addAnimation:bounceAnimation forKey:@"scale"];
            
            [imgView.layer setValue:finalValue forKeyPath:keyPath];
            
            CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
            fadeInAnimation.fromValue = [NSNumber numberWithFloat:0.0];
            fadeInAnimation.toValue = [NSNumber numberWithFloat:1.0];
            //fadeInAnimation.beginTime = CACurrentMediaTime() + 0.2*i;
            [imgView.layer addAnimation:fadeInAnimation forKey:@"opacity"];
        });
    }
}
- (void)stopAllAnimation{
    for (int i=0; i < MAX_VOBBLE_CNT; i++) {
        UIView* vobbleView = [_vobbleViews objectAtIndex:i];
        [vobbleView.layer removeAllAnimations];
        if (i < [_deleteBtns count]) {
            UIButton* deleteBtn = [_deleteBtns objectAtIndex:i];
            [deleteBtn setHidden:TRUE];
            [deleteBtn.layer removeAllAnimations];
        }
    }
}
- (void)earthquakeAllVobbles{
    for (int i=0; i < MAX_VOBBLE_CNT; i++) {
        NZCircularImageView* imgView = [_imgViews objectAtIndex:i];
        [self earthquake:imgView];
    }
}

- (void)earthquake:(UIView*)itemView
{
    CGFloat t = 2.0;
    
    CGAffineTransform leftQuake  = CGAffineTransformTranslate(CGAffineTransformIdentity, t, -t);
    CGAffineTransform rightQuake = CGAffineTransformTranslate(CGAffineTransformIdentity, -t, t);
    
    itemView.transform = leftQuake;  // starting point
    
    [UIView beginAnimations:@"earthquake" context:(__bridge void *)(itemView)];
    [UIView setAnimationRepeatAutoreverses:YES]; // important
    [UIView setAnimationRepeatCount:INFINITY];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(earthquakeEnded:finished:context:)];
    
    itemView.transform = rightQuake; // end here & auto-reverse
    
    [UIView commitAnimations];
}

- (void)earthquakeEnded:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([finished boolValue])
    {
    	UIView* item = (__bridge UIView *)context;
    	item.transform = CGAffineTransformIdentity;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
