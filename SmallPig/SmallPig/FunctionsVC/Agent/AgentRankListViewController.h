//
//  AgentRankListViewController.h
//  SmallPig
//
//  Created by clei on 14/12/9.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "BasicViewController.h"

typedef enum : NSUInteger {
    AgentTypeList,
    AgentTypeRank,
} AgentType;

@interface AgentRankListViewController : BasicViewController
@property (nonatomic, assign) AgentType agentType;
@end
