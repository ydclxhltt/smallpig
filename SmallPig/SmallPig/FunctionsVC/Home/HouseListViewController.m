//
//  HouseListViewController.m
//  SmallPig
//
//  Created by clei on 14/12/5.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "HouseListViewController.h"
#import "RentalHouseListCell.h"

@interface HouseListViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@end

@implementation HouseListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置title
    [self setCurrentTitle];
    //添加返回item
    [self addBackItem];
    //添加搜索按钮
    [self addSearchItem];
    //初始化视图
    [self createUI];
    //test数据
    self.dataArray = (NSMutableArray *)@[@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1"];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    //设置不可侧滑
    [self setMainSideCanSwipe:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self setNavBarAndStatusHidden:NO];
}


#pragma mark 设置title
- (void)setCurrentTitle
{
    if (HouseScouceFromRental == self.houseSouce)
    {
        self.title = RENTAL_HOUSE_TITLE;
    }
    else if (HouseScouceFromSecondHand == self.houseSouce)
    {
        self.title = SECOND_HAND_TITLE;
    }
}

#pragma mark 创建UI
//添加UI
- (void)createUI
{
    [self addTableView];
}

//添加表
- (void)addTableView
{
    [self addTableViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) tableType:UITableViewStylePlain tableDelegate:self];
    self.table.separatorColor = HOUSE_LIST_SEPLINE_COLOR;
    self.table .backgroundColor = [UIColor clearColor];
    
}



#pragma mark  设置状态栏，导航条是否隐藏
- (void)setNavBarAndStatusHidden:(BOOL)isHidden
{
    [[UIApplication sharedApplication] setStatusBarHidden:isHidden withAnimation:UIStatusBarAnimationSlide];
    [self.navigationController setNavigationBarHidden:isHidden animated:YES];
}

#pragma marl ScrollViewDeleagte

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float offset_y = scrollView.contentOffset.y;
    if (offset_y >= 64)
    {
        [self setNavBarAndStatusHidden:YES];
    }
    else if(offset_y <= 20)
    {
        [self setNavBarAndStatusHidden:NO];
    }
}


#pragma mark  tableView委托方法

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  HOUSE_LIST_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"HouseListCellID";
    RentalHouseListCell *cell = (RentalHouseListCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[RentalHouseListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor whiteColor];
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        if (SCREEN_WIDTH > 320.0)
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    //@"http://b.pic1.ajkimg.com/display/xinfang/51255643cbafacad2f37506a86e1ccae/245x184c.jpg"
    [cell setCellImageWithUrl:@"" titleText:@"业主直租核心地段超值两房急租" localText:@"宝安西乡" parkText:@"财富港" timeText:@"20分钟前" typeText:@"2室1厅" sizeText:@"75平米" priceText:@"2900元"];
    
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
