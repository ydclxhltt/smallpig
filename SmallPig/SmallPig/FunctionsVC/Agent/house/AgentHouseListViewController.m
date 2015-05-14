//
//  AgentHouseListViewController.m
//  SmallPig
//
//  Created by clei on 15/1/30.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "AgentHouseListViewController.h"
#import "AgentHouseInfoViewController.h"

@interface AgentHouseListViewController ()
{
    int selectedIndex;
}
//@property (nonatomic, strong) NSArray *totleArray;
@property (nonatomic, strong) NSArray *parmaArray;
@end

@implementation AgentHouseListViewController

- (void)viewDidLoad
{
    self.houseSource = HouseScourceFromPublic;
    self.parmaArray = @[@"queryBean.params.checkStatus=1",@"queryBean.params.in_checkStatus=0&queryBean.params.in_checkStatus=2",@"queryBean.params.status_int=-1"];
    self.searchParma = self.parmaArray[0];
    
    if (self.isOnlyList)
    {
        self.searchParma = @"";
    }
    
    selectedIndex = 1;
    
    [super viewDidLoad];
    
    [self setTitleViewWithArray:@[@"显示中",@"审核中",@"已关闭"]];
    self.navigationItem.rightBarButtonItems = nil;
    if (self.isOnlyList)
    {
        self.title = @"房源列表";
    }
    else
    {
        [self setNavBarItemWithTitle:@"发布" navItemType:rightItem selectorName:@"publicHouseButtonPressed:"];
    }
    
    
    // Do any additional setup after loading the view.
}


- (void)backButtonPressed:(UIButton *)sender
{
    if (self.isOnlyList)
    {
        [self dismissViewControllerAnimated:YES completion:Nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma  mark 选项卡按钮事件
- (void)buttonPressed:(UIButton *)sender
{
    [super buttonPressed:sender];
    if ([self.searchParma isEqualToString:self.parmaArray[sender.tag - 1]])
    {
        return;
    }
    selectedIndex = (int)sender.tag;
    currentPage = 1;
    self.searchParma = self.parmaArray[sender.tag - 1];
    self.dataArray = nil;
    [self getData];
}


#pragma mark 发布房源
- (void)publicHouseButtonPressed:(UIButton *)sender
{
    [self pushHouseInfoViewWithType:HouseInfoTypePublic];
}


#pragma mark 点击行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView  deselectRowAtIndexPath:indexPath animated:YES];
    if (self.isOnlyList)
    {
        //发起订单选择房屋列表界面时
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HouseDetail" object:self.dataArray[indexPath.row]];
        [self dismissViewControllerAnimated:YES completion:Nil];
    }
    else
    {
        //[self pushHouseInfoViewWithType:HouseInfoTypeDetail];
    }
    
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectedIndex == 1 || selectedIndex == 2)
    {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"关闭";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        //关闭房源
        NSDictionary *rowDic = self.dataArray[indexPath.row];
        //关闭房源请求
        [self closePublicHouseWithID:rowDic[@"id"]];
    }
}

#pragma mark 点击行
- (void)pushHouseInfoViewWithType:(HouseInfoType)type
{
    AgentHouseInfoViewController  *houseInfoViewController = [[AgentHouseInfoViewController alloc] init];
    houseInfoViewController.houseInfoType = type;
    [self.navigationController pushViewController:houseInfoViewController animated:YES];
}


#pragma mark 关闭房源
- (void)closePublicHouseWithID:(NSString *)houseID
{
    //PUBLIC_HOUSE_DELETE
    typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"正在关闭..."];
    RequestTool *request = [[RequestTool alloc] init];
    NSDictionary *requestDic = @{@"id":houseID};
    [request requestWithUrl:PUBLIC_HOUSE_DELETE requestParamas:requestDic requestType:RequestTypeAsynchronous requestSucess:^(AFHTTPRequestOperation *operation, id responseDic)
     {
         NSLog(@"PUBLIC_HOUSE_DELETE_responseDic===%@",responseDic);
         NSDictionary *dic = (NSDictionary *)responseDic;
         if ([dic[@"responseMessage"][@"success"] intValue] == 1)
         {
             [SVProgressHUD showSuccessWithStatus:@"关闭成功"];
             currentPage = 1;
             weakSelf.dataArray = nil;
             [weakSelf getData];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:@"关闭失败"];
         }
     }
    requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [SVProgressHUD showErrorWithStatus:@"关闭失败"];
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
