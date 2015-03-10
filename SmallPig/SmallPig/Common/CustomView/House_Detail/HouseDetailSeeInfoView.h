//
//  HouseDetailSeeInfoView.h
//  SmallPig
//
//  Created by clei on 15/1/29.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SEE_SPACE_X        10.0
#define SEE_SPACE_Y        5.0
#define SEE_LABEL_HEIGHT   20.0

@interface HouseDetailSeeInfoView : UIView

/*
 *  设置数据
 *
 *  @param title  描述文字
 *  @param time   发布时间
 *  @param count  浏览次数
 */
- (void)setDataWithTitle:(NSString *)title publicTime:(NSString *)time seeCount:(NSString *)count;
@end
