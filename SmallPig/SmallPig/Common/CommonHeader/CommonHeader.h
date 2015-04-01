//
//  CommonHeader.h
//  SmallPig
//
//  Created by clei on 14/11/5.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#ifndef SmallPig_CommonHeader_h
#define SmallPig_CommonHeader_h

#import "ColorHeader.h"
#import "FontHeader.h"
#import "ProductInfoHeader.h"
#import "RequestHeader.h"
#import "DeviceHeader.h"

//左侧宽度
#define LEFT_SIDE_WIDTH         220.0
//导航条高度
#define NAV_HEIGHT              64.0
//状态栏高度
#define STATUS_HEIGHT           20.0
//首页icon列表高度
#define HOME_ICON_ROWHEIGHT     80.0
//左侧列表高度
#define LEFT_SIDE_LIST_HEIGHT   60.0
//租房，二手房列表高度
#define HOUSE_LIST_HEIGHT       100.0
//收藏，发布列表高度
#define SAVE_LIST_HEIGHT        85.0
//经纪人排行列表高度
#define AGENT_LIST_HEIGHT       90.0
//个人中心头像行高
#define MINE_CENTER_ICON_HEIGHT 85.0
//设置列表行高
#define SETTING_LIST_HEIGHT     50.0


#pragma mark loading
//成功
#define LOADING_SUCESS          @"加载成功"
//失败
#define LOADING_FAILURE         @"加载失败"
//加载中
#define LOADING_DEFAULT         @"加载中..."

#pragma mark 登录注册
//登录
#define LOGIN_TITLE             @"登录"
//注册
#define REGISTER_TITLE          @"注册"
//找回密码
#define FIND_PSW_TITLE          @"找回密码"
//修改密码
#define CHANGE_PSW_TITLE        @"修改密码"
//修改手机号
#define CHANGE_MOBILE_TITLE     @"修改手机号"

#pragma mark 首页
//城市列表title
#define CITY_LIST_TITLE         @"选择默认城市"
//经纪人排名title
#define AGENT_LIST_TITLE        @"本周经纪人"

#pragma mark 房源
//新房
#define NEW_HOUSE_TITLE         @"新房"
//新房建设中提示语
#define NEW_HOUSE_TIP           @"功能还在建设中...\n敬请期待"
//二手房
#define SECOND_HAND_TITLE       @"二手房"
//租房
#define RENTAL_HOUSE_TITLE      @"租房"

#pragma mark 个人中心
//个人中心
#define MINE_CENTER_TITLE       @"个人中心"

#pragma mark 收藏
//收藏
#define MINE_SAVE_TITLE         @"我的收藏"

#pragma mark 设置
//设置title
#define SETTING_TITLE           @"设置"
//意见反馈
#define FEEDBACK_TITLE          @"意见反馈"
//关于我们
#define ABOUT_US_TITLE          @"关于我们"

#pragma mark 经纪人
//经纪人详情title
#define AGENT_DETAIL_TITLE      @"经纪人详情"
//经纪人平台title
#define AGENT_CENTER_TITLE      @"经纪人平台"
//经纪人积分
#define AGENT_SCORE_TITLE       @"我的积分"
#endif
