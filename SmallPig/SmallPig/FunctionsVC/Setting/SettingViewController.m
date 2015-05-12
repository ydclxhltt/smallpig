//
//  SettingViewController.m
//  SmallPig
//
//  Created by clei on 14/12/10.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "SettingViewController.h"
#import "FeedbackViewController.h"
#import "AboutUsViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置titile
    self.title = SETTING_TITLE;
    //添加策划item
    [self addPersonItem];
    //初始化UI
    [self createUI];
    //初始化数据
    self.dataArray = (NSMutableArray *)@[@[@"仅WIFI环境下下载图片",@"清除缓存"],@[@"意见反馈",@"关于我们"]];
    // Do any additional setup after loading the view.
}

#pragma mark 创建UI
- (void)createUI
{
    [self addTableViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) tableType:UITableViewStyleGrouped tableDelegate:self];
}

#pragma mark - tableView代理


//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 20.0;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIImageView *imageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20.0) placeholderImage:nil];
//    imageView.backgroundColor = [UIColor clearColor];
//    return imageView;
//}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *titleString = @"";
    if (section == 0)
    {
        titleString = @"功能设置";
    }
    else if (section == 1)
    {
        titleString = @"信息设置";
    }
    return titleString;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SETTING_LIST_HEIGHT;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.dataArray objectAtIndex:section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *homeCellID = @"settingCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:homeCellID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:homeCellID];
        cell.backgroundColor = WHITE_COLOR;
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    float right_width = 30.0;
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH  - 60, (SETTING_LIST_HEIGHT - 30)/2, 60 , 30)];
            [switchView setOn:NO];
            [cell.contentView addSubview:switchView];
        }
        else
        {
            UILabel *label = [CreateViewTool createLabelWithFrame:CGRectMake(SCREEN_WIDTH - 120 - right_width, 0 , 120, SETTING_LIST_HEIGHT) textString:@"" textColor:MINE_CENTER_LIST_COLOR textFont:MINE_CENTER_LIST_FONT];
            label.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:label];
        }
    }

    NSArray *array = [self.dataArray objectAtIndex:indexPath.section];
    cell.textLabel.text = [array objectAtIndex:indexPath.row];
    cell.textLabel.font = SYSTEM_LIST_FONT;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 1)
        {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"清楚所有的缓存数据" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            [alertView show];
        }
    }
    if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            FeedbackViewController *feedbackViewController = [[FeedbackViewController alloc] init];
            [self.navigationController pushViewController:feedbackViewController animated:YES];
        }
        else if (indexPath.row == 1)
        {
            AboutUsViewController *aboutUsViewController = [[AboutUsViewController alloc] init];
            [self.navigationController pushViewController:aboutUsViewController animated:YES];
        }
    }
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
