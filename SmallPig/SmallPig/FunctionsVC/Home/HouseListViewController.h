//
//  HouseListViewController.h
//  SmallPig
//
//  Created by clei on 14/12/5.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "BasicViewController.h"

@interface HouseListViewController : BasicViewController
@property (nonatomic, assign) HouseScource houseSource;
@property (nonatomic, strong) NSString *searchParma;
- (void)getData;
- (void)createUI;
@end
