//
//  HouseDetailHeader.h
//  SmallPig
//
//  Created by clei on 15/1/28.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HouseDetailHeader : UIView
@property (nonatomic, assign) id delegate;

/*
 * 初始化
 *
 * @param frame      frame
 * @param delegate   delegate
 */
- (instancetype)initWithFrame:(CGRect)frame  delegate:(id)delegate;

/*
 * 设置数据
 *
 * @param array 图片数组
 */
- (void)setImageScrollViewData:(NSArray *)array;

/*
 * 初始化收藏按钮状态
 *
 * @param isSelected 是否为选中状态
 */
- (void)setSaveButtonState:(BOOL)isSelected;

@end
