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
 *  @pram imageUrl  图片地址
 *  @pram title     房源描述
 *  @pram local     房源地区
 *  @pram park      小区名称
 *  @pram time      更新时间
 *  @pram type      房源类型
 *  @pram size      房源面积
 *  @pram price     房间价格
 */
- (void)setCellImageWithUrl:(NSString *)imageUrl titleText:(NSString *)title localText:(NSString *)local parkText:(NSString *)park timeText:(NSString *)time typeText:(NSString *)type sizeText:(NSString *)size priceText:(NSString *)price;

@end
