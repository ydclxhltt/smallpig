//
//  HouseListViewController.m
//  SmallPig
//
//  Created by clei on 14/12/5.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "HouseListViewController.h"
#import "RentalHouseListCell.h"
#import "SecondHandHouseListCell.h"
#import "SavePublicCell.h"
#import "HouseDetailViewController.h"
#import "DorpDownListView.h"

#define SORTVIEW_HEIGHT 44.0

@interface HouseListViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) NSString *urlString;
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
    //初始化数据
    currentPage = 1;
    //获取房屋数据
    [self getData];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    //设置不可侧滑
    [self setMainSideCanSwipe:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    //[self setNavBarAndStatusHidden:NO];
}


#pragma mark 设置title
- (void)setCurrentTitle
{
    if (HouseScourceFromRental == self.houseSource)
    {
        self.title = RENTAL_HOUSE_TITLE;
    }
    else if (HouseScourceFromSecondHand == self.houseSource)
    {
        self.title = SECOND_HAND_TITLE;
    }
}

#pragma mark 创建UI
//添加UI
- (void)createUI
{
    if (self.houseSource == HouseScourceFromSecondHand || self.houseSource == HouseScourceFromRental)
    {
        startHeight = SORTVIEW_HEIGHT;
    }
    else
    {
        startHeight = 0.0;
    }
    [self addTableView];
    [self addSortView];
    
    
}

//添加表
- (void)addTableView
{
    [self addTableViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) tableType:UITableViewStylePlain tableDelegate:self];
    self.table.separatorColor = HOUSE_LIST_SEPLINE_COLOR;
    self.table .backgroundColor = [UIColor clearColor];
}

//添加sort试图
- (void)addSortView
{
    DorpDownListView *dorpView = [[DorpDownListView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    [dorpView setListViewWithColumnArray:[SmallPigApplication shareInstance].sortHouseAreaParmaArray];
    [self.view addSubview:dorpView];
}


#pragma mark 获取数据
- (void)getData
{
    if (HouseScourceFromSecondHand == self.houseSource)
    {
        self.urlString = SECOND_LIST_URL;
    }
    else if (HouseScourceFromRental == self.houseSource)
    {
        self.urlString = RENTAL_LIST_URL;
    }
    else if (HouseScourceFromSave == self.houseSource)
    {
        self.urlString = SAVE_LIST_URL;
    }
    else if (HouseScourceFromPublic == self.houseSource)
    {
        self.urlString = [PUBLIC_ROOM_LIST_URL stringByAppendingString:self.publicParma];
    }
    [SVProgressHUD showWithStatus:LOADING_DEFAULT];
    __weak typeof(self) weakSelf = self;
    NSDictionary *requestDic = @{@"queryBean.pageSize":@(10),@"queryBean.pageNo":@(currentPage)};
    RequestTool *request = [[RequestTool alloc] init];
    [request requestWithUrl:self.urlString requestParamas:requestDic requestType:RequestTypeAsynchronous
    requestSucess:^(AFHTTPRequestOperation *operation, id responseObj)
    {
        NSLog(@"responseObj====%@",responseObj);
        isCanGetMore = YES;
        NSDictionary *dic = (NSDictionary *)responseObj;
        int sucess = [dic[@"responseMessage"][@"success"] intValue];
        if (sucess == 1)
        {
            [SVProgressHUD showSuccessWithStatus:LOADING_SUCESS];
            [weakSelf setHouseDataWithDictionary:dic];
        }
        else
        {
            if (currentPage > 1)
            {
                currentPage--;
            }
            [SVProgressHUD showErrorWithStatus:LOADING_FAILURE];
            [weakSelf.table reloadData];
        }
    }
    requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"error====%@",error);
        if (currentPage > 1)
        {
            currentPage--;
        }
        isCanGetMore = YES;
        [SVProgressHUD showErrorWithStatus:LOADING_FAILURE];
        [weakSelf.table reloadData];
    }];
}

#pragma mark 加载更多
- (void)getMoreData
{
    if (!isCanGetMore)
    {
        currentPage--;
        return;
    }
    isCanGetMore = NO;
    [self getData];
}

#pragma mark 设置数据
- (void)setHouseDataWithDictionary:(NSDictionary *)dic
{
    NSArray *array = dic[@"pageBean"][@"data"];
    int pageCount = [dic[@"pageBean"][@"totalPages"] intValue];

    if (!self.dataArray)
    {
        if (!array || [array count] == 0)
        {
            [CommonTool addAlertTipWithMessage:@"暂无数据"];
        }
        else
        {
            self.dataArray = [NSMutableArray arrayWithArray:array];
        }
    }
    else
    {
        if (array && [array count] > 0)
            [self.dataArray addObjectsFromArray:array];
    }
    [self.table reloadData];
    
    if (pageCount > currentPage)
    {
        [self addGetMoreView];
    }
    else
    {
        [self removeGetMoreView];
        isCanGetMore = NO;
    }
}

#pragma marl ScrollViewDeleagte

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    float offset_y = scrollView.contentOffset.y;
//    if (offset_y >= NAV_HEIGHT)
//    {
//        [self setNavBarAndStatusHidden:YES];
//    }
//    else if(offset_y <= 20)
//    {
//        [self setNavBarAndStatusHidden:NO];
//    }
//}

