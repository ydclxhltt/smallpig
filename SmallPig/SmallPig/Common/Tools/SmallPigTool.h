//
//  SmallPigTool.h
//  SmallPig
//
//  Created by clei on 15/3/10.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SmallPigTool : NSObject

/*
 *  方位字母转化字符串
 *
 *  @param identification 方位标示
 */
+ (NSString *)getTowardsWithIdentification:(NSString *)identification;

/*
 *  拼接图片地址
 *
 *  @param identification 方位标示
 */
+ (NSString *)makePhotoUrlWithPhotoUrl:(NSString *)url  photoSize:(NSString *)size photoType:(NSString *)type;

/*
 *  装修
 *
 *  @param index 装修表示
 */
+ (NSString *)getDecorateWithIndex:(int)index;

/*
 *  选择ID数组转字符串
 *
 *  @param dataArray  真实数据
 *  @param array      选择数据数组
 */
+ (NSString *)makeStringWithArray:(NSArray *)dataArray selectedArray:(NSArray *)array;

/*
 *  几室几厅
 *
 *  @param dic  roomDic
 */
+ (NSString *)makeRoomStyleWithRoomDictionary:(NSDictionary *)dic;
+ (NSString *)makeEasyRoomStyleWithRoomDictionary:(NSDictionary *)dic;

/*
 *  格式化时间
 *
 *  @param time  时间字符串
 */
+ (NSString *)formatTimeWithString:(NSString *)time;

/*
 *  售价换算成W
 *
 *  @param price  售价单位元
 */
+ (NSString *)getHousePrice:(NSString *)price;


/*
 *  ID转showName
 *
 *  @param feature  ID
 *  @param type     type 1:标签 2:优势
 */
+ (NSString *)makeHouseFeature:(NSString *)feature type:(int)type;

@end
