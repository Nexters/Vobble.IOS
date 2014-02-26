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
@interface MainVobbleViewController ()
@property (nonatomic, weak) IBOutlet UIButton* recordBtn;
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *buttons;
@property (nonatomic, strong) IBOutletCollection(NZCircularImageView) NSArray *imgViews;

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
    _vobbleArray = [NSMutableArray new];
    NSInteger idx = 0;
    for (NZCircularImageView* imgView in _imgViews) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:imgView.frame];
        [button setTag:idx++];
        [button addTarget:self.mainViewCont action:@selector(vobbleClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    [_recordBtn addTarget:self.mainViewCont action:@selector(recordClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)initVobbles{
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
    [_vobbleArray removeAllObjects];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"latitude": latitude,@"longitude": longitude, @"limit": @"12"};
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        JY_LOG(@"%@ : %@",[URL getAllVobbleURL],responseObject);
        if ([[responseObject objectForKey:@"result"] integerValue] != 0) {
            for (NSDictionary* dic in [responseObject objectForKey:@"vobbles"]) {
                Vobble* vobble = [Vobble new];
                [vobble setVobble:dic];
                [_vobbleArray addObject:vobble];
            }
            [self initVobblesAnimation];
        }else{
            [self alertNetworkError:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self alertNetworkError:NSLocalizedString(@"NETWORK_ERROR", @"네트워크 실패")];
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
        }else{
            //[self alertNetworkError:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //[self alertNetworkError:NSLocalizedString(@"NETWORK_ERROR", @"네트워크 실패")];
    }];
}
- (void)initVobblesAnimation{
    for (int i=0; i < MAX_VOBBLE_CNT; i++) {
        if (i >= [_vobbleArray count]) {
            return ;
        }
        NZCircularImageView* imgView = [_imgViews objectAtIndex:i];
        Vobble* vobble = [_vobbleArray objectAtIndex:i];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * i * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [imgView setHidden:FALSE];
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
