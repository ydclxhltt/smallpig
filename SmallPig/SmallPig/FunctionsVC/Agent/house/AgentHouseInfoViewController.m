//
//  AgentHouseInfoViewController.m
//  SmallPig
//
//  Created by clei on 15/1/30.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "AgentHouseInfoViewController.h"
#import "AgentFormInfoViewController.h"
#import "LeftRightLableCell.h"

#define ROW_NORMAL_HEIGHT  50.0
#define ROW_OTHER_HEIGHT   85.0

@interface AgentHouseInfoViewController ()<UIActionSheetDelegate>
{
    float sectionCount;
}
@property (nonatomic, strong) NSArray *titleArray;
@end

@implementation AgentHouseInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置title
    NSString *title = (self.houseInfoType == HouseInfoTypePublic) ? @"填写房源信息" : @"房源详情";
    self.title = title;
    //添加item
    if (self.houseInfoType == HouseInfoTypePublic)
    {
        [self setNavBarItemWithTitle:@"下一步" navItemType:rightItem selectorName:@"nextButtonPressed:"];
    }
    [self addBackItem];
    //初始化数据
    sectionCount = 3;
    self.titleArray = @[@[@"方式"],@[@"城市",@"区",@"片区",@"小区",@"楼",@"房"],@[@"租金",@"面积",@"搂层",@"户型",@"装修",@"朝向"],@[@"房源图片"],@[@"房源亮点"],@[@"标题",@"描述"]];
    //初始化UI
    [self createUI];
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedCity:) name:@"SelectedCity" object:nil];
    // Do any additional setup after loading the view.
}

#pragma mark 初始化UI
- (void)createUI
{
    [self addTableView];
}

- (void)addTableView
{
    [self addTableViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) tableType:UITableViewStylePlain tableDelegate:self];
    self.table.backgroundColor = [UIColor clearColor];
    //self.table.separatorInset = UIEdgeInsetsZero;
}

#pragma mark 下一步
- (void)nextButtonPressed:(UIButton *)sender
{
    AgentFormInfoViewController *formInfoViewController = [[AgentFormInfoViewController alloc] init];
    [self.navigationController pushViewController:formInfoViewController animated:YES];
}

#pragma mark tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *imageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15.0) placeholderImage:nil];
    imageView.backgroundColor = [UIColor clearColor];
    return imageView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return sectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titleArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SETTING_LIST_HEIGHT  * scale;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *leftRightCellID = @"LeftRightCell";
    static NSString *cellID = @"cellID";
    UITableViewCell *cell;
    
    if (indexPath.section < 3)
    {
        cell = (LeftRightLableCell *)[tableView dequeueReusableCellWithIdentifier:leftRightCellID];
        if (!cell)
        {
            cell = [[LeftRightLableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:leftRightCellID];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        [(LeftRightLableCell *)cell setLeftColor:[UIColor blackColor] rightColor:HOUSE_DETAIL_TITLE_COLOR];
        if ([self.dataArray[indexPath.section] count] > indexPath.row)
        {
            [(LeftRightLableCell *)cell setDataWithLeftText:self.titleArray[indexPath.section][indexPath.row] rightText:self.dataArray[indexPath.section][indexPath.row]];
        }
        else
        {
            [(LeftRightLableCell *)cell setDataWithLeftText:self.titleArray[indexPath.section][indexPath.row] rightText:@""];
        }

    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell)
        {
            
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.houseInfoType == HouseInfoTypePublic)
    {
        int section = indexPath.section;
        int row = indexPath.row;
        
        if (section == 0)
        {
            [self addActionSheetView];
        }
        else
        {
            if (section == 2)
            {
                return;
            }
            if (!self.dataArray)
            {
                [CommonTool addAlertTipWithMessage:@"请选择方式"];
            }
            else
            {
                NSArray *array = self.dataArray[indexPath.section];
                if ([array count] < indexPath.row)
                {
                    NSString *tipString = [NSString stringWithFormat:@"请选择%@",self.titleArray[section][row - 1]];
                    [CommonTool addAlertTipWithMessage:tipString];
                }
                else
                {
                    
                }
            }
        }
    }
}


#pragma mark 方式
- (void)addActionSheetView
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"二手房",@"租房", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 2)
    {
        NSString *string = (buttonIndex == 0) ? @"二手房" : @"租房";
        [self setDataWithSection:0 row:0 value:string];
    }
}


- (void)setDataWithSection:(int)section row:(int)row value:(NSString *)value
{
    if (!self.dataArray)
    {
        self.dataArray = [NSMutableArray arrayWithArray:@[@[],@[],@[],@[],@[],@[]]];
    }
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.dataArray[section]];
    if ([array count] < row + 1)
    {
        [array addObject:value];
    }
    else
    {
        [array replaceObjectAtIndex:row withObject:value];
    }
    
    [self.dataArray replaceObjectAtIndex:section withObject:array];
    [self.table reloadData];
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
