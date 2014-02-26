//
//  NavagtionBlurSegue.m
//  Vobble_IOS
//
//  Created by Rangken on 2014. 2. 24..
//  Copyright (c) 2014년 Nexters. All rights reserved.
//

#import "NavagtionBlurSegue.h"
#import <QuartzCore/QuartzCore.h>
#import <UIImage+BlurredFrame/UIImage+ImageEffects.h>
#import <MZAppearance/MZAppearance.h>
@implementation NavagtionBlurSegue
+ (id)appearance
{
    return [MZAppearance appearanceForClass:[self class]];
}

- (id)initWithIdentifier:(NSString *)identifier source:(UIViewController *)source destination:(UIViewController *)destination
{
    self = [super initWithIdentifier:identifier source:source destination:destination];
    
    if (self)
    {
        // Some sane defaults
        self.backingImageBlurRadius = @(20);
        self.backingImageSaturationDeltaFactor = @(.85f);
        
        [[[self class] appearance] applyInvocationTo:self];
    }
    
    return self;
}

- (void)perform
{
    UIViewController* source = (UIViewController*)self.sourceViewController;
    UIViewController* destination = (UIViewController*)self.destinationViewController;
    
    CGRect windowBounds = source.view.window.bounds;
    CGSize windowSize = windowBounds.size;
    
    UIGraphicsBeginImageContextWithOptions(windowSize, YES, 0.0);
    [source.view.window drawViewHierarchyInRect:windowBounds afterScreenUpdates:NO];
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    if (self.processBackgroundImage)
    {
        snapshot = self.processBackgroundImage(self, snapshot);
    }
    else
    {
        snapshot = [snapshot applyBlurWithRadius:self.backingImageBlurRadius.doubleValue
                                       tintColor:self.backingImageTintColor
                           saturationDeltaFactor:self.backingImageSaturationDeltaFactor.doubleValue
                                       maskImage:nil];
    }
    
    destination.view.clipsToBounds = YES;
    
    UIImageView* backgroundImageView = [[UIImageView alloc] initWithImage:snapshot];
    
    CGRect frame;
    switch (destination.modalTransitionStyle) {
        case UIModalTransitionStyleCoverVertical:
            // Only the CoverVertical transition make sense to have an
            // animation on the background to make it look still while
            // destination view controllers animates from the bottom to top
            frame = CGRectMake(0, -windowSize.height, windowSize.width, windowSize.height);
            break;
        default:
            frame = CGRectMake(0, 0, windowSize.width, windowSize.height);
            break;
    }
    backgroundImageView.frame = frame;
    
    [destination.view addSubview:backgroundImageView];
    [destination.view sendSubviewToBack:backgroundImageView];
    
    [source.navigationController pushViewController:self.destinationViewController animated:YES];
    //[self.sourceViewController presentModalViewController:self.destinationViewController animated:YES];
    
    [destination.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [UIView animateWithDuration:[context transitionDuration] animations:^{
            backgroundImageView.frame = CGRectMake(0, 0, windowSize.width, windowSize.height);
        }];
    } completion:nil];
}
@end
