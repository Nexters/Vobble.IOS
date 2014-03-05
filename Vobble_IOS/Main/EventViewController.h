//
//  EventViewController.h
//  Vobble_IOS
//
//  Created by Rangken on 2014. 2. 23..
//  Copyright (c) 2014년 Nexters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
typedef enum eEventType{
    EVENT_NOTICE,
    EVENT_APPS,
}eEventType;
@interface EventViewController : SuperViewController

@property (nonatomic, weak) IBOutlet UIWebView* webView;
@property (nonatomic, assign) eEventType type;
@end
