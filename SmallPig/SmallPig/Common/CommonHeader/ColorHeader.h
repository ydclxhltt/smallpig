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
#define HOME_SEARCHBAR_BG_COLOR     RGB(27, 132, 81)

#pragma mark 左边栏

//左侧滑背景颜色
#define LEFT_SIDE_BG_COLOR          RGB(38.0, 38.0, 38.0)
//左侧滑列表分割线颜色
#define LIFT_SIDE_SEPLINE_COLOR     RGB(47.0, 47.0, 47.0)
#endif
