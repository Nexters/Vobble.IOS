//
//  MainVobbleViewController.h
//  vobble_ios
//
//  Created by Rangken on 2014. 2. 23..
//  Copyright (c) 2014년 Nexters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
@class MainViewController;
typedef enum eVobbleType{
    ALL,
    MY,
    FRIEND
}eVobbleType;

@interface MainVobbleViewController : SuperViewController
@property (nonatomic, weak) MainViewController* mainViewCont;
@property (nonatomic, assign) eVobbleType type;
@property (nonatomic, strong) NSMutableArray* vobbleArray;
@property (nonatomic, assign) NSInteger vobbleCnt;
@property (nonatomic, strong) NSMutableArray *deleteBtns;
- (void)resetVobbleImgs;
- (void)initVobbles;
- (void)stopAllAnimation;
- (void)earthquakeAllVobbles;
@end
