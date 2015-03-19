//
//  HouseLabelsView.h
//  SmallPig
//
//  Created by clei on 15/3/11.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#define SPACE_X         10.0
#define SPACE_Y         10.0
#define ADD_X           10.0
#define ADD_Y           10.0
#define LABEL_HEIGHT    20.0
@interface HouseLabelsView : UIView
@property(nonatomic, strong) NSMutableArray *selectedLabelArray;
/*
 *  设置数据
 *
 *  @param  array  标签数组
 */
- (void)setLabelsWithArray:(NSArray *)array;

/*
 *  初始化
 *
 *  @param  title  标签标题
 */
- (instancetype)initWithFrame:(CGRect)frame  LablesTitle:(NSString *)title;
@end
