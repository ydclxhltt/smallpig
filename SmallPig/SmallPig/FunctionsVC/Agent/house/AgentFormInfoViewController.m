//
//  AgentFormInfoViewController.m
//  SmallPig
//
//  Created by clei on 15/3/9.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "AgentFormInfoViewController.h"
#import "LeftRightLableCell.h"

#define AGENT_FORM_INFO_HEIGHT   50.0

@interface AgentFormInfoViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSArray *headerArray;
@property (nonatomic, strong) NSArray *titleArray;
@end

@implementation AgentFormInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"2.提交资料审核";
    //添加item
    [self addBackItem];
    [self setNavBarItemWithTitle:@"提交" navItemType:rightItem selectorName:@"commitButtonPressed:"];
    //初始化数据
    self.headerArray = @[@"房屋资料",@"经纪人资料"];
    self.titleArray = @[@[@"房产证号",@"业主姓名",@"联系电话"],@[@"姓名",@"电话"]];
    NSDictionary *userInfoDic = [[SmallPigApplication shareInstance] userInfoDic];
    NSString *mobile = userInfoDic[@"mobile"];
    mobile = (mobile) ? mobile : @"";
    NSString *name = userInfoDic[@"name"];
    name = (name) ? name : @"";
    self.dataArray = (NSMutableArray *)@[@[@"",@"",@""],@[name,mobile]];
    //初始化UI
    [self createUI];
    // Do any additional setup after loading the view.
}


#pragma mark 初始化UI
- (void)createUI
{
    [self addTableView];
}

- (void)addTableView
{
    [self addTableViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) tableType:UITableViewStyleGrouped tableDelegate:self];
}

#pragma mark 提交按钮 
- (void)commitButtonPressed:(UIButton *)sender
{
    
}



#pragma mark tableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.headerArray[section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int number = (section == 0) ? 3 : 2;
    return number;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return AGENT_FORM_INFO_HEIGHT * scale;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    LeftRightLableCell *cell = (LeftRightLableCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[LeftRightLableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    [cell setLeftColor:[UIColor blackColor] rightColor:HOUSE_DETAIL_TITLE_COLOR];
    [cell setDataWithLeftText:self.titleArray[indexPath.section][indexPath.row] rightText:self.dataArray[indexPath.section][indexPath.row]];
    
    return cell;
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
