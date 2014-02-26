//
//  Pin.m
//  Vobble_IOS
//
//  Created by Rangken on 2014. 2. 25..
//  Copyright (c) 2014년 Nexters. All rights reserved.
//

#import "Pin.h"

@implementation Pin
- (id)initWithCoordinates:(CLLocationCoordinate2D)location placeName:placeName description:description {
    self = [super init];
    if (self != nil) {
        _coordinate = location;
        _title = placeName;
        _subTitle = description;
    }
    return self;
}
@end
