//
//  NewHouseListViewController.m
//  SmallPig
//
//  Created by clei on 14/12/4.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "NewHouseListViewController.h"

@interface NewHouseListViewController ()

@end

@implementation NewHouseListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置title
    self.title = NEW_HOUSE_TITLE;
    //设置背景颜色
    self.view.backgroundColor = NEW_HOUSE_BG_COLOR;
    //添加返回按钮
    [self addBackItem];
    //初始化视图
    [self createUI];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //设置不可侧滑
    [self setMainSideCanSwipe:NO];
}

#pragma mark 添加UI
- (void)createUI
{
    float start_y = 135.0 + NAV_HEIGHT;
    UIImage *logoImage = [UIImage imageNamed:@"newhouse_logo.png"];
    UIImageView *logoImageView = [CreateViewTool createImageViewWithFrame:CGRectMake((SCREEN_WIDTH - logoImage.size.width/2)/2, start_y, logoImage.size.width/2, logoImage.size.height/2) placeholderImage:logoImage];
    [self.view addSubview:logoImageView];
    
    start_y +=  logoImageView.frame.size.height + 10;
    
    UILabel *tiplabel = [CreateViewTool createLabelWithFrame:CGRectMake(0, start_y, SCREEN_WIDTH, 50) textString:NEW_HOUSE_TIP textColor:NEW_HOUSE_TIP_TEXT_COLOR textFont:NEW_HOUSE_TIP_FONT];
    tiplabel.numberOfLines = 2.0;
    tiplabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tiplabel];
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
