//
//  AgentRankListViewController.m
//  SmallPig
//
//  Created by clei on 14/12/9.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "AgentRankListViewController.h"
#import "AgentRankListCell.h"
#import "AgentDetailViewController.h"

@interface AgentRankListViewController ()

@end

@implementation AgentRankListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置title
    self.title = AGENT_LIST_TITLE;
    //添加班会item
    [self addBackItem];
    //初始化视图
    [self createUI];
    //test
    self.dataArray = (NSMutableArray *)@[@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1"];
    // Do any additional setup after loading the view.
}

#pragma mark 创建UI
- (void)createUI
{
    [self addTableViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) tableType:UITableViewStylePlain tableDelegate:self];
}


#pragma mark - tableView代理


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return AGENT_LIST_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *homeCellID = @"agentRankCellID";
    AgentRankListCell *cell = (AgentRankListCell *)[tableView dequeueReusableCellWithIdentifier:homeCellID];
    if (cell == nil)
    {
        cell = [[AgentRankListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:homeCellID];
        cell.backgroundColor = WHITE_COLOR;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    [cell setCellDataWithRank:(int)indexPath.row + 1 agentImageUrl:@"" agentName:@"你妹你大爷" agentScore:@"1111"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AgentDetailViewController *agentDetailViewController = [[AgentDetailViewController alloc] init];
    [self.navigationController pushViewController:agentDetailViewController animated:YES];
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
