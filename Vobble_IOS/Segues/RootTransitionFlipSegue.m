//
//  RootTransitionFlipSegue.m
//  Vobble_IOS
//
//  Created by Rangken on 2014. 2. 23..
//  Copyright (c) 2014년 Nexters. All rights reserved.
//

#import "RootTransitionFlipSegue.h"
#import "AppDelegate.h"
@implementation RootTransitionFlipSegue
- (void)perform {
    UIViewController *destinationViewController = self.destinationViewController;
    [APP_DELEGATE transitionToViewController:destinationViewController withTransition:UIViewAnimationOptionTransitionFlipFromLeft];
}
@end
