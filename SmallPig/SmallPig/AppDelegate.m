//
//  AppDelegate.m
//  SmallPig
//
//  Created by clei on 14-10-20.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "AppDelegate.h"
#import "PeasonalViewController.h"
#import "HomeViewController.h"
#import "WeChatMainViewController.h"
#import "MineViewController.h"

@interface AppDelegate()
{
    
}
@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    //设置导航条
    [[UINavigationBar appearance] setBarTintColor:APP_MAIN_COLOR];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    //[[UINavigationBar appearance] setTranslucent:YES];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:RGB(255.0, 255.0, 255.0),NSForegroundColorAttributeName,nil];
    [[UINavigationBar appearance] setTitleTextAttributes:dic];
   
    /*
     *  设置tabbar选中和默认字体颜色
     *
     *  IOS5 - IOS7
     *  UITextAttributeFont
     *  UITextAttributeTextColor
     *
     *  IOS6 - IOS8
     *  NSFontAttributeName
     *  NSForegroundColorAttributeName
     *
     */
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12],NSForegroundColorAttributeName : RGB(190.0, 190.0, 190.0)} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12],NSForegroundColorAttributeName : APP_MAIN_COLOR} forState:UIControlStateSelected];
    
    
    //主界面
    _sideViewController = [[MainSideViewController alloc]initWithNibName:nil bundle:nil];
    _sideViewController.leftViewShowWidth = LEFT_SIDE_WIDTH;
    [_sideViewController setRootViewMoveBlock:^(UIView *rootView, CGRect orginFrame, CGFloat xoffset) {
        //使用简单的平移动画
        rootView.frame=CGRectMake(xoffset, orginFrame.origin.y, orginFrame.size.width, orginFrame.size.height);
    }];
    [self setLeftView];
    [self setRootView];
    self.window.rootViewController=_sideViewController;
    
    return YES;
}

//左侧界面（个人）
- (void)setLeftView
{
    PeasonalViewController *peasonalViewController = [[PeasonalViewController alloc]init];
    _sideViewController.leftViewController = peasonalViewController;
}

//中间主界面
- (void)setRootView
{
    UITabBarController *mainTabbarViewController =[[UITabBarController alloc]init];
    
    /*
     *  去掉tabbar上方黑线
     *  1⃣️ [mianTabbarViewController.tabBar setClipsToBounds:YES];
     *  2⃣️ [mainTabbarViewController.tabBar setShadowImage:[[UIImage alloc]init]];
     */
    
    //[mainTabbarViewController.tabBar setClipsToBounds:YES];
    mainTabbarViewController.delegate = self;
    MineViewController *mineViewController = [[MineViewController alloc]init];
    HomeViewController *homeViewController = [[HomeViewController alloc]init];
    WeChatMainViewController *weChatViewController = [[WeChatMainViewController alloc]init];
    UINavigationController *homeNavViewController = [[UINavigationController alloc]initWithRootViewController:homeViewController];
    UINavigationController *wechatNavViewController = [[UINavigationController alloc]initWithRootViewController:weChatViewController];
    UINavigationController *mineNavViewController = [[UINavigationController alloc]initWithRootViewController:mineViewController];
    UITabBarItem *homeTabBarItem = [[UITabBarItem alloc]initWithTitle:@"房源" image:[UIImage imageNamed:@"btm_home1"] selectedImage:[UIImage imageNamed:@"btm_home2"]];
    UITabBarItem *wechatTabBarItem = [[UITabBarItem alloc]initWithTitle:@"微聊" image:[UIImage imageNamed:@"btm_wechat1"] selectedImage:[UIImage imageNamed:@"btm_wechat2"]];
    UITabBarItem *mineTabBarItem = [[UITabBarItem alloc]initWithTitle:@"收藏" image:[UIImage imageNamed:@"btm_save1"] selectedImage:[UIImage imageNamed:@"btm_save2"]];
    mainTabbarViewController.tabBar.tintColor = APP_MAIN_COLOR;
    [homeNavViewController setTabBarItem:homeTabBarItem];
    [wechatNavViewController setTabBarItem:wechatTabBarItem];
    [mineNavViewController setTabBarItem:mineTabBarItem];
    mainTabbarViewController.viewControllers = [NSArray arrayWithObjects:homeNavViewController,wechatNavViewController,mineNavViewController,nil];
    _sideViewController.rootViewController = mainTabbarViewController;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if (tabBarController.selectedIndex == 0)
    {
        [_sideViewController setNeedSwipeShowMenu:YES];
    }
    else
    {
        [_sideViewController setNeedSwipeShowMenu:NO];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
