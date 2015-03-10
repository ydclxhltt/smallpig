//
//  DropDownView.h
//  SmallPig
//
//  Created by clei on 14/12/4.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateViewTool.h"
@interface DropDownView : UIView

@property(nonatomic, retain) UILabel *titleLabel;

/*
 *  初始化视图方法
 *
 *  @param   title   默认初始title
 *  @param   click   按钮的点击相应的block
 */
- (void)createViewWithTitle:(NSString *)title clickedBlock:(void (^)())click;

- (void)setTitleLabelText:(NSString *)text;

@end
