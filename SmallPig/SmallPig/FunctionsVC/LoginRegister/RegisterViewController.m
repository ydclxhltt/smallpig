//
//  RegisterViewController.m
//  SmallPig
//
//  Created by chenlei on 14/11/26.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "RegisterViewController.h"
#import "SetPassWordViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

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
    // Do any additional setup after loading the view.
}

#pragma mark 设置title
- (void)setCurrentTitle
{
    if (self.pushType == PushTypeRegister)
    {
        self.title = REGISTER_TITLE;
    }
    else if (self.pushType == PushTypeFindPassWord)
    {
        self.title = FIND_PSW_TITLE;
    }
}


//初始化视图
- (void)createUI
{
    //添加表
    [self addTableViewWithFrame:CGRectMake(15, NAV_HEIGHT + 20, SCREEN_WIDTH - 15 * 2, 88) tableType:UITableViewStylePlain tableDelegate:self];
    self.table.backgroundColor = [UIColor whiteColor];
    self.table.scrollEnabled = NO;
    
    //添加下一步按钮
    UIButton *nextButton = [CreateViewTool createButtonWithFrame:CGRectMake(self.table.frame.origin.x, self.table.frame.origin.y + self.table.frame.size.height + 25, self.table.frame.size.width, 40) buttonTitle:@"下一步" titleColor:WHITE_COLOR normalBackgroundColor:APP_MAIN_COLOR highlightedBackgroundColor:LOGIN_BUTTON_PRESSED_COLOR selectorName:@"nextButtonPressed:" tagDelegate:self];
    [CommonTool clipView:nextButton withCornerRadius:5.0];
    [self.view addSubview:nextButton];
    
}

#pragma mark 返回按钮事件
//返回按钮事件
- (void)backButtonPressed:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)nextButtonPressed:(UIButton *)button
{
    SetPassWordViewController *setPassWordVC = [[SetPassWordViewController alloc]init];
    setPassWordVC.pushType = self.pushType;
    [self.navigationController pushViewController:setPassWordVC animated:YES];
}

- (void)checkCodeButtonPressed:(UIButton *)button
{
    
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
    
    UITextField *textField = [CreateViewTool createTextFieldWithFrame:CGRectMake(70, 0, self.table.frame.size.width - 70 - 80, cell.frame.size.height) textColor:[UIColor blackColor] textFont:LOGIN_REG_FONT placeholderText:@"请输入手机号"];
    textField.tag = indexPath.row + 1;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [cell.contentView addSubview:textField];
    
    if (indexPath.row == 0)
    {
        label.text = @"手机号:";
    }
    else
    {
        UIButton *button = [CreateViewTool createButtonWithFrame:CGRectMake(textField.frame.origin.x + textField.frame.size.width + 10, 4.5, 60, 35) buttonTitle:@"获取验证码" titleColor:WHITE_COLOR normalBackgroundColor:CHECK_CODE_BG_COLOR highlightedBackgroundColor:CHECK_CODE_HIGH_COLOR selectorName:@"checkCodeButtonPressed:" tagDelegate:self];
        button.titleLabel.font = FONT(11.0);
        [CommonTool clipView:button withCornerRadius:5.0];
        [cell.contentView addSubview:button];
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
