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
 * @pram frame      frame
 * @pram delegate   delegate
 */
- (instancetype)initWithFrame:(CGRect)frame  delegate:(id)delegate;

/*
 * 设置数据
 *
 * @pram array 图片数组
 */
- (void)setImageScrollViewData:(NSArray *)array;
@end
