//
//  Vobble.m
//  Vobble_IOS
//
//  Created by Rangken on 2014. 2. 25..
//  Copyright (c) 2014년 Nexters. All rights reserved.
//

#import "Vobble.h"
#import "URL.h"
@implementation Vobble
- (void)setVobble:(NSDictionary*)dic{
    _latitude = [[dic objectForKey:@"latitude"] doubleValue];
    _longitude = [[dic objectForKey:@"longitude"] doubleValue];
    _distance = [[dic objectForKey:@"distance"] floatValue];
    _imgUrl = [dic objectForKey:@"image_uri"];
    _userId = [dic objectForKey:@"user_id"];
    _vobbleId = [dic objectForKey:@"vobble_id"];
    _voiceUrl = [dic objectForKey:@"voice_uri"];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    NSDate *date = [dateFormat dateFromString:[dic objectForKey:@"created_at"]];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    _createdAt = [NSString stringWithFormat:@"%ld-%02ld-%02ld",components.year,components.month,components.day];
}
- (NSString*)getImgUrl{
    return [NSString stringWithFormat:@"%@/%@",[URL getFilesURL],_imgUrl];
}
- (NSString*)getVoiceUrl{
    return [NSString stringWithFormat:@"%@/%@",[URL getFilesURL],_voiceUrl];
}
@end
