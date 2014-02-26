//
//  Vobble.h
//  Vobble_IOS
//
//  Created by Rangken on 2014. 2. 25..
//  Copyright (c) 2014년 Nexters. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Vobble : NSObject
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, assign) float distance;
@property (nonatomic, strong) NSString* imgUrl;
@property (nonatomic, strong) NSString* userId;
@property (nonatomic, strong) NSString* vobbleId;
@property (nonatomic, strong) NSString* voiceUrl;
@property (nonatomic, strong) NSString* createdAt;
-(void)setVobble:(NSDictionary*)dic;
- (NSString*)getImgUrl;
- (NSString*)getVoiceUrl;
@end
