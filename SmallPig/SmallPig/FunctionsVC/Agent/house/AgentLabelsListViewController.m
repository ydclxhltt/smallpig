//
//  AgentLabelsListViewController.m
//  SmallPig
//
//  Created by clei on 15/3/10.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "AgentLabelsListViewController.h"

@interface AgentLabelsListViewController()<UITableViewDataSource,UITableViewDelegate>
{
    int selectedIndex;
}

@end

@implementation AgentLabelsListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置title
    self.title = self.titleStr;
    //添加item
    [self addBackItem];
    [self setNavBarItemWithTitle:@"完成" navItemType:rightItem selectorName:@"sureButtonPressed:"];
    //初始化数据
    selectedIndex = -1;
    //初始化UI
    [self createUI];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self getListData];
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


#pragma mark 获取列表
- (void)getListData
{
    [SVProgressHUD showWithStatus:LOADING_DEFAULT];
    __weak typeof(self) weakSelf = self;
    NSDictionary *requestDic = @{@"paramCategory":self.paramStr};
    RequestTool *request = [[RequestTool alloc] init];
    [request requestWithUrl:SORT_LIST_URL requestParamas:requestDic requestType:RequestTypeAsynchronous requestSucess:^(AFHTTPRequestOperation *operation, id reponseDic)
    {
        NSLog(@"operation===%@",reponseDic);
        [SVProgressHUD showSuccessWithStatus:LOADING_SUCESS];
        int sucess = [reponseDic[@"responseMessage"][@"success"] intValue];
        if (sucess == 1)
        {
            weakSelf.dataArray = reponseDic[@"model"][@"paramList"];
            if (weakSelf.dataArray && [weakSelf.dataArray count] > 0)
            {
                [weakSelf.table reloadData];
            }
            else
            {
                [CommonTool addAlertTipWithMessage:@"暂无数据"];
            }
        }
    }
    requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        [SVProgressHUD showErrorWithStatus:LOADING_FAILURE];
    }];
}


#pragma mark 返回按钮
- (void)backButtonPressed:(UIButton *)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:Nil];
}

#pragma mark 完成按钮
- (void)sureButtonPressed:(UIButton *)sender
{
    if (selectedIndex == -1)
    {
        [CommonTool addAlertTipWithMessage:[NSString stringWithFormat:@"请选择%@",self.title]];
        return;
    }
    if (self.isRoomList)
    {
        [self isRoomCanSelected];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectedLabel" object:self.dataArray[selectedIndex]];
        [self dismissViewControllerAnimated:YES completion:Nil];
    }
}

#pragma mark 验证房源
- (void)isRoomCanSelected
{
    [SVProgressHUD showWithStatus:@"正在验证..."];
    NSDictionary *requestDic = @{@"room.id":self.dataArray[selectedIndex][@"paramCode"]};
    RequestTool *request = [[RequestTool alloc] init];
    [request requestWithUrl:IS_CAN_PUBLIC_URL requestParamas:requestDic requestType:RequestTypeAsynchronous requestSucess:^(AFHTTPRequestOperation *operation, id reponseDic)
     {
         NSLog(@"operation===%@",reponseDic);
         [SVProgressHUD showSuccessWithStatus:LOADING_SUCESS];
         int sucess = [reponseDic[@"responseMessage"][@"success"] intValue];
         if (sucess == 1)
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectedLabel" object:reponseDic];
             [self dismissViewControllerAnimated:YES completion:Nil];
         }
         else
         {
            [SVProgressHUD showErrorWithStatus:reponseDic[@"responseMessage"][@"message"]];
         }
     }
     requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [SVProgressHUD showErrorWithStatus:@"验证失败"];
     }];
}


#pragma mark tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"CellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    if (indexPath.row == selectedIndex)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = self.dataArray[indexPath.row][@"showName"];
    cell.textLabel.font = FONT(16.0);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIndex = (int)indexPath.row;
    [self.table reloadData];
}

@end
