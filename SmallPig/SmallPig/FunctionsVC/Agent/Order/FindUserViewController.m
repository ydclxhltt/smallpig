//
//  FindUserViewController.m
//  SmallPig
//
//  Created by clei on 15/4/2.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "FindUserViewController.h"

@interface FindUserViewController ()<UITextFieldDelegate>
{
    UITextField *mobileTextField;
}
@end

@implementation FindUserViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"查找用户";
    [self addBackItem];
    [self setNavBarItemWithTitle:@"查找" navItemType:rightItem selectorName:@"findUser"];
    [self createUI];
    // Do any additional setup after loading the view.
}

- (void)backButtonPressed:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:Nil];
}

#pragma  mark 初始化UI
- (void)createUI
{
    UIImageView *imageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0,  NAV_HEIGHT + 20.0, SCREEN_WIDTH, 40.0) placeholderImage:nil];
    imageView.backgroundColor = WHITE_COLOR;
    [self.view addSubview:imageView];
    mobileTextField = [CreateViewTool createTextFieldWithFrame:CGRectMake(10,0, SCREEN_WIDTH - 20, 40.0) textColor:[UIColor blackColor] textFont:FONT(15.0) placeholderText:@"请输入手机号"];
    mobileTextField.keyboardType = UIKeyboardTypeNumberPad;
    mobileTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    mobileTextField.delegate = self;
    mobileTextField.text = @"";
    [imageView addSubview:mobileTextField];
}

#pragma mark 查找
- (void)findUser
{
    
    if ([CommonTool isEmailOrPhoneNumber:mobileTextField.text])
    {
        [mobileTextField resignFirstResponder];
        [self searchUserWithMobile:mobileTextField.text];
    }
    else
    {
        [CommonTool addAlertTipWithMessage:@"请输入正确的手机号码"];
    }
}

#pragma mark 查找用户
- (void)searchUserWithMobile:(NSString *)mobile
{
    
    [SVProgressHUD showWithStatus:@"正在查询..."];
    RequestTool *request = [[RequestTool alloc] init];
    NSDictionary *requestDic = @{@"mobile":mobileTextField.text};
    [request requestWithUrl:FIND_USER_URL requestParamas:requestDic requestType:RequestTypeAsynchronous requestSucess:^(AFHTTPRequestOperation *operation, id responseDic)
     {
         NSLog(@"order_responseDic===%@",responseDic);
         NSDictionary *dic = (NSDictionary *)responseDic;
         if ([dic[@"responseMessage"][@"success"] intValue] == 1)
         {
             [SVProgressHUD showSuccessWithStatus:@"查询成功"];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"FindUser" object:@{@"id":responseDic[@"model"][@"id"],@"name":responseDic[@"model"][@"name"]}];
             [self dismissViewControllerAnimated:YES completion:nil];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:@"查询失败"];
         }
     }
     requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [SVProgressHUD showErrorWithStatus:@"查询失败"];
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
