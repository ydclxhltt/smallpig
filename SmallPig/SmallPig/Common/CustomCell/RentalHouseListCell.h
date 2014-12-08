//
//  HouseListCell.h
//  SmallPig
//
//  Created by chenlei on 14/11/26.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface RentalHouseListCell : UITableViewCell

- (void)setCellImageWithUrl:(NSString *)imageUrl titleText:(NSString *)title localText:(NSString *)local parkText:(NSString *)park timeText:(NSString *)time typeText:(NSString *)type sizeText:(NSString *)size priceText:(NSString *)price;

@end
