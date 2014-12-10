//
//  FeedbackViewController.m
//  SmallPig
//
//  Created by clei on 14/12/10.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()
{
    UITextView *textView;
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
    float left_width = 5.0;
    textView = [[UITextView alloc] initWithFrame:CGRectMake(left_width, NAV_HEIGHT + 10, SCREEN_WIDTH - left_width *2, 240)];
    [CommonTool setViewLayer:textView withLayerColor:[UIColor grayColor] bordWidth:.5];
    [CommonTool clipView:textView withCornerRadius:5.0];
    textView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:textView];
}

#pragma mark 提交按钮响应事件
- (void)commitButtonPressed:(UIButton *)sender
{
    
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
