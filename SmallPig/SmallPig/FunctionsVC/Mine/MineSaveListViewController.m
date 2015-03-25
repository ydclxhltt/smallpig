//
//  MineSaveListViewController.m
//  SmallPig
//
//  Created by clei on 14/12/10.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "MineSaveListViewController.h"

@interface MineSaveListViewController ()

@end

@implementation MineSaveListViewController

- (void)viewDidLoad
{
    self.houseSource = HouseScourceFromSecondHand;
    [super viewDidLoad];
    //设置title
    //self.title = MINE_SAVE_TITLE;
    //设置item为nil
    //添加侧滑item
    [self addPersonItem];
    self.navigationItem.rightBarButtonItem = nil;
    //设置titleView
    [self setTitleViewWithArray:@[@"售房",@"租房"]];
    // Do any additional setup after loading the view.
}


#pragma  mark 选项卡按钮事件
- (void)buttonPressed:(UIButton *)sender
{
    [super buttonPressed:sender];
    self.houseSource = (sender.tag == 1) ? HouseScourceFromSecondHand : HouseScourceFromRental;
    [self.table reloadData];
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
