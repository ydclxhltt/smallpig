//
//  AppDelegate.h
//  SmallPig
//
//  Created by clei on 14-10-20.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainSideViewController.h"
#define APP_DELEGATE ((AppDelegate *)[UIApplication sharedApplication].delegate)
@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MainSideViewController *sideViewController;

/*
 *  获取房屋亮点标签
 */
- (void)getSecondHandGoodHouseLabels;
- (void)getSecondHandHouseLabels;
- (void)getRentalGoodHouseLabels;
- (void)getRentalHouseLabels;
@end
