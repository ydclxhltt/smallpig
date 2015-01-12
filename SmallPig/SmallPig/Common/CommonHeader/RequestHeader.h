//
//  RequestHeader.h
//  SmallPig
//
//  Created by clei on 14/11/5.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#ifndef SmallPig_RequestHeader_h
#define SmallPig_RequestHeader_h

//服务器地址
#define WEB_SERVER_URL          @"http://120.24.63.175:8080/horse-web/"

//拼接请求地址
#define MAKE_REQUEST_URL(inf)   [NSString stringWithFormat:@"%@%@",WEB_SERVER_URL,inf]

//注册地址
#define REGISTER_URL            MAKE_REQUEST_URL(@"yjk/register.action")

//登录请求
#define LOGIN_URL               MAKE_REQUEST_URL(@"member_login_check")

//分类列表
#define SORT_LIST_URL           MAKE_REQUEST_URL(@"param/list.action")

//二手房
#define SECOND_LIST_URL         MAKE_REQUEST_URL(@"yjk/secondhandroom/list.action")

#endif
