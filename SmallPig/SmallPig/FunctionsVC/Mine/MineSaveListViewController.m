//
//  MineSaveListViewController.m
//  SmallPig
//
//  Created by clei on 14/12/10.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "MineSaveListViewController.h"

@interface MineSaveListViewController ()

@end

@implementation MineSaveListViewController

- (void)viewDidLoad
{
    self.houseSource = HouseScourceFromSave;
    [super viewDidLoad];
    //设置title
    self.title = MINE_SAVE_TITLE;
    //设置item为nil
    //添加侧滑item
    [self addPersonItem];
    self.navigationItem.rightBarButtonItem = nil;
    //设置titleView
    //[self setTitleViewWithArray:@[@"售房",@"租房"]];
    // Do any additional setup after loading the view.
}


//#pragma  mark 选项卡按钮事件
//- (void)buttonPressed:(UIButton *)sender
//{
//    [super buttonPressed:sender];
//    self.houseSource = (sender.tag == 1) ? HouseScourceFromSecondHand : HouseScourceFromRental;
//    [self.table reloadData];
//}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self setMainSideCanSwipe:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [self setMainSideCanSwipe:YES];
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
    [self deleteSaveWithID:rowDic[@"id"]];
}

#pragma mark 删除备忘
- (void)deleteSaveWithID:(NSString *)memoID
{
    //PUBLIC_HOUSE_DELETE
    typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"正在删除..."];
    RequestTool *request = [[RequestTool alloc] init];
    NSDictionary *requestDic = @{@"ids":memoID};
    [request requestWithUrl:DELETE_SAVE_URL requestParamas:requestDic requestType:RequestTypeAsynchronous requestSucess:^(AFHTTPRequestOperation *operation, id responseDic)
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
