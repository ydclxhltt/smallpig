//
//  SmallPigColorHeader.h
//  SmallPig
//
//  Created by clei on 14-10-20.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#ifndef SmallPig_ColorHeader_h
#define SmallPig_ColorHeader_h

//设置RGB
#define RBGA(R,G,B,AL)              [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:AL]
#define RGB(R,G,B)                  [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0]


//主色调
#define APP_MAIN_COLOR              RGB(33.0,159.0,98.0)

//界面背景颜色
#define BASIC_VIEW_BG_COLOR         RGB(229.0,229.0,229.0)

//白色
#define  WHITE_COLOR                RGB(255.0,255.0,255.0)

#pragma mark 左边栏

//左侧滑背景颜色
#define LEFT_SIDE_BG_COLOR          RGB(38.0, 38.0, 38.0)
//左侧滑列表分割线颜色
#define LIFT_SIDE_SEPLINE_COLOR     RGB(47.0, 47.0, 47.0)

#pragma mark 登录相关

//登录／注册／下一步 高亮颜色
#define LOGIN_BUTTON_PRESSED_COLOR  RGB(26.0,135.0,81.0)
//登录 用户名Lable等颜色
#define LOGIN_LABEL_COLOR           RGB(100.0,100.0,100.0)
//找回密码/手机注册
#define REGISTER_TITLE_COLOR        RGB(108.0,108.0,108.0)
//验证码背景颜色
#define CHECK_CODE_BG_COLOR         RGB(229.0,77.0,35.0)
//验证码按钮选中颜色
#define CHECK_CODE_HIGH_COLOR       RGB(205.0,68.0,31.0)

#pragma mark 首页相关

//首页列表title颜色
#define HOME_LIST_TITLE_COLOR       RGB(38.0,38.0,38.0)
//首页列表detail颜色
#define HOME_LIST_DETAIL_COLOR      RGB(188.0,188.0,188.0)
//首页搜索条背景颜色
#define HOME_SEARCHBAR_BG_COLOR     RGB(27.0, 132.0, 81.0)


#pragma mark 新房相关颜色

//背景颜色
#define NEW_HOUSE_BG_COLOR          RGB(25.0,25.0,25.0)
//建设中提示文字颜色
#define NEW_HOUSE_TIP_TEXT_COLOR    RGB(65.0,65.0,65.0)


#pragma mark 租房/二手房相关颜色

//二手房/租房列表分割线
#define HOUSE_LIST_SEPLINE_COLOR    RGB(188.0,188.0,188.0)
//列表title颜色
#define HOUSE_LIST_TITLE_COLOR      HOME_LIST_TITLE_COLOR
//列表非价钱和title颜色
#define HOUSE_LIST_DETAIL_COLOR     HOME_LIST_DETAIL_COLOR
//列表价格颜色
#define HOUSE_LIST_PRICE_COLOR      RGB(220.0,53.0,8.0)

#pragma mark 经纪人排行

//经纪人排行排名Label颜色
#define AGENT_RANK_COLOR            REGISTER_TITLE_COLOR
//经纪人排名名字颜色
#define AGENT_NAME_COLOR            RGB(4.0,4.0,4.0)
//经纪人积分颜色
#define AGENT_SCORE_COLOR           RGB(88.0,88.0,88.0)
//经纪人积分分数颜色
#define AGENT_NUMBER_COLOR          APP_MAIN_COLOR
#endif
