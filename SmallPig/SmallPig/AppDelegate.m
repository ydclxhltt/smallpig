//
//  AppDelegate.m
//  SmallPig
//
//  Created by clei on 14-10-20.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "AppDelegate.h"
#import "LeftSidelViewController.h"
#import "HomeViewController.h"
#import "WeChatMainViewController.h"
#import "MineViewController.h"
#import "AFNetworking.h"

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
    //修改架构后屏蔽
    //[[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12],NSForegroundColorAttributeName : RGB(190.0, 190.0, 190.0)} forState:UIControlStateNormal];
    //[[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12],NSForegroundColorAttributeName : APP_MAIN_COLOR} forState:UIControlStateSelected];
    
    
    //主界面
    _sideViewController = [[MainSideViewController alloc]initWithNibName:nil bundle:nil];
    _sideViewController.leftViewShowWidth = LEFT_SIDE_WIDTH;
    [_sideViewController setNeedSwipeShowMenu:NO];
    [self setLeftView];
    [self setRootView];
    self.window.rootViewController=_sideViewController;
    
    
    /************test***********/
    [self test];
    
    
    
    return YES;
}


- (void)test
{
    
//    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:@"http://120.24.63.175:8080/horse-web/member_login_check"]];
//    NSString *failureUrl= @"/mobile/login/failure.action";
//    NSString *redirextUrl = @"/mobile/login/success.action";
//    [request addPostValue:@"13590444724" forKey:@"username"];
//    [request addPostValue:@"111111" forKey:@"password"];
//    [request addPostValue:redirextUrl forKey:@"redirectURL"];
//    [request addPostValue:failureUrl forKey:@"failureURL"];
//    [request startSynchronous];
//    
//    NSLog(@"request====%@",request.responseString);
    
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]init];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/json",@"application/json",@"text/plain",nil];
    NSString *failureUrl= @"/mobile/login/failure.action";
    NSString *redirextUrl = @"/mobile/login/success.action";
    NSDictionary *dic = @{@"username":@"18625353675",@"password":@"123456",@"redirectURL":redirextUrl,@"failureURL":failureUrl};
    //NSString *string = @"username=18625353675&password=123456&redirectURL=/mobile/login/success.action&redirextUrl=/mobile/login/success.action";
    NSLog(@"LOGIN_URL===%@===%@",LOGIN_URL,dic);
    
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:LOGIN_URL]];
//    request.HTTPMethod = @"POST";
//    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//    //[request setHTTPBody:[string dataUsingEncoding:NSUTF8StringEncoding]];
//    [request setValue:@"18625353675" forKey:@"username"];
//    [request setValue:@"123456" forKey:@"password"];
//    [request setValue:redirextUrl forKey:@"redirectURL"];
//    [request setValue:failureUrl forKey:@"failureURL"];
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseDic){NSLog(@"responseDic===%@",operation.responseString);} failure:^(AFHTTPRequestOperation *operation, NSError *error){ NSLog(@"error===%@",error);}];
//    [operation start];
    //NSDictionary *dic = @{@"paramCategory":@"5"};
    //NSDictionary *dic = @{@"pageSize":@"2"};
    [manager POST:LOGIN_URL parameters:dic
    success:^(AFHTTPRequestOperation *operation, id responseDic)
    {
        NSLog(@"responseDic===%@",responseDic);
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
         NSLog(@"error===%@",error);
    }];
}


//左侧界面（个人）
- (void)setLeftView
{
    LeftSidelViewController *peasonalViewController = [[LeftSidelViewController alloc]init];
    _sideViewController.leftViewController = peasonalViewController;
}

//中间主界面
- (void)setRootView
{
    /*
     *  去掉tabbar上方黑线
     *  1⃣️ [mianTabbarViewController.tabBar setClipsToBounds:YES];
     *  2⃣️ [mainTabbarViewController.tabBar setShadowImage:[[UIImage alloc]init]];
     */
    /* 修改架构后屏蔽
    UITabBarController *mainTabbarViewController =[[UITabBarController alloc]init];
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
     */
    
    HomeViewController *homeViewController = [[HomeViewController alloc]init];
    UINavigationController *homeNavViewController = [[UINavigationController alloc]initWithRootViewController:homeViewController];
    _sideViewController.rootViewController = homeNavViewController;
    
}

/*
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
*/

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
