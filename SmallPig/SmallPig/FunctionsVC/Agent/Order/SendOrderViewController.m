//
//  SendOrderViewController.m
//  SmallPig
//
//  Created by clei on 15/3/11.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "SendOrderViewController.h"
#import "FindUserViewController.h"
#import "LeftRightLableCell.h"
#import "SavePublicCell.h"
#import "AgentHouseListViewController.h"
#import "ServiceListViewController.h"

@interface SendOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *serviceName;
@property (nonatomic, strong) NSString *serviceID;
@property (nonatomic, strong) NSDictionary *houseDic;
@property (nonatomic, strong) NSString *roomID;
@end

@implementation SendOrderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置title
    self.title = @"创建订单";
    //添加item
    [self addBackItem];
    [self setNavBarItemWithTitle:@"发送" navItemType:rightItem selectorName:@"sendButtonPressed:"];
    //初始化UI
    [self createUI];
    self.dataArray = (NSMutableArray *)@[@[@" 客户",@" 房源详情"],@[@" 跟单人"]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(findUser:) name:@"FindUser" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(houseDetail:) name:@"HouseDetail" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(findService:) name:@"FindService" object:nil];
    
    
    // Do any additional setup after loading the view.
}

#pragma mark 初始化UI
- (void)createUI
{
    [self addTableView];
}

- (void)addTableView
{
    [self addTableViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) tableType:UITableViewStyleGrouped tableDelegate:self];
}

#pragma mark 发送
- (void)sendButtonPressed:(UIButton *)sender
{
    if (self.userName && self.houseDic && self.serviceName)
    {
        [self sendOrder];
    }
    else
    {
        [CommonTool addAlertTipWithMessage:@"订单数据不完整"];
    }
}


- (void)sendOrder
{
     [SVProgressHUD showWithStatus:@"发送中..."];
    NSString *price = [NSString stringWithFormat:@"%.0f",[self.houseDic[@"price"] floatValue]];
    NSDictionary *rquestDic = @{@"publishRoom.id":self.roomID,@"buyer.id":self.userID,@"buyerName":self.userName,@"buyerNid":@"",@"servicer.id":self.serviceID,@"price":price,@"bookPrice":@"100"};
    RequestTool *request = [[RequestTool alloc] init];
    [request requestWithUrl:SEND_ORDER_URL requestParamas:rquestDic requestType:RequestTypeAsynchronous requestSucess:
     ^(AFHTTPRequestOperation *operation, id responseDic)
     {
         NSLog(@"responseDic===%@",operation.responseString);
         NSDictionary *dic = (NSDictionary *)responseDic;
         int sucess = [dic[@"responseMessage"][@"success"] intValue];
         if (sucess == 1)
         {
             [SVProgressHUD showSuccessWithStatus:@"发送成功"];
             [CommonTool addAlertTipWithMessage:@"发送成功"];
             [self.navigationController popToViewController:self.navigationController.viewControllers[2] animated:YES];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:@"发送失败"];
             [CommonTool addAlertTipWithMessage:[@"发送失败 " stringByAppendingString:dic[@"responseMessage"][@"message"]]];
         }
     }
                requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [SVProgressHUD showErrorWithStatus:@"发送失败"];
         [CommonTool addAlertTipWithMessage:@"发送失败"];
     }];
}

#pragma mark 查找用户
- (void)findUser:(NSNotification *)notification
{
    NSDictionary *dic = (NSDictionary *)notification.object;
    self.userID = (dic[@"id"]) ? dic[@"id"] : @"";
    self.userName = (dic[@"name"]) ? dic[@"name"] : @"";
    [self.table reloadData];
}


#pragma mark 选择房源
- (void)houseDetail:(NSNotification *)notification
{
    self.houseDic = (NSDictionary *)notification.object;
    if (self.houseDic)
    {
        NSString *roomID = self.houseDic[@"room"][@"id"];
        roomID = (roomID) ? roomID : @"";
        self.roomID = roomID;
        int roomType = [self.houseDic[@"roomType"] intValue];
        if (roomType == 3)
        {
            self.time = [NSString  stringWithFormat:@"%d",[self.houseDic[@"period"] intValue]];
            self.time = (self.time) ? [self.time stringByAppendingString:@"个月"] : @"";
            self.dataArray = (NSMutableArray *)@[@[@" 客户",@" 房源详情",@" 租期"],@[@" 跟单人"]];
        }
        else
        {
            self.dataArray = (NSMutableArray *)@[@[@" 客户",@" 房源详情"],@[@" 跟单人"]];
        }
    }
    [self.table reloadData];
}

