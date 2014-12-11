//
//  SmallPigFontHeader.h
//  SmallPig
//
//  Created by clei on 14-10-20.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#ifndef SmallPig_FontHeader_h
#define SmallPig_FontHeader_h

//设置字体大小
#define FONT(f)                     [UIFont systemFontOfSize:f]

//设置加粗字体大小
#define BOLD_FONT(f)                [UIFont boldSystemFontOfSize:f]

//个人名称字体
#define PERSON_NAME_FONT            BOLD_FONT(16.0)

//登录注册
#define LOGIN_REG_FONT              FONT(16.0)

//找回密码/手机注册按钮文字
#define REGISTER_TITLE_FONT         FONT(14.0)

//新房建设中提示语字体
#define NEW_HOUSE_TIP_FONT          FONT(18.0)

//租房.二手房列表Title文字
#define HOUSE_LIST_TITLE_FONT       FONT(14.0)

//租房.二手房描述文字（非价格）
#define HOUSE_LIST_DETAIL_FONT      FONT(12.0)

//租房.二手房价格
#define HOUSE_LIST_PRICE_FONT       FONT(14.0)

//经纪人排名字体
#define AGENT_RANK_FONT             FONT(16.0)

//经纪人名字字体
#define AGENT_NAME_FONT             AGENT_RANK_FONT

//经纪人积分字体
#define AGENT_SCORE_FONT            FONT(13.0)

//经纪人积分分数字体
#define AGENT_NUMBER_FONT           FONT(15.0)

//经纪人详情列表字体（电话评价）
#define AGENT_DETAIL_FONT           FONT(16.0)

//个人中心列表右边文字字体大小
#define MINE_CENTER_LIST_FONT       BOLD_FONT(14.0)

//个人中心审核中提示文字字体大小
#define MINE_CENTER_LIST_TIP_FONT   FONT(14.0)

//个人中心／设置列表左边字体大小
#define SYSTEM_LIST_FONT            FONT(16.0)

#endif
