//
//  Track.h
//  Vobble_IOS
//
//  Created by Rangken on 2014. 2. 25..
//  Copyright (c) 2014년 Nexters. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DOUAudioFile.h"
@interface Track : NSObject <DOUAudioFile>
@property (nonatomic, strong) NSString* userId;
@property (nonatomic, strong) NSURL *audioFileURL;
@end
