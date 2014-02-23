//
//  AppDelegate.h
//  Vobble_IOS
//
//  Created by Rangken on 2014. 2. 23..
//  Copyright (c) 2014년 Nexters. All rights reserved.
//

#import <UIKit/UIKit.h>
#define APP_DELEGATE (AppDelegate *)[[UIApplication sharedApplication] delegate]
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
- (void)transitionToViewController:(UIViewController *)viewController
                    withTransition:(UIViewAnimationOptions)transition;
@end
