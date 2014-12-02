//
//  BasicViewController.m
//  SmallPig
//
//  Created by clei on 14/11/5.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "BasicViewController.h"
#import "AppDelegate.h"

@interface BasicViewController ()
{

}
@end

@implementation BasicViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    startHeight = 0.0;
    //设置页面背景
    self.view.backgroundColor = BASIC_VIEW_BG_COLOR;
    
    self.navigationController.navigationBar.translucent = YES;

    /*
     *  效果等同IOS7 automaticallyAdjustsScrollViewInsets
     *
     *  UIScrollView *scrollView;
     *  UIEdgeInsets inset = scrollView.contentInset;
     *  inset.top = 64.0;
     *  scrollView.contentInset = inset;
     */
    self.automaticallyAdjustsScrollViewInsets = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}



#pragma mark 设置导航条Item
// 设置导航条Item
- (void)setNavBarItemWithImageName:(NSString *)imageName navItemType:(NavItemType)type selectorName:(NSString *)selName
{
    UIImage *image_up = [UIImage imageNamed:[imageName stringByAppendingString:@"_up.png"]];
    UIImage *image_down = [UIImage imageNamed:[imageName stringByAppendingString:@"_down.png"]];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, image_up.size.width/2, image_up.size.height/2);
    [button setBackgroundImage:image_up forState:UIControlStateNormal];
    [button setBackgroundImage:image_down forState:UIControlStateHighlighted];
    [button setBackgroundImage:image_down forState:UIControlStateSelected];
    if (selName && ![selName isEqualToString:@""])
    {
        [button addTarget:self action:NSSelectorFromString(selName) forControlEvents:UIControlEventTouchUpInside];
    }
    UIBarButtonItem  *barItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    if(type == LeftItem)
    self.navigationItem.leftBarButtonItem = barItem;
    else if (type == rightItem)
    self.navigationItem.rightBarButtonItem = barItem;
}

#pragma mark 添加返回Item
//添加返回按钮
- (void)addBackItem
{
    [self setNavBarItemWithImageName:@"back" navItemType:LeftItem selectorName:@"backButtonPressed:"];
}

- (void)backButtonPressed:(UIButton *)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark 添加个人item
//切换显示左视图按钮
- (void)addPersonItem
{
    [self setNavBarItemWithImageName:@"nav_person" navItemType:LeftItem selectorName:@"peopleButtonPressed:"];
}

- (void)peopleButtonPressed:(UIButton *)sender
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [app.sideViewController showLeftViewController:YES];
}

#pragma mark 添加搜索按钮
//点击搜索按钮
- (void)addSearchItem
{
    [self setNavBarItemWithImageName:@"nav_search" navItemType:rightItem selectorName:@""];
}

- (void)searchButtonPressed:(UIButton *)sender
{
    
}

#pragma mark 添加表
//添加表
- (void)addTableViewWithFrame:(CGRect)frame tableType:(UITableViewStyle)type tableDelegate:(id)delegate
{
    _table=[[UITableView alloc]initWithFrame:frame style:type];
    _table.dataSource=delegate;
    _table.delegate=delegate;
    _table.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_table];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
