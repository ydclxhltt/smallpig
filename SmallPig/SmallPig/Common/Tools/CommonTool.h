//
//  CommonTool.h
//  SmallPig
//
//  Created by clei on 14/11/6.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonTool : NSObject

/*
 * 判断手机号或邮箱是否合法
 *
 * @pram string 手机号或者邮箱字符串
 *
 * @return 返回格式是否合法
 */
+ (BOOL)isEmailOrPhoneNumber:(NSString*)string;

/*
 * 判断身份证是否合法
 *
 * @pram identityCard 身份证号码字符串
 *
 * @return 返回格式是否合法
 */
+ (BOOL) validateIdentityCard: (NSString *)identityCard;

/*
 * 颜色生成图片
 *
 * @pram color 颜色
 *
 * @return 返回图片对象
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/*
 * 根据UILabel计算高度和设置Label高度和行数
 *
 * @pram textLabel  Label
 * @pram font       字体
 *
 * @return 返回字符串高度
 */
+ (float)labelHeightWithTextLabel:(UILabel *)textLabel textFont:(UIFont *)font;

/*
 * 根据字符串计算高度文字高度
 *
 * @pram text       字符串
 * @pram font       字体
 * @pram width      字符串显示区域宽度
 *
 * @return 返回字符串高度
 */
+ (float)labelHeightWithText:(NSString *)text textFont:(UIFont*)font labelWidth:(float)width;
@end
