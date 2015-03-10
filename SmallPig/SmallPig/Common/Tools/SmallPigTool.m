//
//  SmallPigTool.m
//  SmallPig
//
//  Created by clei on 15/3/10.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "SmallPigTool.h"

@implementation SmallPigTool

+ (NSString *)getTowardsWithIdentification:(NSString *)identification
{
    identification = [identification lowercaseString];
    NSString *towards = @"";
    if (identification && ![@"" isEqualToString:identification])
    {
        if ([@"e" isEqualToString:towards])
        {
            towards = @"东";
        }
        if ([@"w" isEqualToString:towards])
        {
            towards = @"西";
        }
        if ([@"n" isEqualToString:towards])
        {
            towards = @"倍";
        }
        if ([@"s" isEqualToString:towards])
        {
            towards = @"南";
        }
    }
    return towards;
}

@end
