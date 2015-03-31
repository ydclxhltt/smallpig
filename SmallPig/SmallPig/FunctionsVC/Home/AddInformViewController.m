//
//  AddInformViewController.m
//  SmallPig
//
//  Created by clei on 15/3/31.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "AddInformViewController.h"

@interface AddInformViewController ()
{
    UITextView *textView;
}
@end

@implementation AddInformViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"新增举报";
    self.automaticallyAdjustsScrollViewInsets = NO;
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
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
}


#pragma mark 创建UI
- (void)createUI
{
    float left_width = 5.0;
    textView = [[UITextView alloc] initWithFrame:CGRectMake(left_width, NAV_HEIGHT + 10, SCREEN_WIDTH - left_width *2, 240)];
    textView.text = @"";
    [CommonTool setViewLayer:textView withLayerColor:[UIColor grayColor] bordWidth:.5];
    [CommonTool clipView:textView withCornerRadius:5.0];
    textView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:textView];
}

#pragma mark 提交按钮响应事件
- (void)commitButtonPressed:(UIButton *)sender
{
    if (textView.text.length == 0)
    {
        [CommonTool addAlertTipWithMessage:@"请填写举报内容"];
        return;
    }
    [SVProgressHUD showWithStatus:@"正在提交..."];
    NSDictionary  *requestDic = @{@"publishRoom.id":self.roomID,@"content":textView.text};
    NSLog(@"requestDic====%@",requestDic);
    RequestTool *request = [[RequestTool alloc] init];
    [request requestWithUrl:ADD_INFORM_URL requestParamas:requestDic requestType:RequestTypeAsynchronous
              requestSucess:^(AFHTTPRequestOperation *operation, id responseDic)
     {
         NSLog(@"responseDic====%@",operation.responseString    );
         
         int sucessCode = [responseDic[@"responseMessage"][@"success"] intValue];
         if (sucessCode == 1)
         {
             [SVProgressHUD showSuccessWithStatus:@"举报成功"];
             [self.navigationController popViewControllerAnimated:YES];
         }
         else
         {
             NSString *message = responseDic[@"responseMessage"][@"message"];
             message = (message) ? message : @"";
             [SVProgressHUD showErrorWithStatus:[@"举报失败 " stringByAppendingString:message]];
         }
         
     }
     requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [SVProgressHUD showErrorWithStatus:@"获取失败"];
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
