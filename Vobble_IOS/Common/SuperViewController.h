//
//  SuperViewController.h
//  Vobble_IOS
//
//  Created by Rangken on 2014. 2. 23..
//  Copyright (c) 2014년 Nexters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "App.h"
#import "URL.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <AFNetworking/AFNetworking.h>
#import "AFAppDotNetAPIClient.h"
@interface SuperViewController : UIViewController
- (void)alertNetworkError:(NSString*)msg;
@end
