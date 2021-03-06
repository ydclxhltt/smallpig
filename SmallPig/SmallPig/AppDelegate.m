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
#import "BMapKit.h"

@interface AppDelegate()<BMKGeneralDelegate>
{
    BMKMapManager *mapManager;
}
@property (nonatomic, strong) NSString *tokenString;
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
    

    
    
    //注册远程通知
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    else
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge)];
    
    //注册百度地图
    mapManager = [[BMKMapManager alloc] init];
    [mapManager start:BAIDU_MAP_KEY generalDelegate:self];
    
    //初始化数据
    self.tokenString = @"";
    
    
    //主界面
    _sideViewController = [[MainSideViewController alloc]initWithNibName:nil bundle:nil];
    _sideViewController.leftViewShowWidth = LEFT_SIDE_WIDTH;
    [_sideViewController setNeedSwipeShowMenu:NO];
    [self setLeftView];
    [self setRootView];
    self.window.rootViewController=_sideViewController;
    
    //获取房屋标签
    [self getSecondHandGoodHouseLabels];
    [self getSecondHandHouseLabels];
    [self getRentalGoodHouseLabels];
    [self getRentalHouseLabels];
    //获取筛选
    [self getSortHouseParmaWithCityCode:@"sz"];
    [self getHousePriceParmaList];
    [self getHouseBedroomParmaList];
    //获取身份升级参数
    [self getCityList];
    [self getNIDTypeList];
    [self getOpenBankList];
    return YES;
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


#pragma mark 获取筛选参数
- (void)getSortHouseParmaWithCityCode:(NSString *)cityCode
{
    cityCode = (cityCode) ? cityCode : @"";
    cityCode = [@"AREA@" stringByAppendingString:cityCode];
    
    NSDictionary *requestDic = @{@"paramCategory":cityCode};
    RequestTool *request = [[RequestTool alloc] init];
    [request requestWithUrl:SORT_TREE_LIST_URL requestParamas:requestDic requestType:RequestTypeAsynchronous
    requestSucess:^(AFHTTPRequestOperation *operation, id responseDic)
     {
         NSLog(@"responseDic====%@",responseDic);
         int sucess = [responseDic[@"responseMessage"][@"success"] intValue];
         if (sucess == 1)
         {
             [[SmallPigApplication shareInstance] setSortHouseAreaParmaArray:responseDic[@"model"][@"paramList"]];
         }
     }
    requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
     }];
}

#pragma mark 获取价格区域
- (void)getHousePriceParmaList
{
    [self getParmaWithParmaCode:@"PARAM.SECONDHANDROOMPRICE"];
    [self getParmaWithParmaCode:@"PARAM.RENTROOMPRICE"];
}

#pragma mark 获取房屋类型
- (void)getHouseBedroomParmaList
{
    [self getParmaWithParmaCode:@"PARAM.BEDROOM"];
}

#pragma mark 获取房屋标签

- (void)getSecondHandGoodHouseLabels
{
    [self getParmaWithParmaCode:@"PARAM.SECONDHANDROOMFEATURE"];
}
- (void)getSecondHandHouseLabels
{
    [self getParmaWithParmaCode:@"PARAM.SECONDHANDROOMLABEL"];
}

- (void)getRentalGoodHouseLabels
{
    [self getParmaWithParmaCode:@"PARAM.RENTROOMFEATURE"];
}
- (void)getRentalHouseLabels
{
    [self getParmaWithParmaCode:@"PARAM.RENTROOMLABEL"];
}

//身份升级参数
- (void)getNIDTypeList
{
    [self getParmaWithParmaCode:@"PARAM.NIDTYPE"];
}

- (void)getOpenBankList
{
    [self getParmaWithParmaCode:@"PARAM.OPENBANK"];
}

- (void)getCityList
{
    [self getParmaWithParmaCode:@"PARAM.CITY"];
}

