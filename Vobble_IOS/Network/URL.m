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
    return [NSString stringWithFormat:@"%@/files",[URL getBaseURL]];;
}
+ (NSString*)getMovieURL{
    return [NSString stringWithFormat:@"%@/videos/video.mp4",[URL getBaseURL]];
}
+ (NSString*)getEventURL{
    return [NSString stringWithFormat:@"%@/events",[URL getBaseURL]];
}
+ (NSString*)getLoginURL{
    return [NSString stringWithFormat:@"%@/tokens",[URL getBaseURL]];
}
+ (NSString*)getSignUpURL{
    return [NSString stringWithFormat:@"%@/users",[URL getBaseURL]];
}
+ (NSString*)getMeURL{
    return [NSString stringWithFormat:@"%@/users/%@",[URL getBaseURL],[User getUserId]];
}
+ (NSString*)getUserURL:(NSString*)userId{
    return [NSString stringWithFormat:@"%@/users/%@",[URL getBaseURL],userId];
}
+ (NSString*)getAllVobbleURL{
    return [NSString stringWithFormat:@"%@/vobbles",[URL getBaseURL]];
}
+ (NSString*)getAllVobbleCountURL{
    return [NSString stringWithFormat:@"%@/vobbles/count",[URL getBaseURL]];
}
+ (NSString*)getMyVobbleURL{
    return [NSString stringWithFormat:@"%@/users/%@/vobbles",[URL getBaseURL],[User getUserId]];
}
+ (NSString*)getMyVobbleCountURL{
    return [NSString stringWithFormat:@"%@/users/%@/vobbles/count",[URL getBaseURL],[User getUserId]];
}
+ (NSString*)getUploadVobbleURL{
    return [NSString stringWithFormat:@"%@/users/%@/vobbles",[URL getBaseURL],[User getUserId]];
}
+ (NSString*)getVobbleDeleteURL:(NSString*)vobbleId{
    return [NSString stringWithFormat:@"%@/users/%@/vobbles/%@/delete",[URL getBaseURL],[User getUserId],vobbleId];
}
@end
