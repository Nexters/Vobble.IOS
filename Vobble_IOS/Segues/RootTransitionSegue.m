//
//  RootTransitionSegue.m
//  Vobble_IOS
//
//  Created by Rangken on 2014. 2. 23..
//  Copyright (c) 2014년 Nexters. All rights reserved.
//

#import "RootTransitionSegue.h"
#import "AppDelegate.h"
@implementation RootTransitionSegue
- (void)perform {
    UIViewController *destinationViewController = self.destinationViewController;
    [APP_DELEGATE transitionToViewController:destinationViewController withTransition:UIViewAnimationOptionTransitionNone];
}
@end
