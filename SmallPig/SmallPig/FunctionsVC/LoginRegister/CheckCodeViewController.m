//
//  RegisterViewController.m
//  SmallPig
//
//  Created by chenlei on 14/11/26.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "CheckCodeViewController.h"
#import "SetPassWordViewController.h"

@interface CheckCodeViewController ()
{
    UIButton *codeButton;
    NSTimer *timer;
    int count;
}
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *checkCode;
@property (nonatomic, strong) NSString *WebCheckCode;
@property (nonatomic, strong) NSString *signText;
@end

@implementation CheckCodeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置title
    [self setCurrentTitle];
    //增加back按钮
    [self addBackItem];
    //初始化UI视图
    [self createUI];
    //关闭ScrollView默认偏移量
    self.automaticallyAdjustsScrollViewInsets = NO;
    //初始化数据
    count = 0;
    // Do any additional setup after loading the view.
}


#pragma mark 设置title
- (void)setCurrentTitle
{
    if (PushTypeRegister == self.pushType)
    {
        self.title = REGISTER_TITLE;
    }
    else if (PushTypeFindPassWord == self.pushType)
    {
        self.title = FIND_PSW_TITLE;
    }
    if (PushTypeChangePassword == self.pushType)
    {
        self.title = CHANGE_PSW_TITLE;
    }
    else if (PushTypeChangeMobile == self.pushType)
    {
        self.title = CHANGE_MOBILE_TITLE;
    }
}

#pragma mark 添加UI
//初始化视图
- (void)createUI
{
    [self addTableView];
    [self addButtons];
}

//添加表
- (void)addTableView
{
    [self addTableViewWithFrame:CGRectMake(15, NAV_HEIGHT + 20, SCREEN_WIDTH - 15 * 2, 88) tableType:UITableViewStylePlain tableDelegate:self];
    self.table.backgroundColor = [UIColor whiteColor];
    self.table.scrollEnabled = NO;
}

//添加下一步按钮
- (void)addButtons
{
    UIButton *nextButton = [CreateViewTool createButtonWithFrame:CGRectMake(self.table.frame.origin.x, self.table.frame.origin.y + self.table.frame.size.height + 25, self.table.frame.size.width, 40) buttonTitle:@"下一步" titleColor:WHITE_COLOR normalBackgroundColor:APP_MAIN_COLOR highlightedBackgroundColor:LOGIN_BUTTON_PRESSED_COLOR selectorName:@"nextButtonPressed:" tagDelegate:self];
    [CommonTool clipView:nextButton withCornerRadius:5.0];
    [self.view addSubview:nextButton];
}

