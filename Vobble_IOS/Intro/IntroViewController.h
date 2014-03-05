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
typedef enum eIntroType{
    INTRO_FIRST,
    INTRO_MENU
}eIntroType;
@interface IntroViewController : SuperViewController <UIScrollViewDelegate, PunchScrollViewDataSource, PunchScrollViewDelegate, UIPageViewControllerDelegate>
@property (nonatomic, weak) IBOutlet PunchScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIPageControl* pageControl;
@property (nonatomic, assign) eIntroType type;
@end
