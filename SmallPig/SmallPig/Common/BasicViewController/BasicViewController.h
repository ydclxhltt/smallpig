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
@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,strong) UITableView *table;

/*
 *  设置导航条Item
 *
 *  @param title     按钮title
 *  @param type      NavItemType 设置左或右item的标识
 *  @param selName   item按钮响应方法名
 */
- (void)setNavBarItemWithTitle:(NSString *)title navItemType:(NavItemType)type selectorName:(NSString *)selName;

/*
 *  设置导航条Item
 *
 *  @param imageName 图片名字
 *  @param type      NavItemType 设置左或右item的标识
 *  @param selName   item按钮响应方法名
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
 *  设置titleView
 *  @param array 选项卡title数组
 */
- (void)setTitleViewWithArray:(NSArray *)array;

/*
 *  选项卡相应事件
 */
- (void)buttonPressed:(UIButton *)sender;

/*
 *  添加表视图，如：tableView
 *
 *  @param frame     tableView的frame
 *  @param type      UITableViewStyle
 *  @param delegate  tableView的委托对象
 *
 */
- (void)addTableViewWithFrame:(CGRect)frame tableType:(UITableViewStyle)type tableDelegate:(id)delegate;

/*
 *  是否可侧滑
 */
- (void)setMainSideCanSwipe:(BOOL)canSwipe;
@end
