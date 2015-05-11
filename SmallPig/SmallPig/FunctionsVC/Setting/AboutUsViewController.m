//
//  AboutUsViewController.m
//  SmallPig
//
//  Created by clei on 14/12/10.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置title
    self.title = ABOUT_US_TITLE;
    //添加返回item
    [self addBackItem];
    //初始化UI
    [self createUI];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self setMainSideCanSwipe:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [self setMainSideCanSwipe:YES];
}

#pragma mark 初始化UI
- (void)createUI
{
    [self addWebView];
}

- (void)addWebView
{
    NSURLRequest *request  = [NSURLRequest requestWithURL:[NSURL URLWithString:ABOUT_US_URL]];
    UIWebView  *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    webView.scalesPageToFit = YES;
    [webView loadRequest:request];
    [self.view addSubview:webView];
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
