//
//  LoginViewController.m
//  SmallPig
//
//  Created by chenlei on 14/11/26.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "LoginViewController.h"
#import "CheckCodeViewController.h"

@interface LoginViewController ()
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;
@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置title
    self.title = LOGIN_TITLE;
    //增加back按钮
    [self addBackItem];
    //初始化UI视图
    [self createUI];
    //关闭ScrollView默认偏移量
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self dismissKeyBoard];
}

#pragma mark 创建UI
//初始化视图
- (void)createUI
{
    [self addTableView];
    [self addButtons];
}

//添加表
- (void)addTableView
{
    //添加表
    [self addTableViewWithFrame:CGRectMake(15,NAV_HEIGHT + 20, SCREEN_WIDTH - 15 * 2, 88) tableType:UITableViewStylePlain tableDelegate:self];
    self.table .backgroundColor = [UIColor whiteColor];
    self.table.scrollEnabled = NO;
}

//添加按钮
- (void)addButtons
{
    //添加登录按钮
    UIButton *loginButton = [CreateViewTool createButtonWithFrame:CGRectMake(self.table.frame.origin.x, self.table.frame.origin.y + self.table.frame.size.height + 25, self.table.frame.size.width, 40) buttonTitle:@"登录" titleColor:WHITE_COLOR normalBackgroundColor:APP_MAIN_COLOR highlightedBackgroundColor:LOGIN_BUTTON_PRESSED_COLOR selectorName:@"loginButtonPressed:" tagDelegate:self];
    [CommonTool clipView:loginButton withCornerRadius:5.0];
    [self.view addSubview:loginButton];
    
    //找回密码 手机注册
    UIButton *registerButton = [CreateViewTool createButtonWithFrame:CGRectMake(loginButton.frame.origin.x, loginButton.frame.origin.y + loginButton.frame.size.height, 80, 30) buttonTitle:@"手机注册" titleColor:REGISTER_TITLE_COLOR normalBackgroundColor:nil highlightedBackgroundColor:nil selectorName:@"registerButtonPressed:" tagDelegate:self];
    registerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    registerButton.titleLabel.font = REGISTER_TITLE_FONT;
    registerButton.showsTouchWhenHighlighted = YES;
    [self.view addSubview:registerButton];
    
    UIButton *findPassWordButton = [CreateViewTool createButtonWithFrame:CGRectMake(loginButton.frame.origin.x + loginButton.frame.size.width - 80, loginButton.frame.origin.y + loginButton.frame.size.height, 80, 30) buttonTitle:@"找回密码" titleColor:REGISTER_TITLE_COLOR normalBackgroundColor:nil highlightedBackgroundColor:nil selectorName:@"findPassWordButtonPressed:" tagDelegate:self];
    findPassWordButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    findPassWordButton.titleLabel.font = REGISTER_TITLE_FONT;
    findPassWordButton.showsTouchWhenHighlighted = YES;
    [self.view addSubview:findPassWordButton];
}

#pragma mark 返回按钮事件
//返回按钮事件
- (void)backButtonPressed:(UIButton *)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:Nil];
}

