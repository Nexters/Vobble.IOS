//
//  IntroViewController.h
//  Vobble_IOS
//
//  Created by Rangken on 2014. 2. 23..
//  Copyright (c) 2014년 Nexters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
#import "PunchScrollView.h"
@interface IntroViewController : SuperViewController <UIScrollViewDelegate, PunchScrollViewDataSource, PunchScrollViewDelegate>
@property (strong, nonatomic) IBOutlet PunchScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIPageControl* pageControl;
@end
