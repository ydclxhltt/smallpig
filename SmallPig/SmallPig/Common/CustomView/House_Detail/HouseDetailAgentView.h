//
//  HouseDetailAgentView.h
//  SmallPig
//
//  Created by clei on 15/1/29.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HouseDetailAgentView : UIView

@property (nonatomic, assign) id delegate;

/*
 *  初始化
 *
 *  @param frame     frame
 *  @param delegate  delegate
 */
- (instancetype)initWithFrame:(CGRect)frame delegate:(id)delegate;

/*
 *  设置数据
 *
 *  @param agentIcon 头像
 *  @param name      中介名字
 *  @param mobile    手机号
 *  @param company   所属公司
 *  @param count     拥有房源
 */
- (void)setDataWithAgentIcon:(NSString *)agentIcon agentName:(NSString *)name phoneNumber:(NSString *)mobile companyName:(NSString *)company  houseScourceCount:(NSString *)count;
@end
