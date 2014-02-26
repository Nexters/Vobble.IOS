//
//  VobbleViewController.h
//  Vobble_IOS
//
//  Created by Rangken on 2014. 2. 23..
//  Copyright (c) 2014년 Nexters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Vobble.h"
#import "SuperViewController.h"
@interface VobbleViewController : SuperViewController <MKMapViewDelegate>
@property (readwrite, nonatomic) CGPoint vobbleOrignalCenter;
@property (readwrite, nonatomic) CGRect vobbleOriginalRect;
@property (nonatomic, strong) Vobble* vobble;
@end
