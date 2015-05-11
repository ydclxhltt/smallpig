//
//  OrderListViewController.m
//  SmallPig
//
//  Created by clei on 15/3/11.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "OrderListViewController.h"
#import "OrderListCell.h"
#import "OrderDetailViewController.h"
#import "SendOrderViewController.h"

@interface OrderListViewController ()

@end

@implementation OrderListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置title
    self.title = @"订单管理";
    //设置item
    [self addBackItem];
    if ([SmallPigApplication shareInstance].memberType != 0)
        [self setNavBarItemWithTitle:@"新建" navItemType:rightItem selectorName:@"createOrderButtonPressed:"];
    //初始化UI
    [self createUI];

    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //设置不可侧滑
    [self setMainSideCanSwipe:NO];
    //获取订单列表
    [self getOrderListData];
}

#pragma mark 初始化UI
- (void)createUI
{
    [self addTableView];
}

- (void)addTableView
{
    [self addTableViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) tableType:UITableViewStylePlain tableDelegate:self];
}


#pragma mark 获取订单列表
- (void)getOrderListData
{
    __block typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:LOADING_DEFAULT];
    RequestTool *request = [[RequestTool alloc] init];
    NSDictionary *requestDic = @{@"queryBean.params.buyer_id_long":[SmallPigApplication shareInstance].userInfoDic[@"id"]};
    [request requestWithUrl:MY_ORDER_LIST_URL requestParamas:requestDic requestType:RequestTypeAsynchronous requestSucess:^(AFHTTPRequestOperation *operation, id responseDic)
     {
         NSLog(@"order_responseDic===%@",responseDic);
         NSDictionary *dic = (NSDictionary *)responseDic;
         if ([dic[@"responseMessage"][@"success"] intValue] == 1)
         {
             weakSelf.dataArray = dic[@"pageBean"][@"data"];
             [weakSelf.table reloadData];
             [SVProgressHUD showSuccessWithStatus:LOADING_SUCESS];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:LOADING_FAILURE];
         }
     }
    requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
     {
        [SVProgressHUD showErrorWithStatus:LOADING_FAILURE];
         NSLog(@"login_error===%@",error);
     }];
}


#pragma mark 创建订单
- (void)createOrderButtonPressed:(UIButton *)sender
{
    SendOrderViewController *sendOrderViewController = [[SendOrderViewController alloc] init];
    [self.navigationController pushViewController:sendOrderViewController animated:YES];
}


#pragma mark - tableView代理


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *imageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15.0) placeholderImage:nil];
    imageView.backgroundColor = [UIColor clearColor];
    return imageView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ROW_HEIGHT;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"CellID";
    OrderListCell *cell = (OrderListCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[OrderListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    NSDictionary *rowDic = self.dataArray[indexPath.section];
    int status = [rowDic[@"orderStatus"] intValue];
    rowDic = rowDic[@"publishRoom"];
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
    NSString *roomStyle = [SmallPigTool makeEasyRoomStyleWithRoomDictionary:rowDic];
    int roomType = [rowDic[@"roomType"] intValue];
    float price = (roomType == 3) ? [rowDic[@"price"] floatValue] : [rowDic[@"price"] floatValue]/10000.0;
    NSString *roomPrice = (roomType == 3) ? [NSString stringWithFormat:@"%.0f元",price] : [NSString stringWithFormat:@"%.0f万",price];
    
    [(OrderListCell *)cell setCellImageWithUrl:imageUrl titleText:title localText:local parkText:park timeText:@"" typeText:roomStyle sizeText:square priceText:roomPrice];
    [(OrderListCell *)cell setStatusLabelTextWithStatus:status];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *rowDic = self.dataArray[indexPath.section];
    OrderDetailViewController *orderDetailViewController = [[OrderDetailViewController alloc] init];
    orderDetailViewController.orderID = rowDic[@"id"];
    orderDetailViewController.roomType = [rowDic[@"publishRoom"][@"roomType"] intValue];
    orderDetailViewController.detailDic = rowDic;
    [self.navigationController pushViewController:orderDetailViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
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
