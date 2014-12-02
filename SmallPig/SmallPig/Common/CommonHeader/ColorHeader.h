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
#define RBGA(R,G,B,AL)          [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:AL]
#define RGB(R,G,B)              [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0]


//主色调
#define APP_MAIN_COLOR          RGB(32.0, 159.0, 97.0)

#define BASIC_VIEW_BG_COLOR     RGB(229.0, 229.0, 229.0)
//白色
#define  WIHTE_COLOR            RGB(255.0,255.0,255.0)

//登录 用户名Lable等颜色
#define LOGIN_LABEL_COLOR       RGB(100.0,100.0,100.0)

//找回密码/手机注册
#define REGISTER_TITLE_COLOR    RGB(108.0,108.0,108.0)

//验证码背景颜色
#define CHECK_CODE_BG_COLOR     RGB(207.0,100.0,53.0)

#endif
