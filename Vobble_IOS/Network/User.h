//
//  User.h
//  Vobble_IOS
//
//  Created by Rangken on 2014. 2. 25..
//  Copyright (c) 2014년 Nexters. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
@property (nonatomic, strong) NSString* userId;
@property (nonatomic, strong) NSString* email;
@property (nonatomic, strong) NSString* userName;
+(NSString*)getToken;
+(NSString*)getUserId;
+(NSString*)getLatitude;
+(NSString*)getLongitude;
+(void)setLatitude:(NSString*)str;
+(void)setLongitude:(NSString*)str;
@end
