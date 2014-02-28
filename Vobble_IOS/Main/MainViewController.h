//
//  MainViewController.h
//  Vobble_IOS
//
//  Created by Rangken on 2014. 2. 23..
//  Copyright (c) 2014년 Nexters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "EasyViewPager.h"
#import "MainVobbleViewController.h"
#import "Vobble.h"
@interface MainViewController : UIViewController <EKViewPagerDataSource, EKViewPagerDelegate, CLLocationManagerDelegate, UINavigationControllerDelegate >
@property (nonatomic, assign) Class prevNaviClass;
@property (nonatomic, weak) IBOutlet EKViewPager *viewPager;
@property (nonatomic, weak) IBOutlet UILabel* vobbleCntLabel;
@property (nonatomic, weak) IBOutlet UILabel* vobbleDescLabel;
@property (nonatomic, weak) IBOutlet UIPageControl* pageControl;
@property (nonatomic, strong) UIButton* clickVobbleBtn;
@property (nonatomic, strong) Vobble* clickVobble;
@property (nonatomic, strong) MainVobbleViewController* myVobbleViewCont;
@property (nonatomic, strong) MainVobbleViewController* allVobbleViewCont;
@end
