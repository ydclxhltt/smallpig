//
//  LookFor_Application.h
//  LookFor
//
//  Created by chenlei on 15/1/7.
//  Copyright (c) 2015年 chenmingguo. All rights reserved.
//

/*
 *  保存全局变量
 */

#import <Foundation/Foundation.h>

@interface SmallPigApplication : NSObject

@property (nonatomic, strong) NSDictionary *userInfoDic;
@property (nonatomic, strong) NSArray *cityList;
@property (nonatomic, strong) NSArray *houseLabelsArray;
@property (nonatomic, strong) NSArray *houseGoodLabelsArray;
@property (nonatomic, strong) NSArray *rentalHouseLabelsArray;
@property (nonatomic, strong) NSArray *rentalHouseGoodLabelsArray;
@property (nonatomic, strong) NSArray *sortHouseAreaParmaArray;
@property (nonatomic, strong) NSArray *sortHousePriceParmaArray;
@property (nonatomic, strong) NSArray *sortRentalHousePriceParmaArray;
@property (nonatomic, strong) NSArray *sortHouseBedroomParmaArray;
@property (nonatomic, strong) NSArray *citysArray;
@property (nonatomic, strong) NSArray *nidTypeArray;
@property (nonatomic, strong) NSArray *openBankArray;
@property (nonatomic, assign) int memberType;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, assign) int point;
@property (nonatomic, strong) NSString *cityID;
/*
 *  构建单例
 */
+ (instancetype)shareInstance;
@end
