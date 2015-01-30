//
//  AgentMemoListViewController.m
//  SmallPig
//
//  Created by clei on 15/1/30.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "AgentMemoListViewController.h"
#import "LeftRightLableCell.h"

#define PAGE_COUNT 10.0

@interface AgentMemoListViewController ()
{
    int currentPage;
}
@end

@implementation AgentMemoListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //title
    self.title = @"备忘录";
    //初始化数据
    currentPage = 1;
    self.dataArray = (NSMutableArray *)@[@{@"title":@"XXXX20分钟后看房",@"createDate":@"2015-01-30",@"id":@"1"},@{@"title":@"XXXX20分钟后看房",@"createDate":@"2015-01-30",@"id":@"1"},@{@"title":@"XXXX20分钟后看房",@"createDate":@"2015-01-30",@"id":@"1"},@{@"title":@"XXXX20分钟后看房",@"createDate":@"2015-01-30",@"id":@"1"},@{@"title":@"XXXX20分钟后看房",@"createDate":@"2015-01-30",@"id":@"1"},@{@"title":@"XXXX20分钟后看房",@"createDate":@"2015-01-30",@"id":@"1"},@{@"title":@"XXXX20分钟后看房",@"createDate":@"2015-01-30",@"id":@"1"}];
    //初始化UI
    [self addBackItem];
    [self createUI];
    //获取数据
    [self getData];
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
        NSLog(@"memoRequestHeader===%@",operation.request.allHTTPHeaderFields);
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
        [cell setDataWithLeftText:rowDic[@"title"] rightText:rowDic[@"createDate"]];
    }
    
    return cell;
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