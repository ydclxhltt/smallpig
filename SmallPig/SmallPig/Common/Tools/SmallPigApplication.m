//
//  LookFor_Application.m
//  LookFor
//
//  Created by chenlei on 15/1/7.
//  Copyright (c) 2015年 chenmingguo. All rights reserved.
//

#import "SmallPigApplication.h"

@implementation SmallPigApplication

static SmallPigApplication *_shareInstace = nil;


- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
       
    }
    return self;
}

+ (instancetype)shareInstance
{
    if (_shareInstace != nil)
    {
        return _shareInstace;
    }
    @synchronized(self)
    {
        if (_shareInstace == nil)
        {
            _shareInstace = [[self alloc] init];
            _shareInstace.cityID = @"sz";
        }
    }
    return _shareInstace;
}

@end
