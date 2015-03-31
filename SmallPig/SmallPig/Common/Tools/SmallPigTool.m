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
+ (NSString *)makeStringWithArray:(NSArray *)dataArray selectedArray:(NSArray *)array
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
            NSDictionary *dic = dataArray[[array[i] intValue]];
            NSString *ID = dic[@"id"];
            string = [NSString stringWithFormat:@"%@%@,",string,ID];
        }
    }
    return string;
}

#pragma mark 几室几厅
+ (NSString *)makeRoomStyleWithRoomDictionary:(NSDictionary *)dic
{
    int bedroomCount = [dic[@"room"][@"bedroomCount"] intValue];
    int hallCount = [dic[@"room"][@"hallCount"] intValue];
    int kitchenCount = [dic[@"room"][@"kitchenCount"] intValue];
    int bathroomCount = [dic[@"room"][@"bathroomCount"] intValue];
    NSString *roomType = [NSString stringWithFormat:@"%d室%d厅%d厨%d卫",bedroomCount,hallCount,kitchenCount,bathroomCount];
    return roomType;
}

+ (NSString *)makeEasyRoomStyleWithRoomDictionary:(NSDictionary *)dic
{
    int bedroomCount = [dic[@"room"][@"bedroomCount"] intValue];
    int hallCount = [dic[@"room"][@"hallCount"] intValue];
    NSString *roomType = [NSString stringWithFormat:@"%d室%d厅",bedroomCount,hallCount];
    return roomType;
}

#pragma mark 处理时间
+ (NSString *)formatTimeWithString:(NSString *)time
{
    NSLog(@"time===%@",time);
    if (!time)
    {
        return @"";
    }
    NSString *timeStr = @"";
    NSArray *array = [time componentsSeparatedByString:@" "];
    if (array && [array count] > 0)
    {
        timeStr = array[0];
    }
//    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
//    formatter1.dateFormat = @"yyyy-MM-dd hh:mm:ss";
//    NSDate *date = [formatter1 dateFromString:time];
//    NSLog(@"date===%@",date);
//    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
//    formatter2.dateFormat = @"yyyy-MM-dd";
//    timeStr = [formatter2 stringFromDate:date];
//    NSLog(@"timeStr====%@",timeStr);
    timeStr = (timeStr) ? timeStr : @"";
    return timeStr;
}

#pragma mark 售价
+ (NSString *)getHousePrice:(NSString *)price
{
    price = (price) ? price : @"";
    NSString *housePrice = @"";
    housePrice = [NSString stringWithFormat:@" %.0f万",[price floatValue]/10000.0];
    return housePrice;
}

#pragma mark 房源标签和亮点转换字符串
//type 1:标签 2:优势
+ (NSString *)makeHouseFeature:(NSString *)feature type:(int)type
{
    feature = (feature) ? feature : @"";
    NSString *houseFeature = @"";
    NSArray *roomFeatureArray = (type == 1) ? [[SmallPigApplication shareInstance] houseLabelsArray] : [[SmallPigApplication shareInstance] houseGoodLabelsArray];
    if (roomFeatureArray && [roomFeatureArray count] > 0)
    {
        NSArray *featureArray = [feature componentsSeparatedByString:@","];
        if (featureArray && [featureArray count] > 0)
        {
            NSMutableArray *featureNameArray = [NSMutableArray array];
            for (int i = 0; i < [featureArray count]; i++)
            {
                NSString *featureID = featureArray[i];
                for (int j = 0; j < [roomFeatureArray count]; j++)
                {
                    NSDictionary *dic = roomFeatureArray[j];
                    NSString *roomFeatureID = [NSString stringWithFormat:@"%@",dic[@"paramCode"]];
                    roomFeatureID = (roomFeatureID) ? roomFeatureID : @"";
                    if ([roomFeatureID isEqualToString:featureID])
                    {
                        NSString *featureName = dic[@"showName"];
                        if (featureName && ![featureName isEqualToString:@""])
                        {
                             [featureNameArray addObject:featureName];
                        }
                    }
                }
            }
            houseFeature = ([featureNameArray count] > 0) ? [featureNameArray componentsJoinedByString:@", "] : @"无";
        }
       
    }
    return houseFeature;
}

@end
