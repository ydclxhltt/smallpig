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
 *  @param imageUrl  图片地址
 *  @param rank      排名
 *  @param name      经纪人姓名
 *  @param score     积分
 */
- (void)setCellDataWithRank:(int)rank agentImageUrl:(NSString *)imageUrl agentName:(NSString *)name agentScore:(NSString *)score;

@end
