//
//  ConfirmVobbleViewController.h
//  Vobble_IOS
//
//  Created by Rangken on 2014. 2. 23..
//  Copyright (c) 2014년 Nexters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "SuperViewController.h"
#import <CoreLocation/CoreLocation.h>
@interface ConfirmVobbleViewController : SuperViewController < CLLocationManagerDelegate >
@property (nonatomic, strong) NSURL* voiceURL;
@property (nonatomic, strong) NSURL* imageURL;
@end
