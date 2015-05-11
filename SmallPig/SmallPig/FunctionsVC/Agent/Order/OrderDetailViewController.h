//
//  OrderDetailViewController.h
//  SmallPig
//
//  Created by clei on 15/3/11.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//


#import "BasicViewController.h"

@interface OrderDetailViewController : BasicViewController

@property (nonatomic, strong) NSString *orderID;
@property (nonatomic, assign) int roomType;
@property (nonatomic, strong) NSDictionary *detailDic;
@end
