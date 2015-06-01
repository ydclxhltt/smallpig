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
#define WEB_SERVER_URL          @"http://120.24.79.110:8080/horse-web/"
//#define WEB_SERVER_URL          @"http://120.24.63.175:8080/horse-web/"

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

//获取个人信息
#define GET_PERSONAL_INFO_URL   MAKE_REQUEST_URL(@"yjk/member/find.action")

//修改手机号
#define CHANGE_MOBILE_URL       MAKE_REQUEST_URL(@"yjk/member/mobile.action")

//上传图片
#define UPLOAD_ICON_URL         MAKE_REQUEST_URL(@"yjk/member/uploadPhoto.action")

//上传图片
#define UPDATE_ICON_URL         MAKE_REQUEST_URL(@"yjk/member/update.action")

//上传身份证
#define UPLOAD_NID_PIC_URL      MAKE_REQUEST_URL(@"/yjk/mappr/uploadPhoto.action")

//分类列表
#define SORT_LIST_URL           MAKE_REQUEST_URL(@"param/list.action")

//筛选参数列表
#define SORT_TREE_LIST_URL      MAKE_REQUEST_URL(@"param/tree.action")

//二手房
#define SECOND_LIST_URL         MAKE_REQUEST_URL(@"yjk/secondhandroom/list.action")

//租房列表
#define  RENTAL_LIST_URL        MAKE_REQUEST_URL(@"yjk/rentroom/list.action")

//房子详情
#define HOUSE_DETAIL_URL        MAKE_REQUEST_URL(@"yjk/secondhandroom/find.action")

//租房详情
#define RENTAL_DETAIL_URL       MAKE_REQUEST_URL(@"yjk/rentroom/find.action")

//经纪人列表
#define AGENT_LIST_URL          MAKE_REQUEST_URL(@"yjk/agent/list.action")

//经纪人积分列表
#define AGENT_LISTC_URL         MAKE_REQUEST_URL(@"yjk/agent/listc.action")

//经纪人发布列表
#define AGENT_PUBLICROOM_URL    MAKE_REQUEST_URL(@"yjk/agent/listPublishRoom.action")

//备忘录列表
#define MEMO_LIST_URL           MAKE_REQUEST_URL(@"yjk/remind/list.action")

//备忘录添加
#define MEMO_ADD_URL            MAKE_REQUEST_URL(@"yjk/remind/add.action")

//备忘录详情
#define MEMO_FIND_URL           MAKE_REQUEST_URL(@"yjk/remind/find.action")

//更新备忘录
#define MEMO_UPDATE_URL         MAKE_REQUEST_URL(@"yjk/remind/update.action")

//删除备忘
#define MEMO_DELETE_URL         MAKE_REQUEST_URL(@"yjk/remind/delete.action")

//添加收藏
#define ADD_SAVE_URL            MAKE_REQUEST_URL(@"yjk/favorites/add.action")

//删除收藏
#define DELETE_SAVE_URL         MAKE_REQUEST_URL(@"yjk/favorites/delete.action")

//收藏列表
#define SAVE_LIST_URL           MAKE_REQUEST_URL(@"yjk/favorites/list.action")

//房源照片
#define UPLOAD_ROOM_PIC_URL     MAKE_REQUEST_URL(@"yjk/publishroom/uploadPhoto.action")

//已发布房源列表
#define PUBLIC_ROOM_LIST_URL    MAKE_REQUEST_URL(@"yjk/publishroom/list.action?")

//查询房间是否发布过
#define IS_CAN_PUBLIC_URL       MAKE_REQUEST_URL(@"yjk/publishroom/find.action")

//发布房源
#define PUBLIC_ROOM_URL         MAKE_REQUEST_URL(@"yjk/publishroom/add.action")

//我的积分
#define MY_SCORE_URL            MAKE_REQUEST_URL(@"yjk/credits/list.action")

//我的订单
#define MY_ORDER_LIST_URL       MAKE_REQUEST_URL(@"yjk/order/list.action")

//订单详情
#define MY_ORDER_DETAIL_URL     MAKE_REQUEST_URL(@"yjk/order/find.action")

//新增举报
#define ADD_INFORM_URL          MAKE_REQUEST_URL(@"yjk/complaint/add.action")

//我的举报
#define INFORMED_LIST_URL       MAKE_REQUEST_URL(@"yjk/complaint/list.action")

//身份升级审核
#define UPLEVEL_URL             MAKE_REQUEST_URL(@"yjk/mappr/apply.action")

//审核状态查询
#define UPLEVEL_STATUS_URL      MAKE_REQUEST_URL(@"yjk/mappr/findOwnerAppr.action")

//查找用户
#define FIND_USER_URL           MAKE_REQUEST_URL(@"yjk/order/lookupMemberByMobile.action")

//客服列表
#define SERVICE_LIST_URL        MAKE_REQUEST_URL(@"yjk/order/lookupPeopleByPublishRoomId.action")

//发送订单
#define SEND_ORDER_URL          MAKE_REQUEST_URL(@"yjk/order/add.action")

//确认订单
#define COMMIT_ORDER_URL        MAKE_REQUEST_URL(@"yjk/order/confirm.action")

//搜索二手房借口
#define SEARCH_SECONDHOUSE_URL  MAKE_REQUEST_URL(@"yjk/secondhandroom/list.action?queryBean.params.like_keyword=")

//搜索租房
#define SEARCH_RENTALHOUSE_URL  MAKE_REQUEST_URL(@"yjk/rentroom/list.action?queryBean.params.like_keyword=")

//删除发布
#define PUBLIC_HOUSE_DELETE     MAKE_REQUEST_URL(@"yjk/publishroom/delete.action")

//修改发布
#define PUBLIC_HOUSE_CHANGE     MAKE_REQUEST_URL(@"yjk/publishroom/update.action"）

//关于我们
#define ABOUT_US_URL            MAKE_REQUEST_URL(@"yjk/static/m/aboutus.jsp")

//意见反馈
#define FACEBACK_URL            MAKE_REQUEST_URL(@"yjk/feedback/add.action")

//
#define PAYFEE_LIST_URL         MAKE_REQUEST_URL(@"yjk/systemfee/list.action")

#endif
