//
//  AgentFormInfoViewController.m
//  SmallPig
//
//  Created by clei on 15/3/9.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "AgentFormInfoViewController.h"
#import "LeftRightLableCell.h"

#define AGENT_FORM_INFO_HEIGHT   44.0

@interface AgentFormInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) NSArray *headerArray;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSString *houseID;
@property (nonatomic, strong) NSString *houseOwner;
@property (nonatomic, strong) NSString *mobile;
@end

@implementation AgentFormInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"2.提交资料审核";
    //添加item
    [self addBackItem];
    [self setNavBarItemWithTitle:@"提交" navItemType:rightItem selectorName:@"commitButtonPressed:"];
    //初始化数据
    self.headerArray = @[@"房屋资料",@"经纪人资料"];
    self.titleArray = @[@[@"房产证号",@"业主姓名",@"联系电话"],@[@"姓名",@"电话"]];
    NSDictionary *userInfoDic = [[SmallPigApplication shareInstance] userInfoDic];
    NSString *mobile = userInfoDic[@"mobile"];
    mobile = (mobile) ? mobile : @"";
    NSString *name = userInfoDic[@"name"];
    name = (name) ? name : @"";
    self.dataArray = [NSMutableArray arrayWithArray:@[@[@"",@"",@""],@[name,mobile]]];
    //初始化UI
    [self createUI];
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

#pragma mark 提交按钮 
- (void)commitButtonPressed:(UIButton *)sender
{
    if ([self isCanCommit])
    {
        [self publicRoom];
    }
}

- (BOOL)isCanCommit
{
    NSString *message = @"";
    if (!self.houseID)
    {
        message = @"请输入房产证号";
    }
    else if (!self.houseOwner)
    {
        message = @"请输入业主姓名";
    }
    else if (!self.mobile)
    {
        message = @"请输入联系电话";
    }
    if ([message isEqualToString:@""])
    {
        return YES;
    }
    else
    {
        [CommonTool addAlertTipWithMessage:message];
        return NO;
    }
}

#pragma  mark  发布房源

- (void)publicRoom
{
    [SVProgressHUD showWithStatus:@"发布中..."];
    self.peroid = (!self.peroid) ? @"" : self.peroid;
    NSMutableDictionary *rquestDic = [NSMutableDictionary dictionaryWithDictionary:@{@"room.id":self.roomID,@"price":self.price,@"title":self.roomTitle,@"description":self.roomDescription,@"certificateNo":self.houseID,@"certificatePrice":self.certificatePrice,@"contact":self.houseOwner,@"mobile":self.mobile,@"phone":self.mobile,@"roomType":self.roomType,@"roomLabel":self.roomLabel,@"roomFeature":self.roomFeature,@"peroid":self.peroid}];
    NSString *url = PUBLIC_ROOM_URL;
    url = [url stringByAppendingString:@"?"];
    NSArray *array = [self.photoList componentsSeparatedByString:@","];
    for (NSString *string in array)
    {
        if (![@"" isEqualToString:string])
        {
            if ([url rangeOfString:@"photoList.id"].length == 0)
            {
                url = [NSString stringWithFormat:@"%@photoList.id=%@",url,string];
            }
            else
            {
                url = [NSString stringWithFormat:@"%@&photoList.id=%@",url,string];
            }

        }
    }
    NSLog(@"rquestDic====%@====%@",rquestDic,url);
    RequestTool *request = [[RequestTool alloc] init];
    [request requestWithUrl:url requestParamas:rquestDic requestType:RequestTypeAsynchronous requestSucess:
    ^(AFHTTPRequestOperation *operation, id responseDic)
    {
        NSLog(@"responseDic===%@",operation.responseString);
        NSDictionary *dic = (NSDictionary *)responseDic;
        int sucess = [dic[@"responseMessage"][@"success"] intValue];
        if (sucess == 1)
        {
            [SVProgressHUD showSuccessWithStatus:@"发布成功"];
            [CommonTool addAlertTipWithMessage:@"发布成功"];
            [self.navigationController popToViewController:self.navigationController.viewControllers[2] animated:YES];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"发布失败"];
            [CommonTool addAlertTipWithMessage:@"发布失败"];
        }
    }
    requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        [SVProgressHUD showErrorWithStatus:@"发布失败"];
        [CommonTool addAlertTipWithMessage:@"发布失败"];
    }];
    
}


#pragma mark tableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.headerArray[section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int number = (section == 0) ? 3 : 2;
    return number;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return AGENT_FORM_INFO_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    LeftRightLableCell *cell = (LeftRightLableCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[LeftRightLableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    [cell setLeftColor:[UIColor blackColor] rightColor:HOUSE_DETAIL_TITLE_COLOR];
    [cell setDataWithLeftText:self.titleArray[indexPath.section][indexPath.row] rightText:self.dataArray[indexPath.section][indexPath.row]];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0)
    {
        [self addAlertViewWithIndex:(int)indexPath.row];
    }
    
}

#pragma mark 弹出输入框
- (void)addAlertViewWithIndex:(int)index
{
    NSArray *array = @[@"房产证号",@"业主姓名",@"联系电话"];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:array[index] message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textField = (UITextField *)[alertView textFieldAtIndex:0];
    if (index == 0 || index == 2)
    {
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    alertView.tag = 100 + index;
    [alertView show];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if ([@"确定" isEqualToString:title])
    {
        int index = (int)alertView.tag - 100;
        UITextField *textField = (UITextField *)[alertView textFieldAtIndex:0];
        NSString *text = textField.text;
        text = (text) ? text : @"";
        NSString *message = @"";
        if (index == 0)
        {
            if (text.length > 20 || text.length == 0)
            {
                message = @"请输入正确的房产证号";
            }
        }
        else if (index == 1)
        {
            if (text.length == 0)
            {
                message = @"请输入业主姓名";
            }
        }
        else if (index == 2)
        {
            if (![CommonTool isEmailOrPhoneNumber:text])
            {
                message = @"请输入正确的手机号";
            }
        }
        
        if ([message isEqualToString:@""])
        {
            [self setDataArrayWithObject:text atIndex:index];
        }
        else
        {
            [CommonTool addAlertTipWithMessage:message];
        }
    }
}

- (void)setDataArrayWithObject:(NSString *)object atIndex:(int)index
{   
    if (index == 0)
    {
        self.houseID = object;
    }
    if (index == 1)
    {
        self.houseOwner = object;
    }
    if (index == 2)
    {
        self.mobile = object;
    }
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.dataArray[0]];
    [array replaceObjectAtIndex:index withObject:object];
    [self.dataArray replaceObjectAtIndex:0 withObject:array];
    [self.table reloadData];
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
