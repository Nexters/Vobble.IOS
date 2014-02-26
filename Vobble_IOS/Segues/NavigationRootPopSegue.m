//
//  NavigationRootPopSegue.m
//  Vobble_IOS
//
//  Created by Rangken on 2014. 2. 26..
//  Copyright (c) 2014년 Nexters. All rights reserved.
//

#import "NavigationRootPopSegue.h"

@implementation NavigationRootPopSegue
-(void)perform {
    UIViewController *sourceViewController = (UIViewController*)[self sourceViewController];
    UIViewController *destinationController = (UIViewController*)[self destinationViewController];
    /*
     CATransition* transition = [CATransition animation];
     transition.type = kCATransitionPush;
     transition.subtype = kCATransitionFromLeft;
     
     [sourceViewController.navigationController.view.layer addAnimation:transition forKey:kCATransition];
     */
    [sourceViewController.navigationController popToRootViewControllerAnimated:TRUE];
}
@end
