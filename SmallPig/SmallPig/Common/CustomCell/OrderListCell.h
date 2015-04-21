//
//  OrderListCell.h
//  SmallPig
//
//  Created by clei on 15/3/12.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TITLE_LABEL_HEIGHT    20.0
#define ORDER_STATUES_HEIGHT  40.0
#define HOUST_INFO_HEIGHT     90.0
#define ROW_HEIGHT            HOUST_INFO_HEIGHT + TITLE_LABEL_HEIGHT + ORDER_STATUES_HEIGHT

@interface OrderListCell : UITableViewCell


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
- (void)setStatusLabelTextWithStatus:(int)status;
@end