#pragma mark 登录按钮
//登录按钮事件
- (void)loginButtonPressed:(UIButton *)button
{
    
    for (int i = 0; i < 2; i++)
    {
        UITableViewCell *cell = [self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        UITextField *textField = (UITextField *)[cell.contentView viewWithTag:i + 1];
        NSString *text = (textField.text) ? textField.text : @"";
        if (i == 0)
        {
            self.userName = text;
        }
        else if (i == 1)
        {
            self.password = text;
        }
    }
    
    if ([self isCanCommit])
    {
        [self dismissKeyBoard];
        [self loginRequest];
    }
}


- (void)dismissKeyBoard
{
    for (int i = 0; i < 2; i++)
    {
        UITableViewCell *cell = [self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        UITextField *textField = (UITextField *)[cell.contentView viewWithTag:i + 1];
        [textField resignFirstResponder];
    }
}


- (BOOL)isCanCommit
{
    NSString *message = @"";
    if ([@"" isEqualToString:self.userName])
    {
        message = @"用户名不能为空";
    }
    else if ([@"" isEqualToString:self.password])
    {
        message = @"密码不能为空";
    }
    else if (![CommonTool isEmailOrPhoneNumber:self.userName])
    {
        message = @"请输入正确的手机号";
    }
    else if (self.password.length < 6)
    {
        message = @"密码不能小于6位";
    }
    
    if ([@"" isEqualToString:message])
    {
        return YES;
    }
    
    [CommonTool addAlertTipWithMessage:message];
    return NO;
}


- (void)loginRequest
{
    [SVProgressHUD showErrorWithStatus:@"正在登录..."];
    RequestTool *request = [[RequestTool alloc] init];
    NSString *failureUrl= @"/mobile/login/failure.action";
    NSString *redirextUrl = @"/mobile/login/success.action";
    NSDictionary *requestDic = @{@"username":self.userName,@"password":self.password,@"redirectURL":redirextUrl,@"failureURL":failureUrl};
    [request requestWithUrl:LOGIN_URL requestParamas:requestDic requestType:RequestTypeAsynchronous requestSucess:^(AFHTTPRequestOperation *operation, id responseDic)
    {
        NSLog(@"login_responseDic===%@",responseDic);
        NSLog(@"allHeaderFields===%@",operation.response.allHeaderFields);
        NSDictionary *dic = (NSDictionary *)responseDic;
        if ([dic[@"responseMessage"][@"success"] intValue] == 1)
        {
            [SmallPigApplication shareInstance].userInfoDic = dic[@"member"];
            [self dismissViewControllerAnimated:YES completion:nil];
            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
        }
        else
        {
            NSString *message = dic[@"responseMessage"][@"message"];
            message = (message) ? message : @"登录失败";
            [SVProgressHUD showErrorWithStatus:message];
        }
        [CookiesTool setCookiesWithUrl:LOGIN_URL];
    }
    requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        [SVProgressHUD showErrorWithStatus:@"登录失败"];
        NSLog(@"login_error===%@",error);
    }];
    
    
}


//注册按钮事件
- (void)registerButtonPressed:(UIButton *)button
{
   [self pushRegisterWithType:PushTypeRegister];
}

//找回密码事件
- (void)findPassWordButtonPressed:(UIButton *)button
{
    [self pushRegisterWithType:PushTypeFindPassWord];
}

#pragma mark 注册和找回密码界面跳转
- (void)pushRegisterWithType:(PushType)type
{
    CheckCodeViewController *registerVC = [[CheckCodeViewController alloc]init];
    registerVC.pushType = type;
    [self.navigationController pushViewController:registerVC animated:YES];
}



#pragma mark  tableView委托方法


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
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
    
    UILabel *label = [CreateViewTool createLabelWithFrame:CGRectMake(10, 0, 60, cell.frame.size.height) textString:@"" textColor:LOGIN_LABEL_COLOR textFont:LOGIN_REG_FONT];
    [cell.contentView addSubview:label];
    
    UITextField *textField = [CreateViewTool createTextFieldWithFrame:CGRectMake(70, 0, self.table.frame.size.width - 70 - 10, cell.frame.size.height) textColor:[UIColor blackColor] textFont:LOGIN_REG_FONT placeholderText:@"请输入手机号"];
    textField.returnKeyType = UIReturnKeyDone;
    textField.tag = indexPath.row + 1;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [cell.contentView addSubview:textField];
    
    if (indexPath.row == 0)
    {
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.text = @"15820790320";
        label.text = @"用户名:";
    }
    else
    {
        textField.secureTextEntry = YES;
        textField.keyboardType = UIKeyboardTypeNamePhonePad;
        textField.text = @"12344321";
        textField.placeholder = @"请输入密码";
        label.text = @"密码:";
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
