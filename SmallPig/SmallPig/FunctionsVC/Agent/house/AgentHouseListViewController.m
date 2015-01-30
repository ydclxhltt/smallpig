//
//  AgentHouseListViewController.m
//  SmallPig
//
//  Created by clei on 15/1/30.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "AgentHouseListViewController.h"

@interface AgentHouseListViewController ()

@end

@implementation AgentHouseListViewController

- (void)viewDidLoad
{
    self.houseSource = HouseScourceFromSecondHand;
    [super viewDidLoad];
    [self setTitleViewWithArray:@[@"售房",@"租房"]];
    [self setNavBarItemWithTitle:@"  发布" navItemType:rightItem selectorName:@"publicHouseButtonPressed:"];
    // Do any additional setup after loading the view.
}

#pragma  mark 选项卡按钮事件
- (void)buttonPressed:(UIButton *)sender
{
    [super buttonPressed:sender];
    self.houseSource = (sender.tag == 1) ? HouseScourceFromSecondHand : HouseScourceFromRental;
    [self.table reloadData];
}

#pragma mark 发布房源
- (void)publicHouseButtonPressed:(UIButton *)sender
{
    
}


#pragma mark 点击行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView  deselectRowAtIndexPath:indexPath animated:YES];
    
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
