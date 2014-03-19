//
//  URL.m
//  Vobble_IOS
//
//  Created by Rangken on 2014. 2. 23..
//  Copyright (c) 2014년 Nexters. All rights reserved.
//

#import "URL.h"
#import "User.h"
@implementation URL
+ (NSString*)getBaseURL{
    return BASE_URL;
}
+ (NSString*)getFilesURL{
    return [NSString stringWithFormat:@"%@/files",[self getBaseURL]];
}
+ (NSString*)getMovieURL{
    return [NSString stringWithFormat:@"%@/videos/video.mp4",[self getBaseURL]];
}
+ (NSString*)getEventURL{
    return [NSString stringWithFormat:@"%@/events",[self getBaseURL]];
}
+ (NSString*)getLoginURL{
    return @"tokens";
}
+ (NSString*)getSignUpURL{
    return @"users";
}
+ (NSString*)getMeURL{
    return [NSString stringWithFormat:@"users/%@",[User getUserId]];
}
+ (NSString*)getUserURL:(NSString*)userId{
    return [NSString stringWithFormat:@"users/%@",userId];
}
+ (NSString*)getAllVobbleURL{
    return @"vobbles";
}
+ (NSString*)getAllVobbleCountURL{
    return @"vobbles/count";
}
+ (NSString*)getMyVobbleURL{
    return [NSString stringWithFormat:@"users/%@/vobbles",[User getUserId]];
}
+ (NSString*)getMyVobbleCountURL{
    return [NSString stringWithFormat:@"users/%@/vobbles/count",[User getUserId]];
}
+ (NSString*)getUploadVobbleURL{
    return [NSString stringWithFormat:@"users/%@/vobbles",[User getUserId]];
}
+ (NSString*)getVobbleDeleteURL:(NSString*)vobbleId{
    return [NSString stringWithFormat:@"users/%@/vobbles/%@/delete",[User getUserId],vobbleId];
}
+ (NSString*)getVobbleReportURL:(NSString*)vobbleId{
    return [NSString stringWithFormat:@"vobbles/%@/report",vobbleId];
}
@end
