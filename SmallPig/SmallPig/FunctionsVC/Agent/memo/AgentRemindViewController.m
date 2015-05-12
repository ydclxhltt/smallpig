//
//  AgentRemindViewController.m
//  SmallPig
//
//  Created by clei on 15/3/4.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "AgentRemindViewController.h"

@interface AgentRemindViewController ()
{
    UITextView *textView;
}
@end

@implementation AgentRemindViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置title
    NSString *title = (self.type == 1) ? @"新建" : @"备忘录详情";
    [self setTitle:title];
    //添加完成按钮
    [self setNavBarItemWithTitle:@"完成" navItemType:rightItem selectorName:@"commitRemind"];
    //添加返回
    [self addBackItem];
    //初始化UI
    [self createUI];
    //获取数据
    if (self.type == 2)
    {
        [self getRemindDetail];
    }
    // Do any additional setup after loading the view.
}

#pragma mark 初始化UI
- (void)createUI
{
    [self addTextView];
}

- (void)addTextView
{
    textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    textView.text = @"";
    textView.font = FONT(15.0);
    if (self.type == 1)
    {
        [textView becomeFirstResponder];
    }
    [self.view addSubview:textView];
}


#pragma mark 获取详情
- (void)getRemindDetail
{
    self.ID = (self.ID) ? self.ID : @"";
    NSDictionary *requestDic = @{@"id":self.ID};
    UITextView *tempTextView = textView;
    RequestTool *request = [[RequestTool alloc] init];
    [request requestWithUrl:MEMO_FIND_URL requestParamas:requestDic requestType:RequestTypeAsynchronous requestSucess:
     ^(AFHTTPRequestOperation *operation, id responseDic)
     {
         NSLog(@"remindresponseDic===%@",responseDic);
         NSDictionary *dic = (NSDictionary *)responseDic;
         int sucess = [dic[@"responseMessage"][@"success"] intValue];
         if (sucess == 1)
         {
             [SVProgressHUD showSuccessWithStatus:LOADING_SUCESS];
             tempTextView.text = dic[@"model"][@"content"];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:LOADING_FAILURE];
         }
     }
    requestFail:^(AFHTTPRequestOperation *operation,NSError *error)
     {
         [SVProgressHUD showErrorWithStatus:LOADING_FAILURE];
         NSLog(@"error===%@",error);
     }];
}

#pragma mark 完成
- (void)commitRemind
{
    if (textView.text.length == 0)
    {
        return;
    }
    __weak typeof(self) weakSelf = self;
    NSString *url = (self.type == 1) ? MEMO_ADD_URL : MEMO_UPDATE_URL;
    NSString *tipStr = @"正在保存...";
    [SVProgressHUD showWithStatus:tipStr];
    NSDictionary *requestDic = @{@"title":@"",@"content":textView.text};;
    if(self.type == 2)
    {
        requestDic = @{@"id":self.ID,@"title":@"",@"content":textView.text};
    }
    RequestTool *request = [[RequestTool alloc] init];
    [request requestWithUrl:url requestParamas:requestDic requestType:RequestTypeAsynchronous requestSucess:
     ^(AFHTTPRequestOperation *operation, id responseDic)
    {
        NSDictionary *dic = (NSDictionary *)responseDic;
        int sucess = [dic[@"responseMessage"][@"success"] intValue];
        if (sucess == 1)
        {
            self.type = 2;
            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
            weakSelf.ID = dic[@"modle"][@"id"];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"保存失败"];
        }
        NSLog(@"remindresponseDic===%@",responseDic);
    }
    requestFail:^(AFHTTPRequestOperation *operation,NSError *error)
    {
        [SVProgressHUD showErrorWithStatus:@"保存失败"];
        NSLog(@"error===%@",error);
    }];
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
