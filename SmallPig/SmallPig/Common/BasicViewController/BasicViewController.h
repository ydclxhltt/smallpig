//
//  BasicViewController.h
//  SmallPig
//
//  Created by clei on 14/11/5.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

typedef enum : NSUInteger
{
    LeftItem,
    rightItem,
} NavItemType;

typedef enum : NSUInteger
{
    PushTypeRegister = 0 << 0,
    PushTypeFindPassWord = 1 << 1,
    PushTypeChangeMobile = 2 << 1,
    PushTypeChangePassword = 3 << 1,
} PushType;

typedef enum : NSUInteger
{
    HouseScourceFromRental,
    HouseScourceFromSecondHand,
} HouseScource;

#import <UIKit/UIKit.h>
 #import "AppDelegate.h"

@interface BasicViewController : UIViewController
{
    float startHeight;
    float scale;
}
@property(nonatomic,retain) NSMutableArray *dataArray;
@property(nonatomic,retain) UITableView *table;

/*
 *  设置导航条Item
 *
 *  @pram title     按钮title
 *  @pram type      NavItemType 设置左或右item的标识
 *  @pram selName   item按钮响应方法名
 */
- (void)setNavBarItemWithTitle:(NSString *)title navItemType:(NavItemType)type selectorName:(NSString *)selName;

/*
 *  设置导航条Item
 *
 *  @pram imageName 图片名字
 *  @pram type      NavItemType 设置左或右item的标识
 *  @pram selName   item按钮响应方法名
 */
- (void)setNavBarItemWithImageName:(NSString *)imageName navItemType:(NavItemType)type selectorName:(NSString *)selName;

/*
 *  设置导航条Item back按钮
 */
- (void)addBackItem;

/*
 *  设置导航条Item切换显示左视图按钮
 */
- (void)addPersonItem;

/*
 *  添加搜索按钮
 */
- (void)addSearchItem;

/*
 *  添加表视图，如：tableView
 *
 *  @pram frame     tableView的frame
 *  @pram type      UITableViewStyle
 *  @pram delegate  tableView的委托对象
 *
 */
- (void)addTableViewWithFrame:(CGRect)frame tableType:(UITableViewStyle)type tableDelegate:(id)delegate;

/*
 *  是否可侧滑
 */
- (void)setMainSideCanSwipe:(BOOL)canSwipe;
@end
