//
//  SendOrderViewController.m
//  SmallPig
//
//  Created by clei on 15/3/11.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "SendOrderViewController.h"

@interface SendOrderViewController ()

@end

@implementation SendOrderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置title
    self.title = @"创建订单";
    //添加item
    [self addBackItem];
    [self setNavBarItemWithTitle:@"发送" navItemType:rightItem selectorName:@"sendButtonPressed:"];
    // Do any additional setup after loading the view.
}


#pragma mark 发送
- (void)sendButtonPressed:(UIButton *)sender
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
