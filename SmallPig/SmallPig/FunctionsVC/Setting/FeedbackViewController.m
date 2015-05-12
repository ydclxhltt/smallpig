//
//  FeedbackViewController.m
//  SmallPig
//
//  Created by clei on 14/12/10.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//
#define TEXTFIELD_HEIGHT    40.0
#define TEXTVIEW_HEIGHT     150.0
#define SPACE_X             5.0
#define SPACE_Y             10.0
#define ADD_Y               10.0

#import "FeedbackViewController.h"

@interface FeedbackViewController ()<UITextFieldDelegate>
{
    UITextView *textView;
    UITextField *namefield,*mobileField;
}
@end

@implementation FeedbackViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //设置title
    self.title = FEEDBACK_TITLE;
    //添加返回item
    [self addBackItem];
    //添加提交item
    [self setNavBarItemWithTitle:@"提交" navItemType:rightItem selectorName:@"commitButtonPressed:"];
    //初始化UI
    [self createUI];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [textView becomeFirstResponder];
    [super viewDidAppear:YES];
    [self setMainSideCanSwipe:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [self setMainSideCanSwipe:YES];
}


#pragma mark 创建UI
- (void)createUI
{
    textView = [[UITextView alloc] initWithFrame:CGRectMake(SPACE_X, NAV_HEIGHT + SPACE_Y, SCREEN_WIDTH - SPACE_X *2, TEXTVIEW_HEIGHT)];
    [CommonTool setViewLayer:textView withLayerColor:[UIColor grayColor] bordWidth:.5];
    [CommonTool clipView:textView withCornerRadius:5.0];
    textView.backgroundColor = [UIColor whiteColor];
    textView.text = @"";
    [self.view addSubview:textView];
    //name content mobile
    namefield = [CreateViewTool createTextFieldWithFrame:CGRectMake(SPACE_X, textView.frame.origin.y + textView.frame.size.height + SPACE_Y, SCREEN_WIDTH - SPACE_X *2, TEXTFIELD_HEIGHT) textColor:[UIColor blackColor] textFont:FONT(15.0) placeholderText:@"请输入您的姓名"];
    namefield.backgroundColor = [UIColor whiteColor];
    namefield.text = @"";
    namefield.delegate = self;
    [CommonTool clipView:namefield withCornerRadius:5.0];
    [self.view addSubview:namefield];
    
    mobileField = [CreateViewTool createTextFieldWithFrame:CGRectMake(SPACE_X, namefield.frame.origin.y + namefield.frame.size.height + SPACE_Y, SCREEN_WIDTH - SPACE_X *2, TEXTFIELD_HEIGHT) textColor:[UIColor blackColor] textFont:FONT(15.0) placeholderText:@"请输入您的手机号"];
    mobileField.text = @"";
    mobileField.keyboardType = UIKeyboardTypeNumberPad;
    mobileField.backgroundColor = [UIColor whiteColor];
    mobileField.delegate = self;
    [CommonTool clipView:mobileField withCornerRadius:5.0];
    [self.view addSubview:mobileField];
}

#pragma mark 提交按钮响应事件
- (void)commitButtonPressed:(UIButton *)sender
{
    if (![self isCanCommit])
    {
        return;
    }
    else
    {
        [self commitFaceBack];
    }
}

#pragma mark 是否可以提交
- (BOOL)isCanCommit
{
    NSString *message = @"";
    if (textView.text.length == 0)
    {
        message = @"请留下您的宝贵建议";
    }
    else if (mobileField.text.length > 0)
    {
        if (![CommonTool isEmailOrPhoneNumber:mobileField.text])
        {
            message = @"请输入正确的手机号";
        }
    }
    if (message.length == 0)
    {
        return YES;
    }
    else
    {
        [CommonTool addAlertTipWithMessage:message];
    }
    return NO;
}


#pragma mark 提交反馈
- (void)commitFaceBack
{
    [SVProgressHUD showWithStatus:@"正在提交..."];
    RequestTool *request = [[RequestTool alloc] init];
    NSDictionary *requestDic = @{@"name":namefield.text,@"mobile":mobileField.text,@"content":textView.text};
    [request requestWithUrl:FACEBACK_URL requestParamas:requestDic requestType:RequestTypeAsynchronous requestSucess:^(AFHTTPRequestOperation *operation, id responseDic)
     {
         NSLog(@"order_responseDic===%@",responseDic);
         NSDictionary *dic = (NSDictionary *)responseDic;
         if ([dic[@"responseMessage"][@"success"] intValue] == 1)
         {
             [SVProgressHUD showSuccessWithStatus:@"提交成功"];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:@"提交失败"];
         }
     }
    requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [SVProgressHUD showErrorWithStatus:@"提交失败"];
         NSLog(@"login_error===%@",error);
     }];
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
