//
//  HouseListCell.h
//  SmallPig
//
//  Created by chenlei on 14/11/26.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface RentalHouseListCell : UITableViewCell

/*
 *  设置图片地址和各个字段的值
 *
 *  @param imageUrl  图片地址
 *  @param title     房源描述
 *  @param local     房源地区
 *  @param park      小区名称
 *  @param time      更新时间
 *  @param type      房源类型
 *  @param size      房源面积
 *  @param price     房间价格
 */
- (void)setCellImageWithUrl:(NSString *)imageUrl titleText:(NSString *)title localText:(NSString *)local parkText:(NSString *)park timeText:(NSString *)time typeText:(NSString *)type sizeText:(NSString *)size priceText:(NSString *)price;

@end
