//
//  BasicViewController.m
//  SmallPig
//
//  Created by clei on 14/11/5.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "BasicViewController.h"
#import "SearchHouseViewController.h"

@interface BasicViewController ()<UIGestureRecognizerDelegate,UIScrollViewDelegate>
{
    UIImageView *titleView;
    UILabel *footLabel;
}
@end

@implementation BasicViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    startHeight = 0.0;
    scale = SCREEN_WIDTH/320.0;
    isCanGetMore = YES;
    currentPage = 1;
    //设置页面背景
    self.view.backgroundColor = BASIC_VIEW_BG_COLOR;
    
    //设置导航条
    [self.navigationController.navigationBar setBackgroundImage:[CommonTool imageWithColor:APP_MAIN_COLOR] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:WHITE_COLOR,NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:dic];
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.navigationController.navigationBar.translucent = YES;
    //self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    //self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    /*
     *  效果等同IOS7 automaticallyAdjustsScrollViewInsets
     *
     *  UIScrollView *scrollView;
     *  UIEdgeInsets inset = scrollView.contentInset;
     *  inset.top = 64.0;
     *  scrollView.contentInset = inset;
     */
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}



#pragma mark 设置导航条Item

// 1.设置导航条Item
- (void)setNavBarItemWithTitle:(NSString *)title navItemType:(NavItemType)type selectorName:(NSString *)selName
{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                   target:nil action:nil];
     negativeSpacer.width = (LeftItem == type) ? -15 : 15;
    //float x = negativeSpacer.width;
    float x = (LeftItem == type) ? negativeSpacer.width : 0;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(x, 0, 60, 30);
    button.showsTouchWhenHighlighted = YES;
    button.titleLabel.font = FONT(17.0);
    [button setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    if (selName && ![@"" isEqualToString:selName])
    {
        [button addTarget:self action:NSSelectorFromString(selName) forControlEvents:UIControlEventTouchUpInside];
    }
    UIBarButtonItem  *barItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    if(LeftItem == type)
        self.navigationItem.leftBarButtonItems = @[negativeSpacer,barItem];
    else if (rightItem == type)
        self.navigationItem.rightBarButtonItems = @[barItem];
}


// 2.设置导航条Item
- (void)setNavBarItemWithImageName:(NSString *)imageName navItemType:(NavItemType)type selectorName:(NSString *)selName
{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                   target:nil action:nil];
    negativeSpacer.width = (LeftItem == type) ? -15 : 15;
    float x = (LeftItem == type) ? negativeSpacer.width : 0;
    //float x = negativeSpacer.width;
    
    UIImage *image_up = [UIImage imageNamed:[imageName stringByAppendingString:@"_up.png"]];
    UIImage *image_down = [UIImage imageNamed:[imageName stringByAppendingString:@"_down.png"]];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(x, 0, image_up.size.width/2, image_up.size.height/2);
    [button setBackgroundImage:image_up forState:UIControlStateNormal];
    [button setBackgroundImage:image_down forState:UIControlStateHighlighted];
    [button setBackgroundImage:image_down forState:UIControlStateSelected];
    if (selName && ![@"" isEqualToString:selName])
    {
        [button addTarget:self action:NSSelectorFromString(selName) forControlEvents:UIControlEventTouchUpInside];
    }
    UIBarButtonItem  *barItem = [[UIBarButtonItem alloc]initWithCustomView:button];

    if(LeftItem == type)
        self.navigationItem.leftBarButtonItems = @[negativeSpacer,barItem];
    else if (rightItem == type)
        self.navigationItem.rightBarButtonItems = @[barItem];
}

#pragma mark 添加返回Item
//添加返回按钮
- (void)addBackItem
{
    [self setNavBarItemWithImageName:@"back" navItemType:LeftItem selectorName:@"backButtonPressed:"];
}

- (void)backButtonPressed:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    SearchHouseViewController *searchHouseViewController = [[SearchHouseViewController alloc]init];
    [self.navigationController pushViewController:searchHouseViewController animated:NO];
}


#pragma mark 设置titleView
- (void)setTitleViewWithArray:(NSArray *)array
{
    if (!array || [array count] == 0)
        return;
    
    float width = 180.0 * scale;
    float height = 30.0;
    titleView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, 0, width, height) placeholderImage:nil];
    titleView.clipsToBounds = YES;
    titleView.userInteractionEnabled = YES;
    [CommonTool setViewLayer:titleView withLayerColor:[UIColor whiteColor] bordWidth:1.0];
    [CommonTool clipView:titleView withCornerRadius:5.0];
    self.navigationItem.titleView = titleView;
    
    
    for (int i = 0; i<[array count]; i++)
    {
        UIButton *button = [CreateViewTool  createButtonWithFrame:CGRectMake(i * width/[array count], 0, width/[array count], titleView.frame.size.height) buttonTitle:array[i] titleColor:[UIColor whiteColor] normalBackgroundColor:[UIColor clearColor] highlightedBackgroundColor:[UIColor clearColor] selectorName:@"buttonPressed:" tagDelegate:self];
        button.tag = i + 1;
        button.titleLabel.font = FONT(15.0);
        [button setBackgroundImage:[CommonTool imageWithColor:[UIColor whiteColor]] forState:UIControlStateSelected];
        [button setTitleColor:APP_MAIN_COLOR forState:UIControlStateSelected];
        button.selected = (i == 0) ? YES : NO;
        [titleView addSubview:button];
    }
    
}

- (void)buttonPressed:(UIButton *)sender
{
    sender.selected = YES;
    for (UIButton *button in titleView.subviews)
    {
        button.selected = (button.tag == sender.tag) ? YES : NO;
    }
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

#pragma mark 添加更多视图
- (void)addGetMoreView
{
    if (!footLabel)
    {
        footLabel = [CreateViewTool createLabelWithFrame:CGRectMake(0, self.table.contentSize.height, SCREEN_WIDTH, 20.0) textString:@"更多数据加载中..." textColor:HOME_LIST_DETAIL_COLOR textFont:FONT(12.0)];
        footLabel.backgroundColor = [UIColor whiteColor];
        footLabel.textAlignment = NSTextAlignmentCenter;
        //暂时不显示 屏蔽
        footLabel.alpha = 0.0;
        [self.table addSubview:footLabel];
    }
    else
    {
        footLabel.frame = CGRectMake(0, self.table.contentSize.height, SCREEN_WIDTH, 20.0);
    }
    
}

- (void)removeGetMoreView
{
    [footLabel removeFromSuperview];
    footLabel = nil;
}


#pragma mark 是否可以侧滑
- (void)setMainSideCanSwipe:(BOOL)canSwipe
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.sideViewController.needSwipeShowMenu = canSwipe;
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float offset_y = scrollView.contentOffset.y;
    if ((int)offset_y == (int)self.table.contentSize.height - SCREEN_HEIGHT)
    {
        currentPage++;
        [self getMoreData];
    }
}

#pragma mark 加载更多
- (void)getMoreData
{
    
}

- (void)dealloc
{
    self.table.delegate = nil;
    self.table.dataSource = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
