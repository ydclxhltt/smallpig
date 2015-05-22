//
//  AgentRankListViewController.m
//  SmallPig
//
//  Created by clei on 14/12/9.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "AgentRankListViewController.h"
#import "AgentRankListCell.h"
#import "AgentDetailViewController.h"
#import "AgentLabelsListViewController.h"

@interface AgentRankListViewController ()
@property (nonatomic, strong) NSString *cityCode;
@end

@implementation AgentRankListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置title
    self.title = (self.agentType == AgentTypeList) ? AGENT_LIST_TITLE : @"积分排行";
    //添加班会item
    [self addBackItem];
    [self setNavBarItemWithTitle:@"深圳" navItemType:rightItem selectorName:@"showCityList"];
    //初始化视图
    [self createUI];
    //初始化数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedCity:) name:@"SelectedLabel" object:nil];
    self.cityCode = [[SmallPigApplication shareInstance] cityID];
    currentPage = 1;
    //获取数据
    [self getAgentListData];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //设置不可侧滑
    [self setMainSideCanSwipe:NO];
}


#pragma mark 创建UI
- (void)createUI
{
    [self addTableViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) tableType:UITableViewStylePlain tableDelegate:self];
}


#pragma mark 城市列表
- (void)showCityList
{
    
    AgentLabelsListViewController *cityListController = [[AgentLabelsListViewController alloc] init];
    cityListController.title = @"选择城市";
    cityListController.isRoomList = NO;
    cityListController.paramStr = @"AREA>COMMUNITY>BUILDING>ROOM";
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:cityListController];
    [self presentViewController:nav animated:YES completion:Nil];
}

#pragma mark 切换城市
- (void)selectedCity:(NSNotification *)notification
{
    NSDictionary *dic = (NSDictionary *)notification.object;
    NSString *cityCode = dic[@"areaCode"];
    cityCode = (cityCode) ? cityCode : @"sz";
    self.cityCode = cityCode;
    
    NSString *name = dic[@"showName"];
    name = (name) ? name : @"";
    
    [self setNavBarItemWithTitle:name navItemType:rightItem selectorName:@"showCityList"];
    currentPage = 1;
    self.dataArray = nil;
    [self getAgentListData];
}

#pragma mark 获取经纪人列表
- (void)getAgentListData
{
    [SVProgressHUD showWithStatus:LOADING_DEFAULT];
    NSString *url = (self.agentType == AgentTypeList) ? AGENT_LIST_URL : AGENT_LISTC_URL;
    __weak typeof(self) weakSelf = self;
    NSDictionary *requestDic = @{@"queryBean.pageSize":@(10),@"queryBean.pageNo":@(currentPage),@"queryBean.params.city":weakSelf.cityCode};
    RequestTool *request = [[RequestTool alloc] init];
    [request requestWithUrl:url requestParamas:requestDic requestType:RequestTypeAsynchronous
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
    [self getAgentListData];
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


#pragma mark - tableView代理

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return AGENT_LIST_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *homeCellID = @"agentRankCellID";
    AgentRankListCell *cell = (AgentRankListCell *)[tableView dequeueReusableCellWithIdentifier:homeCellID];
    if (cell == nil)
    {
        cell = [[AgentRankListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:homeCellID];
        cell.backgroundColor = WHITE_COLOR;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSDictionary *dic = self.dataArray[indexPath.row];
    NSString *name = dic[@"bankAcctName"];
    name = (name) ? name : @"";
    NSString *point = [NSString stringWithFormat:@"%@",dic[@"point"]];
    NSString *imageUrl = [SmallPigTool makePhotoUrlWithPhotoUrl:dic[@"avatarPhoto"][@"photoUrl"] photoSize:AGENT_LIST_ICON_SIZE photoType:dic[@"avatarPhoto"][@"photoType"]];
    if (self.agentType == AgentTypeList)
    {
        [cell setCellDataWithRank:(int)indexPath.row + 1 agentImageUrl:imageUrl agentName:name agentScore:@""];
    }
    else
    {
        NSString *name = dic[@"nid"];
        name = (name) ? name : @"";
        [cell setCellDataWithRank:(int)indexPath.row + 1 agentImageUrl:imageUrl agentName:name agentScore:point];
    }
    //[cell setCellDataWithRank:(int)indexPath.row + 1 agentImageUrl:imageUrl agentName:name agentScore:point];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.agentType == AgentTypeRank)
    {
        return;
    }
    NSDictionary *dic = self.dataArray[indexPath.row];
    NSString *name = dic[@"bankAcctName"];
    name = (name) ? name : @"";
    NSString *point = [NSString stringWithFormat:@"%.0f",[dic[@"point"] floatValue]];
    NSString *mobile = dic[@"mobile"];
    mobile = (mobile) ? mobile : @"";
    NSString *agentID = dic[@"id"];
    agentID = (agentID) ? agentID : @"";
    NSString *imageUrl = [SmallPigTool makePhotoUrlWithPhotoUrl:dic[@"avatarPhoto"][@"photoUrl"] photoSize:AGENT_LIST_ICON_SIZE photoType:dic[@"avatarPhoto"][@"photoType"]];
    AgentDetailViewController *agentDetailViewController = [[AgentDetailViewController alloc] init];        agentDetailViewController.name = name;
    agentDetailViewController.score = point;
    agentDetailViewController.mobile = mobile;
    agentDetailViewController.agentID = agentID;
    agentDetailViewController.imageUrl = imageUrl;
    [self.navigationController pushViewController:agentDetailViewController animated:YES];
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
