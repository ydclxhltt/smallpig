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
 *  @param frame frame
 *  @param type  房屋来源
 */
- (instancetype)initWithFrame:(CGRect)frame houseType:(HouseScource)type;

/*
 *  初始化
 *
 *  @param housePrice  售价/房租
 *  @param priceInfo   均价/压几付几
 *  @param size        大小
 *  @param scource     房屋来源
 *  @param type        房屋类型
 *  @param things      房屋装修
 *  @param floor       楼层
 *  @param position    房屋朝向
 */
- (void)setDataWithHousePrice:(NSString *)housePrice HousePriceInfo:(NSString *)priceInfo houseSize:(NSString *)size houseSource:(NSString *)scource houseType:(NSString *)type houseThings:(NSString *)things houseFloor:(NSString *)floor housePosition:(NSString *)position;
@end
