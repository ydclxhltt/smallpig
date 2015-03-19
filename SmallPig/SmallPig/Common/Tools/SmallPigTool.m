//
//  SmallPigTool.m
//  SmallPig
//
//  Created by clei on 15/3/10.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "SmallPigTool.h"

@implementation SmallPigTool

#pragma mark 获取方位
+ (NSString *)getTowardsWithIdentification:(NSString *)identification
{
    identification = [identification lowercaseString];
    NSString *towards = @"";
    if (identification && ![@"" isEqualToString:identification])
    {
        if ([@"e" isEqualToString:identification])
        {
            towards = @"朝东";
        }
        if ([@"w" isEqualToString:identification])
        {
            towards = @"朝西";
        }
        if ([@"n" isEqualToString:identification])
        {
            towards = @"朝北";
        }
        if ([@"s" isEqualToString:identification])
        {
            towards = @"朝南";
        }
        if ([@"es" isEqualToString:identification])
        {
            towards = @"朝东南";
        }
        if ([@"ws" isEqualToString:identification])
        {
            towards = @"朝西南";
        }
        if ([@"wn" isEqualToString:identification])
        {
            towards = @"朝西北";
        }
        if ([@"en" isEqualToString:identification])
        {
            towards = @"朝东北";
        }
    }
    return towards;
}

#pragma mark 获取装修
+ (NSString *)getDecorateWithIndex:(int)index
{
    NSString *decorate = @"";
    switch (index)
    {
        case 1:
            decorate = @"毛坯";
            break;
        case 2:
            decorate = @"普通装修";
            break;
        case 3:
            decorate = @"精装修";
            break;
        case 4:
            decorate = @"豪华装修";
            break;
        default:
            break;
    }
    return decorate;
}

#pragma mark 获取图片地址
+ (NSString *)makePhotoUrlWithPhotoUrl:(NSString *)url  photoSize:(NSString *)size photoType:(NSString *)type
{
    url = (url) ? url : @"";
    type = (type) ? type : @"";
    size = (size) ? size : @"";
    return [NSString stringWithFormat:@"%@/%@.%@",url,size,type];
}

#pragma mark 获取选择ID
- (NSString *)makeStringWithArray:(NSArray *)dataArray selectedArray:(NSArray *)array
{
    NSString *string = @"";
    if (!dataArray || [dataArray count] == 0)
    {
        for (int j = 0; j < [array count]; j++)
        {
            string = [NSString stringWithFormat:@"%@%@,",string,array[j]];
        }
        return string;
    }
    else
    {
        if (!array || [array count] == 0)
        {
            return string;
        }
        for (int i = 0; i < [array count]; i++)
        {
            string = [NSString stringWithFormat:@"%@%@,",string,dataArray[[array[i] intValue]]];
        }
    }
    return string;
}


@end
