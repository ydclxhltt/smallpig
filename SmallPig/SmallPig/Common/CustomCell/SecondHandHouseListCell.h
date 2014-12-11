//
//  SecondHandHouseListCell.h
//  SmallPig
//
//  Created by clei on 14/12/11.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondHandHouseListCell : UITableViewCell

- (void)setCellImageWithUrl:(NSString *)imageUrl titleText:(NSString *)title localText:(NSString *)local parkText:(NSString *)park priceText:(NSString *)price typeText:(NSString *)type sizeText:(NSString *)size advantage1Text:(NSString *)advantage1 advantage2Text:(NSString *)advantage2 advantage3Text:(NSString *)advantage3;

@end
