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
@property (nonatomic, strong) NSArray *totleArray;
@end

@implementation AgentHouseListViewController

- (void)viewDidLoad
{
    self.houseSource = HouseScourceFromSecondHand;
    [super viewDidLoad];
    [self setTitleViewWithArray:@[@"售房",@"租房"]];
    self.navigationItem.rightBarButtonItems = nil;
    [self setNavBarItemWithTitle:@"发布" navItemType:rightItem selectorName:@"publicHouseButtonPressed:"];
    [self getHouseList];
    // Do any additional setup after loading the view.
}

#pragma  mark 选项卡按钮事件
- (void)buttonPressed:(UIButton *)sender
{
    [super buttonPressed:sender];
    self.houseSource = (sender.tag == 1) ? HouseScourceFromSecondHand : HouseScourceFromRental;
    [self.table reloadData];
}

#pragma mark 重构基类方法
//不取房屋数据
- (void)getData
{
    
}

#pragma mark 发布房源
- (void)publicHouseButtonPressed:(UIButton *)sender
{
    [self pushHouseInfoViewWithType:HouseInfoTypePublic];
}


#pragma mark 获取房屋列表
- (void)getHouseList
{
    [SVProgressHUD showWithStatus:LOADING_DEFAULT];
    __weak typeof(self) weakSelf = self;
    NSDictionary *requestDic = @{};
    RequestTool *request = [[RequestTool alloc] init];
    [request requestWithUrl:PUBLIC_ROOM_LIST_URL requestParamas:requestDic requestType:RequestTypeAsynchronous requestSucess:^(AFHTTPRequestOperation *operation, id reponseDic)
     {
         NSLog(@"operation===%@",reponseDic);
         [SVProgressHUD showSuccessWithStatus:LOADING_SUCESS];
         int sucess = [reponseDic[@"responseMessage"][@"success"] intValue];
         if (sucess == 1)
         {
             NSDictionary *dic = (NSDictionary *)reponseDic;
             weakSelf.totleArray = dic[@"pageBean"][@"data"];
             [weakSelf makeDataArray];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:reponseDic[@"responseMessage"][@"message"]];
         }
     }
    requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [SVProgressHUD showErrorWithStatus:LOADING_FAILURE];
     }];
 
}

#pragma mark 获取数据
- (void)makeDataArray
{
    if (self.dataArray)
    {
        self.dataArray = nil;
    }
    self.dataArray = [NSMutableArray array];
    for (NSDictionary *dic in self.totleArray)
    {
        int roomType = [dic[@"roomType"] intValue];
        if (self.houseSource == HouseScourceFromSecondHand)
        {
            if (roomType == 2)
            {
                [self.dataArray addObject:dic];
            }
        }
        else if (self.houseSource == HouseScourceFromRental)
        {
            if (roomType == 1)
            {
                [self.dataArray addObject:dic];
            }
        }
    }
    [self.table reloadData];
}

#pragma mark 点击行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView  deselectRowAtIndexPath:indexPath animated:YES];
    [self pushHouseInfoViewWithType:HouseInfoTypeDetail];
}


- (void)pushHouseInfoViewWithType:(HouseInfoType)type
{
    AgentHouseInfoViewController  *houseInfoViewController = [[AgentHouseInfoViewController alloc] init];
    houseInfoViewController.houseInfoType = type;
    [self.navigationController pushViewController:houseInfoViewController animated:YES];
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
