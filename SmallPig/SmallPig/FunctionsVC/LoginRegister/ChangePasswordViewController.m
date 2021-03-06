//
//  ChangePasswordViewController.m
//  SmallPig
//
//  Created by clei on 15/1/27.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()
@property(nonatomic, strong) NSString *oldPassword;
@property(nonatomic, strong) NSString *password;
@end

@implementation ChangePasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置title
    self.title = @"修改密码";
    //增加back按钮
    [self addBackItem];
    //初始化UI视图
    [self createUI];
    //关闭ScrollView默认偏移量
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //设置不可侧滑
    [self setMainSideCanSwipe:NO];
}

#pragma mark 初始化UI
- (void)createUI
{
    [self addTableView];
    [self addButtons];
}

//添加表
- (void)addTableView
{
    [self addTableViewWithFrame:CGRectMake(15, NAV_HEIGHT + 20, SCREEN_WIDTH - 15 * 2, 132) tableType:UITableViewStylePlain tableDelegate:self];
    self.table .backgroundColor = [UIColor whiteColor];
    self.table.scrollEnabled = NO;
}

//添加完成按钮
- (void)addButtons
{
    //添加完成按钮
    UIButton *commitButton = [CreateViewTool createButtonWithFrame:CGRectMake(self.table.frame.origin.x, self.table.frame.origin.y + self.table.frame.size.height + 25, self.table.frame.size.width, 40) buttonTitle:@"完成" titleColor:WHITE_COLOR normalBackgroundColor:APP_MAIN_COLOR highlightedBackgroundColor:LOGIN_BUTTON_PRESSED_COLOR selectorName:@"commitButtonPressed:" tagDelegate:self];
    [CommonTool clipView:commitButton withCornerRadius:5.0];
    [self.view addSubview:commitButton];
}



#pragma mark 返回按钮事件
//返回按钮事件
- (void)backButtonPressed:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 提交按钮
//提交按钮响应事件
- (void)commitButtonPressed:(UIButton *)sender
{
    [self dismissKeyBoard];
    if ([self isCanCommit])
    {
        [self commitRequest];
    }
}

- (void)dismissKeyBoard
{
    for (int i = 0; i < 3; i++)
    {
        UITableViewCell *cell = [self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        UITextField *textField = (UITextField *)[cell.contentView viewWithTag:i + 1];
        [textField resignFirstResponder];
    }
}


- (BOOL)isCanCommit
{
    NSString *oldPassword = @"";
    NSString *newPassword = @"";
    NSString *surePassword = @"";
   
    for (int i = 0; i < 3; i++)
    {
        UITableViewCell *cell = [self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        UITextField *textField = (UITextField *)[cell.contentView viewWithTag:i + 1];
        NSString *text = (textField.text) ? textField.text : @"";
        if (i == 0)
        {
            oldPassword = text;
        }
        else if (i == 1)
        {
            newPassword = text;
        }
        else if (i == 2)
        {
            surePassword = text;
        }
    }
    NSString *message = @"";
    if (oldPassword.length == 0 || newPassword.length == 0 || surePassword.length == 0)
    {
        message = @"密码不能为空";
    }
    
    else if (newPassword.length < 6 || surePassword.length < 6 || oldPassword.length < 6)
    {
        message = @"密码不能小于6位";
    }
    else if (![newPassword isEqualToString:surePassword])
    {
        message = @"密码不一致";
    }
    
    if ([@"" isEqualToString:message])
    {
        self.oldPassword = oldPassword;
        self.password = newPassword;
        return YES;
    }
    [CommonTool addAlertTipWithMessage:message];
    return NO;
}

- (void)commitRequest
{
    [SVProgressHUD showWithStatus:@"正在保存..."];
    NSDictionary *requestDic = @{@"id":[SmallPigApplication shareInstance].userInfoDic[@"id"],@"password":self.oldPassword,@"newPassword":self.password};
    RequestTool *request = [[RequestTool alloc] init];
    [request requestWithUrl:CHANGE_PWD_URL requestParamas:requestDic requestType:RequestTypeAsynchronous
    requestSucess:^(AFHTTPRequestOperation *operation, id responseDic)
     {
         NSLog(@"changepwd_responseDic===%@",responseDic);
         NSDictionary *dic = (NSDictionary *)responseDic;
         if ([dic[@"responseMessage"][@"success"] intValue] == 1)
         {
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
         }
         else
         {
             [SVProgressHUD showSuccessWithStatus:@"修改失败"];
         }
         
     }
    requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        [SVProgressHUD showSuccessWithStatus:@"修改失败"];
         NSLog(@"error====%@",error);
    }];
}



#pragma mark  tableView委托方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"LoginCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor whiteColor];
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    UILabel *label = [CreateViewTool createLabelWithFrame:CGRectMake(10, 0, 70, cell.frame.size.height)  textString:@"" textColor:LOGIN_LABEL_COLOR textFont:LOGIN_REG_FONT];
    [cell.contentView addSubview:label];
    
    UITextField *textField = [CreateViewTool createTextFieldWithFrame:CGRectMake(85, 0, self.table.frame.size.width - 85 - 10, cell.frame.size.height) textColor:[UIColor blackColor] textFont:LOGIN_REG_FONT placeholderText:@"请输入密码"];
    textField.tag = indexPath.row + 1;
    textField.secureTextEntry = YES;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.keyboardType = UIKeyboardTypeNamePhonePad;
    [cell.contentView addSubview:textField];
    
    if (indexPath.row == 0)
    {
        label.text = @"原始密码:";
    }
    else if (indexPath.row == 1)
    {
         label.text = @"新密码:";
    }
    else
    {
        label.text = @"确认密码:";
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
