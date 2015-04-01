//
//  SavePublicCell.h
//  SmallPig
//
//  Created by clei on 15/4/1.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SavePublicCell : UITableViewCell

- (void)setCellImageWithUrl:(NSString *)imageUrl titleText:(NSString *)title localText:(NSString *)local parkText:(NSString *)park priceText:(NSString *)price typeText:(NSString *)type sizeText:(NSString *)size;
@end
