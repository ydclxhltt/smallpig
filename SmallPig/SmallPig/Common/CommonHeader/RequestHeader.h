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
#define REGISTER_URL            MAKE_REQUEST_URL(@"yjk/member/register.action")

//登录请求
#define LOGIN_URL               MAKE_REQUEST_URL(@"member_login_check")

//找回密码
#define FIND_PWD_URL            MAKE_REQUEST_URL(@"yjk/member/reset.action")

//修改密码
#define CHANGE_PWD_URL          MAKE_REQUEST_URL(@"yjk/member/password.action")

//获取验证码
#define GET_CHECK_URL           MAKE_REQUEST_URL(@"code/send.action")

//校验验证码
#define CHECK_CODE_URL          MAKE_REQUEST_URL(@"code/check.action")

//修改个人信息
#define CHANGE_PERSONAL_URL     MAKE_REQUEST_URL(@"yjk/member/profile.action")

//修改手机号
#define CHANGE_MOBILE_URL       MAKE_REQUEST_URL(@"yjk/member/mobile.action")

//分类列表
#define SORT_LIST_URL           MAKE_REQUEST_URL(@"param/list.action")

//二手房
#define SECOND_LIST_URL         MAKE_REQUEST_URL(@"yjk/secondhandroom/list.action")

#endif
