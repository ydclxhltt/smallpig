//
//  AgentCenterViewController.m
//  SmallPig
//
//  Created by clei on 14/12/10.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "AgentCenterViewController.h"

@interface AgentCenterViewController ()

@end

@implementation AgentCenterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置title
    self.title = AGENT_CENTER_TITLE;
    //添加侧滑item
    [self addPersonItem];
    // Do any additional setup after loading the view.
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
