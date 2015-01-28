//
//  HouseDetailViewController.m
//  SmallPig
//
//  Created by clei on 15/1/28.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "HouseDetailViewController.h"
#import "HouseDetailHeader.h"
#import "HouseDetailInfoView.h"

@interface HouseDetailViewController ()
{
    HouseDetailHeader *headerView;
    HouseDetailInfoView *detailInfoView;
}
@end

@implementation HouseDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //初始化UI
    [self createUI];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavBarAndStatusHidden:YES];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self setNavBarAndStatusHidden:NO];
}


#pragma mark  设置状态栏，导航条是否隐藏
- (void)setNavBarAndStatusHidden:(BOOL)isHidden
{
    //[[UIApplication sharedApplication] setStatusBarHidden:isHidden withAnimation:UIStatusBarAnimationSlide];
    [self.navigationController setNavigationBarHidden:isHidden animated:YES];
}

#pragma mark 初始化UI
- (void)createUI
{
    [self addtableView];
    [self addTableHeaderView];
}

- (void)addtableView
{
    [self addTableViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) tableType:UITableViewStylePlain tableDelegate:self];
    self.table.bounces = NO;
}

- (void)addTableHeaderView
{
    float height = 240.0 * scale;
    headerView = [[HouseDetailHeader alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height) delegate:self];
    headerView.delegate = self;
    [headerView setImageScrollViewData:@[@"http://pic1.ajkimg.com/display/xinfang/511f5c20201f6e60241b4d250fac4835/800x600c.jpg",@"http://pic1.ajkimg.com/display/xinfang/4e65e9d08df87df05d1536dbb60ebd25/800x600c.jpg",@"http://pic1.ajkimg.com/display/xinfang/3c440a580dd0244d4b69d0a0dba8dc10/800x600c.jpg"]];
    [self.table setTableHeaderView:headerView];
}

#pragma mark back
- (void)backButtonPressed:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark share
- (void)shareButtonPressed:(UIButton *)sender
{
    
}

#pragma mark save
- (void)saveButtonPressed:(UIButton *)sender
{
    
}

#pragma mark tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1)
    {
        return 90.0;
    }
    return HOUSE_LIST_HEIGHT;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.separatorInset = UIEdgeInsetsMake(0, 10.0, 0, 10.0);
    }
    
    if (indexPath.row == 1)
    {
        if (!detailInfoView)
        {
            detailInfoView = [[HouseDetailInfoView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 90.0) houseType:self.houseSource];
        }
        if (self.houseSource == HouseScourceFromRental)
        {
            [detailInfoView setDataWithHousePrice:@" 5200/月" HousePriceInfo:@" (押二付一)" houseSize:@" 160平米" houseSource:@" 现有房源" houseType:@" 三室一厅" houseThings:@" 精装修" houseFloor:@" 12/32" housePosition:@" 朝南"];
        }
        if (self.houseSource == HouseScourceFromSecondHand)
        {
            [detailInfoView setDataWithHousePrice:@" 480万" HousePriceInfo:@" 30000/平米" houseSize:@" 160平米" houseSource:@" 现有房源" houseType:@" 三室一厅" houseThings:@" 精装修" houseFloor:@" 12/32" housePosition:@" 朝南"];
        }
        [cell.contentView addSubview:detailInfoView];
    }
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
