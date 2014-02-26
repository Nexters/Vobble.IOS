//
//  User.m
//  Vobble_IOS
//
//  Created by Rangken on 2014. 2. 25..
//  Copyright (c) 2014년 Nexters. All rights reserved.
//

#import "User.h"

@implementation User
static NSString * latitude = @"";
static NSString * logitude = @"";
+(NSString*)getToken{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"Token"];
}
+(NSString*)getUserId{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"];
}
+(void)setLogOut{
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Token"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"UserId"];
}
+(NSString*)getLatitude{
    return latitude;
}
+(NSString*)getLongitude{
    return latitude;
}
+(void)setLatitude:(NSString*)str{
    latitude = str;
}
+(void)setLongitude:(NSString*)str{
    logitude = str;
}
@end
