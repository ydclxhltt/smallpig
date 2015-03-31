//
//  AddInformViewController.m
//  SmallPig
//
//  Created by clei on 15/3/31.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "AddInformViewController.h"

@interface AddInformViewController ()

@end

@implementation AddInformViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"新增举报";
    //添加item
    [self addBackItem];
    [self setNavBarItemWithTitle:@"提交" navItemType:rightItem selectorName:@"commitButtonPressed:"];
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
