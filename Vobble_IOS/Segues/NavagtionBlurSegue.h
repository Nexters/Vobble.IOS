//
//  NavagtionBlurSegue.h
//  Vobble_IOS
//
//  Created by Rangken on 2014. 2. 24..
//  Copyright (c) 2014년 Nexters. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NavagtionBlurSegue;
typedef UIImage*(^ProcessBackgroundImage)(NavagtionBlurSegue* blurryModalSegue, UIImage* rawImage);

@interface NavagtionBlurSegue : UIStoryboardSegue
@property (nonatomic, copy) ProcessBackgroundImage processBackgroundImage;

@property (nonatomic) NSNumber* backingImageBlurRadius UI_APPEARANCE_SELECTOR;
@property (nonatomic) NSNumber* backingImageSaturationDeltaFactor UI_APPEARANCE_SELECTOR;
@property (nonatomic) UIColor* backingImageTintColor UI_APPEARANCE_SELECTOR;

+ (id)appearance;
@end
