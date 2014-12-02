//
//  LoginViewController.m
//  SmallPig
//
//  Created by chenlei on 14/11/26.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"

@interface LoginViewController ()

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
    NSLog(@"====%f====%f",self.navigationController.navigationBar.frame.size.height,[[UIApplication sharedApplication]statusBarFrame].size.height);
    NSLog(@"=====%@",NSStringFromCGRect([[UIScreen mainScreen] bounds]));
    // Do any additional setup after loading the view.
}

//初始化视图
- (void)createUI
{
    //添加表
    [self addTableViewWithFrame:CGRectMake(15, NAV_HEIGHT + 20, SCREEN_WIDTH - 15 * 2, 88) tableType:UITableViewStylePlain tableDelegate:self];
    self.table .backgroundColor = [UIColor whiteColor];
    self.table.scrollEnabled = NO;
    
    //添加登录按钮
    UIButton *loginButton = [CreateViewTool createButtonWithFrame:CGRectMake(self.table.frame.origin.x, self.table.frame.origin.y + self.table.frame.size.height + 25, self.table.frame.size.width, 40) buttonTitle:@"登录" titleColor:WIHTE_COLOR normalBackgroundColor:APP_MAIN_COLOR highlightedBackgroundColor:nil selectorName:@"loginButtonPressed:" tagDelegate:self];
    loginButton.showsTouchWhenHighlighted = YES;
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


- (void)loginButtonPressed:(UIButton *)button
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)registerButtonPressed:(UIButton *)button
{
   [self pushRegisterWithType:PushTypeRegister];
}

- (void)findPassWordButtonPressed:(UIButton *)button
{
    [self pushRegisterWithType:PushTypeFindPassWord];
}

- (void)pushRegisterWithType:(PushType)type
{
    RegisterViewController *registerVC = [[RegisterViewController alloc]init];
    registerVC.pushType = type;
    [self.navigationController pushViewController:registerVC animated:YES];
}



#pragma mark  tableView委托方法

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

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
    
    UILabel *label = [CreateViewTool createLabelWithFrame:CGRectMake(10, 0, 60, cell.frame.size.height) textColor:LOGIN_LABEL_COLOR textFont:LOGIN_REG_FONT];
    [cell.contentView addSubview:label];
    
    UITextField *textField = [CreateViewTool createTextFieldWithFrame:CGRectMake(70, 0, self.table.frame.size.width - 70 - 10, cell.frame.size.height) textColor:[UIColor blackColor] textFont:LOGIN_REG_FONT placeholderText:@"请输入手机号"];
    textField.returnKeyType = UIReturnKeyDone;
    textField.tag = indexPath.row + 1;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [cell.contentView addSubview:textField];
    
    if (indexPath.row == 0)
    {
        label.text = @"用户名:";
    }
    else
    {
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
