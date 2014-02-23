//
//  App.h
//  Vobble_IOS
//
//  Created by Rangken on 2014. 2. 23..
//  Copyright (c) 2014년 Nexters. All rights reserved.
//

#import <Foundation/Foundation.h>
static NSString* INTRO_MOVIE_URL = @"http://54.199.171.240:3000/videos/video.mp4";
#define MINT_COLOR [UIColor colorWithRed:41/255.0f green:240/255.0f blue:186/255.0f alpha:1]
@interface App : NSObject
+(void)LOG:(NSString*)str;
@end
