//
//  URL.h
//  Vobble_IOS
//
//  Created by Rangken on 2014. 2. 23..
//  Copyright (c) 2014년 Nexters. All rights reserved.
//

#import <Foundation/Foundation.h>
#define BASE_URL @"http://54.199.171.240:3000";
//#define BASE_URL @"http://54.199.171.240:3001";
@interface URL : NSObject

+ (NSString*)getBaseURL;
+ (NSString*)getFilesURL;
+ (NSString*)getMovieURL;
+ (NSString*)getEventURL;
+ (NSString*)getLoginURL;
+ (NSString*)getSignUpURL;
+ (NSString*)getMeURL;
+ (NSString*)getUserURL:(NSString*)userId;
+ (NSString*)getAllVobbleURL;
+ (NSString*)getAllVobbleCountURL;
+ (NSString*)getMyVobbleURL;
+ (NSString*)getMyVobbleCountURL;
+ (NSString*)getUploadVobbleURL;
@end
