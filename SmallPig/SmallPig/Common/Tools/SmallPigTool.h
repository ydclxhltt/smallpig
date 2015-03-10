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
@end
