//
//  AgentHouseInfoViewController.h
//  SmallPig
//
//  Created by clei on 15/1/30.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "BasicViewController.h"

typedef enum : NSUInteger
{
    HouseInfoTypeDetail,
    HouseInfoTypePublic,
} HouseInfoType;

@interface AgentHouseInfoViewController : BasicViewController
@property (nonatomic, assign) HouseInfoType *houseInfoType;
@end