#pragma mark 返回按钮事件
//返回按钮事件
- (void)backButtonPressed:(UIButton *)sender
{
    [self cancelTimer];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark 验证码
//验证码按钮事件
- (void)checkCodeButtonPressed:(UIButton *)button
{
    [self dismissKeyBoard];
    [self getInfo];
    codeButton.enabled = NO;
    if ([self isCanCommitWithType:1])
    {
        [self getCheckCodeRequest];
    }
    else
    {
        codeButton.enabled = YES;
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


- (void)getInfo
{
    for (int i = 0; i < 2; i++)
    {
        UITableViewCell *cell = [self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        UITextField *textField = (UITextField *)[cell.contentView viewWithTag:i + 1];
        NSString *text = (textField.text) ? textField.text : @"";
        if (i == 0)
        {
            self.phoneNumber = text;
        }
        else if (i == 1)
        {
            self.checkCode = text;
        }
    }
    
}

- (BOOL)isCanCommitWithType:(int)type
{
    //type : 1 获取验证码   2，下一步
    NSString *message = @"";
    if (self.phoneNumber.length == 0)
    {
        message = @"手机号不能为空";
        [CommonTool addAlertTipWithMessage:message];
        return NO;
    }
    if (type == 1)
    {
        return YES;
    }
    else if (type == 2)
    {
        if (self.checkCode.length == 0)
        {
            message = @"验证码不能为空";
        }
        else if (![CommonTool isEmailOrPhoneNumber:self.phoneNumber])
        {
            message = @"请输入正确的手机号";
        }
        
        if ([@"" isEqualToString:message])
        {
            return YES;
        }
        [CommonTool addAlertTipWithMessage:message];
    }
    return NO;
}


#pragma mark 获取验证码
- (void)getCheckCodeRequest
{
    [SVProgressHUD showWithStatus:@"正在发送..."];
    RequestTool *request = [[RequestTool alloc] init];
    NSDictionary *requestDic = @{@"mobileNo":self.phoneNumber};
    [request requestWithUrl:GET_CHECK_URL requestParamas:requestDic requestType:RequestTypeAsynchronous requestSucess:^(AFHTTPRequestOperation *operation, id responseDic)
    {
         NSLog(@"checkCode_responseDic===%@",responseDic);
        
        NSDictionary *dic = (NSDictionary *)responseDic;
        if ([dic[@"responseMessage"][@"success"] intValue] == 0)
        {
            NSString *message = dic[@"responseMessage"][@"message"];
            message = (message) ? message : @"发送失败";
            [SVProgressHUD showErrorWithStatus:message];
            codeButton.enabled = YES;
        }
        else
        {
            self.WebCheckCode = dic[@"checkCode"];
            [SVProgressHUD showSuccessWithStatus:@"发送成功"];
            timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeCount) userInfo:nil repeats:YES];
        }
    } requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        [SVProgressHUD showErrorWithStatus:@"发送失败"];
    }];
}


- (void)changeCount
{
    int  leftCount = 60 - count;
    NSString *title = [NSString stringWithFormat:@"%d秒",leftCount];
    if (leftCount <= 0)
    {
        title = @"获取验证码";
        codeButton.enabled = YES;
        [self cancelTimer];
    }
    [codeButton setTitle:title forState:UIControlStateNormal];
    count++;
}

- (void)cancelTimer
{
    if (timer)
    {
        [timer invalidate];
        timer = nil;
    }
}

#pragma mark 下一步按钮
//下一步按钮响应事件
- (void)nextButtonPressed:(UIButton *)button
{
    [self dismissKeyBoard];
    [self getInfo];
    if ([self isCanCommitWithType:2])
    {
        [self checkCodeRequest];
    }
}

#pragma  mark 校验验证码
- (void)checkCodeRequest
{
    [SVProgressHUD showWithStatus:@"正在校验..."];
    RequestTool *request = [[RequestTool alloc] init];
    NSDictionary *requestDic = @{@"checkCode":self.WebCheckCode,@"code":self.checkCode};
    [request requestWithUrl:CHECK_CODE_URL requestParamas:requestDic requestType:RequestTypeAsynchronous requestSucess:^(AFHTTPRequestOperation *operation, id responseDic)
     {
         NSLog(@"checkCode_responseDic===%@",responseDic);
         
         NSDictionary *dic = (NSDictionary *)responseDic;
         if ([dic[@"responseMessage"][@"success"] intValue] == 0)
         {
             NSString *message = dic[@"responseMessage"][@"message"];
             message = (message) ? message : @"校验失败";
             [SVProgressHUD showErrorWithStatus:message];
         }
         else
         {
             self.signText = dic[@"signText"];
             [self goToNextStep];
             [SVProgressHUD showSuccessWithStatus:@"校验成功" duration:.3];
         }
     } requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [SVProgressHUD showErrorWithStatus:@"校验失败"];
     }];
}

- (void)goToNextStep
{
    if (self.pushType == PushTypeFindPassWord || self.pushType == PushTypeRegister)
    {
        SetPassWordViewController *setPassWordVC = [[SetPassWordViewController alloc]init];
        setPassWordVC.pushType = self.pushType;
        setPassWordVC.phoneNumber = self.phoneNumber;
        setPassWordVC.signText = self.signText;
        [self.navigationController pushViewController:setPassWordVC animated:YES];
    }
    else if (self.pushType == PushTypeChangePassword)
    {
        //修改密码
    }
    else if (self.pushType == PushTypeChangeMobile)
    {
        //直接发起修改手机号接口
    }
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
    
    UITextField *textField = [CreateViewTool createTextFieldWithFrame:CGRectMake(70, 0, self.table.frame.size.width - 70 - 80, cell.frame.size.height) textColor:[UIColor blackColor] textFont:LOGIN_REG_FONT placeholderText:@"请输入手机号"];
    textField.tag = indexPath.row + 1;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [cell.contentView addSubview:textField];
    
    if (indexPath.row == 0)
    {
        label.text = @"手机号:";
    }
    else
    {
        codeButton = [CreateViewTool createButtonWithFrame:CGRectMake(textField.frame.origin.x + textField.frame.size.width + 10, 4.5, 60, 35) buttonTitle:@"获取验证码" titleColor:WHITE_COLOR normalBackgroundColor:CHECK_CODE_BG_COLOR highlightedBackgroundColor:CHECK_CODE_HIGH_COLOR selectorName:@"checkCodeButtonPressed:" tagDelegate:self];
        codeButton.titleLabel.font = FONT(11.0);
        [CommonTool clipView:codeButton withCornerRadius:5.0];
        [cell.contentView addSubview:codeButton];
        textField.placeholder = @"请输入验证码";
        label.text = @"验证码:";
    }
    
    return cell;
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
