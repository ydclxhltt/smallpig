//
//  HouseDetailInfoView.h
//  SmallPig
//
//  Created by clei on 15/1/28.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HouseDetailInfoView : UIView

/*
 *  初始化
 *
 *  @pram frame frame
 *  @pram type  房屋来源
 */
- (instancetype)initWithFrame:(CGRect)frame houseType:(HouseScource)type;

/*
 *  初始化
 *
 *  @pram housePrice  售价/房租
 *  @pram priceInfo   均价/压几付几
 *  @pram size        大小
 *  @pram scource     房屋来源
 *  @pram type        房屋类型
 *  @pram things      房屋装修
 *  @pram floor       楼层
 *  @pram position    房屋朝向
 */
- (void)setDataWithHousePrice:(NSString *)housePrice HousePriceInfo:(NSString *)priceInfo houseSize:(NSString *)size houseSource:(NSString *)scource houseType:(NSString *)type houseThings:(NSString *)things houseFloor:(NSString *)floor housePosition:(NSString *)position;
@end
