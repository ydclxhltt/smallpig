//
//  AgentCenterViewController.m
//  SmallPig
//
//  Created by clei on 14/12/10.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "AgentCenterViewController.h"
#import "AgentHouseListViewController.h"
#import "AgentMemoListViewController.h"
#import "AgentScoreViewController.h"
#import "OrderListViewController.h"

#define SPACE_Y                   80.0
#define ICON_WH                   75.0
#define ADD_SPACE_Y               15.0
#define LABEL_HEIGHT              20.0
#define AGENTCENTER_LIST_HEIGHT   50.0
#define AGENTCENTER_HEADER_HEIGHT 15.0
#define TIPLABEL_WIDTH            160.0
@interface AgentCenterViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSArray *tipArray;
@end

@implementation AgentCenterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置title
    self.title = AGENT_CENTER_TITLE;
    //初始化数据
    self.dataArray = (NSMutableArray *)@[@[@"我的房源",@"我的订单"],@[@"会员充值",@"我的积分"],@[@"我的备忘"]];
    self.tipArray = @[@"88套",@"8个",@"",@"3838分",@"3个待办事项"];
    //添加侧滑item
    [self addPersonItem];
    //初始化UI
    [self createUI];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setMainSideCanSwipe:YES];
}

#pragma mark 初始化UI
- (void)createUI
{
    [self addTopView];
    [self addTableView];
}

- (void)addTopView
{
    UIView *greenView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 220 * scale)];
    greenView.backgroundColor = APP_MAIN_COLOR;
    [self.view addSubview:greenView];
    
    float icon_wh = ICON_WH * scale;
    
    NSDictionary *userInfoDic = [[SmallPigApplication shareInstance] userInfoDic];
    
    NSString *userName = @"";
    NSString *imageUrl = @"";
    if (userInfoDic)
    {
        imageUrl = @"http://112.95.225.12:8068/epg30/selfadaimg.do?path=/posticon/20140930/2846407/173142.jpg";

        NSString *nickName = userInfoDic[@"nickName"];
        NSString *name = userInfoDic[@"name"];
        name = (name) ? name : @"";
        nickName = (nickName) ? nickName : @"";
        userName = (nickName && ![@"" isEqualToString:nickName]) ? nickName : name;
    }
    
    UIImageView *iconImageView = [CreateViewTool createRoundImageViewWithFrame:CGRectMake((SCREEN_WIDTH - icon_wh)/2, SPACE_Y * scale, ICON_WH, ICON_WH) placeholderImage:[UIImage imageNamed:@"person_icon_default.png"] borderColor:RGB(27.0, 138, 86.0) imageUrl:imageUrl];
    [greenView addSubview:iconImageView];
    
    UILabel *titleLabel = [CreateViewTool createLabelWithFrame:CGRectMake(0, iconImageView.frame.size.height + iconImageView.frame.origin.y + ADD_SPACE_Y * scale, SCREEN_WIDTH, LABEL_HEIGHT) textString:userName textColor:WHITE_COLOR textFont:FONT(16.0)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [greenView addSubview:titleLabel];
    
    startHeight = greenView.frame.origin.y + greenView.frame.size.height;
}

- (void)addTableView
{
    [self addTableViewWithFrame:CGRectMake(0, startHeight, SCREEN_WIDTH, SCREEN_HEIGHT - startHeight) tableType:UITableViewStyleGrouped tableDelegate:self];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AGENTCENTER_HEADER_HEIGHT * scale)];
    self.table.tableHeaderView = view;
}



#pragma mark tableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray[section] count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *imageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, .00001) placeholderImage:nil];
    return imageView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return .00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return AGENTCENTER_LIST_HEIGHT * scale;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    UILabel *tipLabel = (UILabel *)[cell.contentView viewWithTag:100];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.imageView.transform = CGAffineTransformScale(cell.imageView.transform, .5, .5);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        tipLabel = [CreateViewTool createLabelWithFrame:CGRectMake(cell.frame.size.width - TIPLABEL_WIDTH * scale - 30.0, 0, TIPLABEL_WIDTH, AGENTCENTER_LIST_HEIGHT * scale) textString:@"" textColor:HOUSE_DETAIL_TITLE_COLOR textFont:FONT(15.0)];
        tipLabel.textAlignment = NSTextAlignmentRight;
        //tipLabel.backgroundColor = [UIColor redColor];
        tipLabel.tag = 100;
        [cell.contentView addSubview:tipLabel];
    }
    
    int index = (int)(indexPath.section * 2 + indexPath.row + 1);
    
    tipLabel.text = self.tipArray[index - 1];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"agent_icon%d.png",index]];
    cell.textLabel.text = self.dataArray[indexPath.section][indexPath.row];
    cell.textLabel.font = FONT(16.0);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *viewController = nil;
    int index = (int)(indexPath.section * 2 + indexPath.row);
    switch (index)
    {
        case 0:
            viewController = [[AgentHouseListViewController alloc] init];
            break;
        case 1:
            viewController = [[OrderListViewController alloc] init];
            break;
        case 3:
            viewController = [[AgentScoreViewController alloc] init];
            break;
        case 4:
            viewController = [[AgentMemoListViewController alloc] init];
            break;
        default:
            break;
    }
    if (viewController)
    {
        [self.navigationController pushViewController:viewController animated:YES];
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
