//
//  AppDelegate.h
//  SmallPig
//
//  Created by clei on 14-10-20.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainSideViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MainSideViewController *sideViewController;
@end
