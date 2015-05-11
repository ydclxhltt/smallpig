//
//  MineOrderListViewController.m
//  SmallPig
//
//  Created by clei on 15/4/21.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#define ROW_HEIGHT  90.0

#import "MineOrderListViewController.h"
#import "OrderDetailViewController.h"


@interface MineOrderListViewController ()
{
    int currentPage;
}
@end

@implementation MineOrderListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    currentPage = 1;
    self.title = @"我的订单";
    [self addBackItem];
    [self createUI];
    [self getMineOrderList];
    // Do any additional setup after loading the view.
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

#pragma mark 获取数据
- (void)getMineOrderList
{
    [SVProgressHUD showWithStatus:LOADING_DEFAULT];
    //NSString *userID = [[SmallPigApplication shareInstance] userID];
    __weak typeof(self) weakSelf = self;
    NSDictionary *requestDic = @{@"queryBean.pageSize":@(10),@"queryBean.pageNo":@(currentPage)};
    RequestTool *request = [[RequestTool alloc] init];
    [request requestWithUrl:MY_ORDER_LIST_URL requestParamas:requestDic requestType:RequestTypeAsynchronous
              requestSucess:^(AFHTTPRequestOperation *operation, id responseObj)
     {
         NSLog(@"responseObj====%@",responseObj);
         isCanGetMore = YES;
         NSDictionary *dic = (NSDictionary *)responseObj;
         int sucess = [dic[@"responseMessage"][@"success"] intValue];
         if (sucess == 1)
         {
             [SVProgressHUD showSuccessWithStatus:LOADING_SUCESS];
             [weakSelf setDataWithDictionary:dic];
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
    [self getMineOrderList];
}

#pragma mark 设置数据
- (void)setDataWithDictionary:(NSDictionary *)dic
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

#pragma mark tableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  ROW_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
        cell.imageView.transform = CGAffineTransformMakeScale(.5, .5);
    }
    NSDictionary *rowDic = self.dataArray[indexPath.row];
    [cell.imageView setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"agent_icon_default.png"]];
    NSString *name = rowDic[@"publishRoom"][@"publisher"][@"bankAcctName"];
    name = (name) ? name : @"";
    cell.textLabel.text = name;
    cell.textLabel.font = FONT(15.0);
    cell.detailTextLabel.text = @"向你发起了订单";
    cell.detailTextLabel.font = FONT(13.0);
    UILabel *statusLabel = (UILabel *)cell.accessoryView;
    if (!statusLabel)
    {
        statusLabel = [CreateViewTool createLabelWithFrame:CGRectMake(0, 0 , 120, ROW_HEIGHT) textString:@"" textColor:MINE_CENTER_LIST_COLOR textFont:MINE_CENTER_LIST_FONT];
        statusLabel.textAlignment = NSTextAlignmentRight;
    }
    cell.accessoryView = statusLabel;
    int status = [rowDic[@"orderStatus"] intValue];
    [self setOrderStatus:status forLabel:statusLabel];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *rowDic = self.dataArray[indexPath.row];
    OrderDetailViewController *orderDetailViewController = [[OrderDetailViewController alloc] init];
    orderDetailViewController.orderID = rowDic[@"id"];
    orderDetailViewController.roomType = [rowDic[@"publishRoom"][@"roomType"] intValue];
    orderDetailViewController.detailDic = rowDic;
    [self.navigationController pushViewController:orderDetailViewController animated:YES];
}


#pragma mark 设置订单状态
- (void)setOrderStatus:(int)status forLabel:(UILabel *)label
{
    NSLog(@"status===%d",status);
    NSString *text = @"";
    UIColor *color = nil;
    switch (status)
    {
        case 0:
            text = @"订单取消";
            color = RGB(138.0, 138.0, 138.0);
            break;
        case 1:
            text = @"等待确认";
            color = HOUSE_LIST_PRICE_COLOR;
            break;
        case 2:
            text = @"已确认";
            color = HOUSE_LIST_PRICE_COLOR;
            break;
        case 3:
            text = @"订单完成";
            color = APP_MAIN_COLOR;
            break;
        default:
            break;
    }
    label.text = text;
    if (color)
    {
        label.textColor = color;
    }
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
