//
//  HouseDetailOneInfoView.h
//  SmallPig
//
//  Created by clei on 15/1/29.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

typedef enum : NSUInteger
{
    InfoViewTypeNormal,
    InfoViewTypeMap,
} InfoViewType;

#define MAPVIEW_HEIGHT 130.0
#define SPACE_X        10.0
#define SPACE_Y        5.0
#define LABEL_HEIGHT   20.0

@interface HouseDetailOneInfoView : UIView

/*
 * 初始化
 *
 * @pram frame  frame
 * @pram type   视图类型
 * @pram title  视图title
 */
- (instancetype)initWithFrame:(CGRect)frame viewType:(InfoViewType)type viewTitle:(NSString *)title;

/*
 * 设置描述信息
 *
 * @pram detailText  描述文字
 */
- (void)setDataWithDetailText:(NSString *)detailText;

/*
 * 初始化
 *
 * @pram coordinate  位置
 * @pram location    地址
 */
- (void)setLocationCoordinate:(CLLocationCoordinate2D)coordinate  locationText:(NSString *)location;
@end
