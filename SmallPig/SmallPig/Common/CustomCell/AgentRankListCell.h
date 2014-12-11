//
//  AgentRankListCell.h
//  SmallPig
//
//  Created by clei on 14/12/9.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AgentRankListCell : UITableViewCell

/*
 *  设置图片地址和各个字段的值
 *
 *  @pram imageUrl  图片地址
 *  @pram rank      排名
 *  @pram name      经纪人姓名
 *  @pram score     积分
 */
- (void)setCellDataWithRank:(int)rank agentImageUrl:(NSString *)imageUrl agentName:(NSString *)name agentScore:(NSString *)score;

@end
