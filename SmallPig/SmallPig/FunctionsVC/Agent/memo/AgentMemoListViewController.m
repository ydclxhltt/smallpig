//
//  AgentMemoListViewController.m
//  SmallPig
//
//  Created by clei on 15/1/30.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "AgentMemoListViewController.h"
#import "LeftRightLableCell.h"
#import "AgentRemindViewController.h"

#define PAGE_COUNT 10.0

@interface AgentMemoListViewController ()
@end

@implementation AgentMemoListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //title
    self.title = @"备忘录";
    //初始化数据
    currentPage = 1;
    //初始化UI
    [self addBackItem];
    [self setNavBarItemWithTitle:@"新建" navItemType:rightItem selectorName:@"addNewRemind"];
    [self createUI];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setMainSideCanSwipe:NO];
    //获取数据
    [self getData];
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


#pragma  mark 获取数据
- (void)getData
{
    __weak typeof(self) weakSelf = self;
    if (currentPage == 1)
    {
        [SVProgressHUD showWithStatus:LOADING_DEFAULT];
    }
    NSDictionary *requestDic = @{@"queryBean.pageSize":@(PAGE_COUNT),@"queryBean.pageNo":@(currentPage),@"queryBean.params.status_int":@(0),@"queryBean.orderBy":@"",@"queryBean.order":@""};
    RequestTool *request = [[RequestTool alloc] init];
    [request requestWithUrl:MEMO_LIST_URL requestParamas:requestDic requestType:RequestTypeAsynchronous
    requestSucess:^(AFHTTPRequestOperation *operation, id responseDic)
    {
        NSLog(@"memoResponseDic===%@",responseDic);
        NSDictionary *dic = (NSDictionary *)responseDic;
        weakSelf.dataArray = dic[@"pageBean"][@"data"];
        if (!weakSelf.dataArray || [weakSelf.dataArray count] == 0)
        {
            [SVProgressHUD showSuccessWithStatus:LOADING_SUCESS duration:.1];
            [CommonTool addAlertTipWithMessage:@"暂无数据"];
        }
        else
        {
            NSLog(@"memoRequestHeader===%@",operation.request.allHTTPHeaderFields);
            [SVProgressHUD showSuccessWithStatus:LOADING_SUCESS];
            [weakSelf.table reloadData];
        }
        
    }
    requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"error=====%@",error);
         NSLog(@"memoRequestHeader===%@",operation.request.allHTTPHeaderFields);
        [SVProgressHUD showErrorWithStatus:LOADING_FAILURE];
    }];
}

#pragma mark 新建备忘
- (void)addNewRemind
{
    AgentRemindViewController *remindViewController = [[AgentRemindViewController alloc] init];
    remindViewController.type = 1;
    [self.navigationController pushViewController:remindViewController animated:YES];
}

#pragma mark tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}


- (UITableViewCell *)tableView:tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    LeftRightLableCell *cell = (LeftRightLableCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[LeftRightLableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSDictionary *rowDic = self.dataArray[indexPath.row];
    if (rowDic)
    {
        NSString *time = rowDic[@"createDate"];
        time = [SmallPigTool formatTimeWithString:time];
        [cell setDataWithLeftText:rowDic[@"content"] rightText:time];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *rowDic = self.dataArray[indexPath.row];
    AgentRemindViewController *remindViewController = [[AgentRemindViewController alloc] init];
    remindViewController.type = 2;
    remindViewController.ID = rowDic[@"id"];
    [self.navigationController pushViewController:remindViewController animated:YES];
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *rowDic = self.dataArray[indexPath.row];
    [self deleteMemoWithID:rowDic[@"id"]];
}

#pragma mark 删除备忘
- (void)deleteMemoWithID:(NSString *)memoID
{
    //PUBLIC_HOUSE_DELETE
    typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"正在删除..."];
    RequestTool *request = [[RequestTool alloc] init];
    NSDictionary *requestDic = @{@"ids":memoID};
    [request requestWithUrl:MEMO_DELETE_URL requestParamas:requestDic requestType:RequestTypeAsynchronous requestSucess:^(AFHTTPRequestOperation *operation, id responseDic)
     {
         NSLog(@"PUBLIC_HOUSE_DELETE_responseDic===%@",responseDic);
         NSDictionary *dic = (NSDictionary *)responseDic;
         if ([dic[@"responseMessage"][@"success"] intValue] == 1)
         {
             [SVProgressHUD showSuccessWithStatus:@"删除成功"];
             currentPage = 1;
             weakSelf.dataArray = nil;
             [weakSelf getData];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:@"删除失败"];
         }
     }
     requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [SVProgressHUD showErrorWithStatus:@"删除失败"];
         NSLog(@"login_error===%@",error);
     }];
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