#pragma mark 选择客服
- (void)findService:(NSNotification *)notification
{
    NSDictionary *dic = (NSDictionary *)notification.object;
    self.serviceID = (dic[@"id"]) ? dic[@"id"] : @"";
    self.serviceName = (dic[@"name"]) ? dic[@"name"] : @"";
    [self.table reloadData];
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
    if (self.houseDic && indexPath.row == 1 && indexPath.section ==0)
    {
        return SAVE_LIST_HEIGHT;
    }
    return 44.0;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *leftRightCellID = @"LeftRightCellID";
    static NSString *houseCellID = @"HouseCellID";
    UITableViewCell *cell;
    if (indexPath.section == 0 && indexPath.row == 1 && self.houseDic)
    {
        cell = (SavePublicCell *)[tableView dequeueReusableCellWithIdentifier:houseCellID];
        if (!cell)
        {
            cell = [[SavePublicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:houseCellID];
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        if (self.houseDic)
        {
            NSDictionary *rowDic = self.houseDic;
            NSString *title = rowDic[@"title"];
            title = (title) ? title : @"";
            NSString *imageUrl = [SmallPigTool makePhotoUrlWithPhotoUrl:rowDic[@"coverPhoto"][@"photoUrl"] photoSize:@"240x180" photoType:rowDic[@"coverPhoto"][@"photoType"]];
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
            float price = (roomType == 3 ) ? [rowDic[@"price"] floatValue] : [rowDic[@"price"] floatValue]/10000.0;
            NSString *roomPrice = (roomType == 3) ? [NSString stringWithFormat:@"%.0f元",price] : [NSString stringWithFormat:@"%.0f万",price];
            [(SavePublicCell *)cell setCellImageWithUrl:imageUrl titleText:title localText:local parkText:park priceText:roomPrice typeText:roomStyle sizeText:square];
        }

    }
    else
    {
        cell = (LeftRightLableCell *)[tableView dequeueReusableCellWithIdentifier:leftRightCellID];
        if (!cell)
        {
            cell = [[LeftRightLableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:leftRightCellID];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        [(LeftRightLableCell *)cell setLeftColor:[UIColor blackColor] rightColor:HOUSE_DETAIL_TITLE_COLOR];
        NSString *rightStr = @"";
        if (indexPath.section == 0)
        {
            if (indexPath.row == 0)
            {
                rightStr = (self.userName) ? self.userName : @"";
            }
            if (indexPath.row == 2)
            {
                rightStr = (self.time) ? self.time : @"";
            }
        }
        if (indexPath.section == 1)
        {
            if (indexPath.row == 0)
            {
                rightStr = (self.serviceName) ? self.serviceName : @"";
            }
        }
        [(LeftRightLableCell *)cell setDataWithLeftText:self.dataArray[indexPath.section][indexPath.row] rightText:rightStr];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            FindUserViewController *findUserViewController = [[FindUserViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:findUserViewController];
            [self presentViewController:nav animated:YES completion:Nil];
        }
        if (indexPath.row == 1)
        {
            if (!self.userName)
            {
               [CommonTool addAlertTipWithMessage:@"请选择客户"];
                return;
            }
            AgentHouseListViewController *houseListViewController = [[AgentHouseListViewController alloc] init];
            houseListViewController.isOnlyList = YES;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:houseListViewController];
            [self presentViewController:nav animated:YES completion:Nil];
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            if (![self isCanNext])
            {
                return;
            }
            ServiceListViewController *serviceListViewController = [[ServiceListViewController alloc] init];
            serviceListViewController.roomID = self.roomID;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:serviceListViewController];
            [self presentViewController:nav animated:YES completion:Nil];
        }
    }
}

- (BOOL)isCanNext
{
    BOOL isNext = NO;
    NSString *message = @"";
    if (!self.userName)
    {
       message = @"请选择客户";
    }
    else if (!self.houseDic)
    {
        message = @"请选择房源";
    }
    if (message.length == 0)
    {
        isNext = YES;
    }
    else
    {
        isNext = NO;
        [CommonTool addAlertTipWithMessage:message];
    }
    return isNext;
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
