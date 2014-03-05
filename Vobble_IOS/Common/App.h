//
//  App.h
//  Vobble_IOS
//
//  Created by Rangken on 2014. 2. 23..
//  Copyright (c) 2014년 Nexters. All rights reserved.
//

#import <Foundation/Foundation.h>
#define CLICK_GRAY_COLOR [UIColor colorWithRed:110/255.0f green:111/255.0f blue:113/255.0f alpha:0.7f]
#define MINT_COLOR [UIColor colorWithRed:0x40/255.0f green:0xdd/255.0f blue:0xc2/255.0f alpha:1]
#define ORANGE_COLOR [UIColor colorWithRed:0xff/255.0f green:0x79/255.0f blue:0x63/255.0f alpha:1]
#define NEXTERS_APPS_URL @"http://www.teamnexters.com/apps"

@interface App : NSObject
+(void)LOG:(NSString*)str;
@end