#pragma mark 获取参数
- (void)getParmaWithParmaCode:(NSString *)parma
{
    NSDictionary *requestDic = @{@"paramCategory":parma};
    RequestTool *request = [[RequestTool alloc] init];
    [request requestWithUrl:SORT_LIST_URL requestParamas:requestDic requestType:RequestTypeAsynchronous requestSucess:^(AFHTTPRequestOperation *operation, id responseDic)
    {
        NSLog(@"responseDic====%@",responseDic);
        int sucess = [responseDic[@"responseMessage"][@"success"] intValue];
        if (sucess == 1)
        {
            if ([parma isEqualToString:@"PARAM.SECONDHANDROOMFEATURE"])
            {
                [[SmallPigApplication shareInstance] setHouseGoodLabelsArray:responseDic[@"model"][@"paramList"]];
            }
            else if ([parma isEqualToString:@"PARAM.SECONDHANDROOMLABEL"])
            {
                [[SmallPigApplication shareInstance] setHouseLabelsArray:responseDic[@"model"][@"paramList"]];
            }
            else if ([parma isEqualToString:@"PARAM.RENTROOMFEATURE"])
            {
                [[SmallPigApplication shareInstance] setRentalHouseGoodLabelsArray:responseDic[@"model"][@"paramList"]];
            }
            else if ([parma isEqualToString:@"PARAM.RENTROOMLABEL"])
            {
                [[SmallPigApplication shareInstance] setRentalHouseLabelsArray:responseDic[@"model"][@"paramList"]];
            }
            else if ([parma isEqualToString:@"PARAM.SECONDHANDROOMPRICE"])
            {
                [[SmallPigApplication shareInstance] setSortHousePriceParmaArray:responseDic[@"model"][@"paramList"]];
            }
            else if ([parma isEqualToString:@"PARAM.RENTROOMPRICE"])
            {
                [[SmallPigApplication shareInstance] setSortRentalHousePriceParmaArray:responseDic[@"model"][@"paramList"]];
            }
            else if ([parma isEqualToString:@"PARAM.BEDROOM"])
            {
                [[SmallPigApplication shareInstance] setSortHouseBedroomParmaArray:responseDic[@"model"][@"paramList"]];
            }
            else if ([parma isEqualToString:@"PARAM.NIDTYPE"])
            {
                [[SmallPigApplication shareInstance] setNidTypeArray:responseDic[@"model"][@"paramList"]];
            }
            else if ([parma isEqualToString:@"PARAM.CITY"])
            {
                [[SmallPigApplication shareInstance] setCitysArray:responseDic[@"model"][@"paramList"]];
            }
            else if ([parma isEqualToString:@"PARAM.OPENBANK"])
            {
                [[SmallPigApplication shareInstance] setOpenBankArray:responseDic[@"model"][@"paramList"]];
            }
        }
    }
    requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        
    }];
}


#pragma mark 百度SDK启动地图认证Delegate
- (void)onGetNetworkState:(int)iError
{
    if (0 == iError)
    {
        NSLog(@"联网成功");
    }
    else
    {
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError)
    {
        NSLog(@"授权成功");
    }
    else
    {
        NSLog(@"onGetPermissionState %d",iError);
    }
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
    self.tokenString = [[[[NSString stringWithFormat:@"%@",deviceToken]stringByReplacingOccurrencesOfString:@"<"withString:@""]
                         stringByReplacingOccurrencesOfString:@">" withString:@""]stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"deviceToken: %@====tokenString=====%@", deviceToken,self.tokenString.description);
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    application.applicationIconBadgeNumber = 0;
    /*这里需要处理推送来的消息*/
    //NSDictionary *auserInfo = [userInfo objectForKey:@"aps"];
    //NSLog(@"userInfo====%@",auserInfo);
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"error====%@",error);
}




- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [BMKMapView willBackGround];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [BMKMapView didForeGround];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [mapManager stop];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