#pragma mark  设置状态栏，导航条是否隐藏
- (void)setNavBarAndStatusHidden:(BOOL)isHidden
{
    [[UIApplication sharedApplication] setStatusBarHidden:isHidden withAnimation:UIStatusBarAnimationSlide];
    [self.navigationController setNavigationBarHidden:isHidden animated:YES];
}

#pragma mark  tableView委托方法

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.houseSource == HouseScourceFromSave || self.houseSource == HouseScourceFromPublic)
    {
        return SAVE_LIST_HEIGHT;
    }
    return  HOUSE_LIST_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"HouseListCellID";
    static NSString *cellID1 = @"SecondHandListCellID";
    
    UITableViewCell *cell;
    NSDictionary *rowDic = self.dataArray[indexPath.row];
    if (self.houseSource == HouseScourceFromSave)
    {
        rowDic = rowDic[@"publishRoom"];
    }
    NSString *title = rowDic[@"title"];

    title = (title) ? title : @"";
    
    NSString *imageUrl = [SmallPigTool makePhotoUrlWithPhotoUrl:rowDic[@"coverPhoto"][@"photoUrl"] photoSize:HOUSE_LIST_ICON_SIZE photoType:rowDic[@"coverPhoto"][@"photoType"]];
    NSLog(@"imageUrl===%@",imageUrl );
    NSString *local = rowDic[@"room"][@"community"][@"address"];
    local = (local) ? local : @"";
    NSLog(@"local===%@",local);
    NSString *park = rowDic[@"room"][@"community"][@"name"];
    park = (park) ? park : @"";
    NSString *square = [NSString stringWithFormat:@"%@平米",rowDic[@"room"][@"square"]];
    square = (square) ? square : @"";
    float price = [rowDic[@"price"] floatValue]/10000.0;
    NSString *roomPrice = [NSString stringWithFormat:@"%.0f万",price];
    NSString *roomStyle = [SmallPigTool makeEasyRoomStyleWithRoomDictionary:rowDic];
    
    if (HouseScourceFromSecondHand == self.houseSource)
    {
        cell = (SecondHandHouseListCell *)[tableView dequeueReusableCellWithIdentifier:cellID1];
        if (!cell)
        {
            cell = [[SecondHandHouseListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID1];
            cell.backgroundColor = [UIColor whiteColor];
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            if (SCREEN_WIDTH > 320.0)
            {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
        NSString *feature = [SmallPigTool makeHouseFeature:rowDic[@"roomFeature"] type:1];
        NSArray *array = [feature componentsSeparatedByString:@", "];
        NSString *string1 = @"";
        NSString *string2 = @"";
        NSString *string3 = @"";
        if (array && [array count] > 0)
        {
            string1 = array[0];
            if ([array count] > 1)
            {
                string2 = array[1];
            }
            if ([array count] > 2)
            {
                string3 = array[2];
            }
        }
        [(SecondHandHouseListCell *)cell setCellImageWithUrl:imageUrl titleText:title localText:local parkText:park priceText:roomPrice typeText:roomStyle sizeText:square advantage1Text:string1 advantage2Text:string2 advantage3Text:string3];
    }
    else if (HouseScourceFromRental == self.houseSource)
    {
        cell = (RentalHouseListCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
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
        [(RentalHouseListCell *)cell setCellImageWithUrl:imageUrl titleText:title localText:local parkText:park timeText:@"" typeText:roomStyle sizeText:square priceText:[NSString stringWithFormat:@"%.0f元",[rowDic[@"price"] floatValue]]];
    }
    else if (HouseScourceFromSave == self.houseSource || HouseScourceFromPublic == self.houseSource)
    {
        cell = (SavePublicCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell)
        {
            cell = [[SavePublicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.backgroundColor = [UIColor whiteColor];
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            if (SCREEN_WIDTH > 320.0)
            {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
        int roomType = [rowDic[@"roomType"] intValue];
        float price = (roomType == 3) ? [rowDic[@"price"] floatValue] : [rowDic[@"price"] floatValue]/10000.0;
        NSString *roomPrice = (roomType == 3) ? [NSString stringWithFormat:@"%.0f元",price] : [NSString stringWithFormat:@"%.0f万",price];
        
        [(SavePublicCell *)cell setCellImageWithUrl:imageUrl titleText:title localText:local parkText:park priceText:roomPrice typeText:roomStyle sizeText:square];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = self.dataArray[indexPath.row];
    if (self.houseSource == HouseScourceFromSave)
    {
        dic = dic[@"publishRoom"];
    }
    NSString *roomID = dic[@"id"];
    roomID = (roomID) ? roomID : @"";

    int roomType = [dic[@"roomType"] intValue];
    HouseDetailViewController *houseDetailViewController = [[HouseDetailViewController alloc] init];
    houseDetailViewController.houseSource = (roomType == 3) ? HouseScourceFromRental : HouseScourceFromSecondHand;
    houseDetailViewController.roomID = roomID;
    [self.navigationController pushViewController:houseDetailViewController animated:YES];
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
