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
 *  @pram frame     frame
 *  @pram delegate  delegate
 */
- (instancetype)initWithFrame:(CGRect)frame delegate:(id)delegate;

/*
 *  设置数据
 *
 *  @pram name      中介名字
 *  @pram mobile    手机号
 *  @pram company   所属公司
 *  @pram count     拥有房源
 */
- (void)setDataWithAgentName:(NSString *)name phoneNumber:(NSString *)mobile companyName:(NSString *)company  houseScourceCount:(NSString *)count;
@end
