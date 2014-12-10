//
//  MineViewController.m
//  SmallPig
//
//  Created by clei on 14/11/6.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "MineViewController.h"

@interface MineViewController ()

@end

@implementation MineViewController


- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self= [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
        // Custom initialization
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置title
    self.title = MINE_CENTER_TITLE;
    //添加侧滑item
    [self addPersonItem];
    //初始化UI
    [self createUI];
    //初始化数据
    self.dataArray = (NSMutableArray *)@[@[@"头像",@"昵称",@"性别"],@[@"密码修改",@"绑定手机"],@[@"举报管理",@"升级为经纪人"],@[@"我的订单"],@[@"举报管理"]];
    // Do any additional setup after loading the view.
}

#pragma mark
- (void)createUI
{
    [self addTableViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) tableType:UITableViewStylePlain tableDelegate:self];
}


#pragma mark - tableView代理


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *imageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20.0) placeholderImage:nil];
    imageView.backgroundColor = [UIColor clearColor];
    return imageView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0 && indexPath.section == 0)
    return MINE_CENTER_ICON_HEIGHT;
    return 44.0;
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
    static NSString *homeCellID = @"mineCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:homeCellID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:homeCellID];
        cell.backgroundColor = WHITE_COLOR;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
    float right_width = 30.0;
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            UIImage *defaultImage = [UIImage imageNamed:@"user_default.png"];
            UIImageView *userIconImageView = [CreateViewTool createRoundImageViewWithFrame:CGRectMake(SCREEN_WIDTH - defaultImage.size.width/2 - right_width, (MINE_CENTER_ICON_HEIGHT - defaultImage.size.height/2)/2, defaultImage.size.width/2, defaultImage.size.height/2) placeholderImage:defaultImage borderColor:nil imageUrl:@""];
            [cell.contentView addSubview:userIconImageView];
        }
        else
        {
            UILabel *label = [CreateViewTool createLabelWithFrame:CGRectMake(SCREEN_WIDTH - 120 - right_width, 0 , 120, cell.frame.size.height) textString:@"你大爷" textColor:MINE_CENTER_LIST_COLOR textFont:MINE_CENTER_LIST_FONT];
            label.textAlignment = NSTextAlignmentRight;
            
            if (indexPath.row == 2)
            {
                label.text = @"不男不女";
            }
            [cell.contentView addSubview:label];
        }
    }
    
    if (indexPath.section == 1)
    {
        if (indexPath.row == 1)
        {
            UILabel *label = [CreateViewTool createLabelWithFrame:CGRectMake(SCREEN_WIDTH - 120 - right_width, 0 , 120, cell.frame.size.height) textString:@"158****8888" textColor:MINE_CENTER_LIST_COLOR textFont:MINE_CENTER_LIST_FONT];
            label.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:label];
        }
    }
    
    if (indexPath.section == 2)
    {
        if (indexPath.row == 1)
        {
            UILabel *label = [CreateViewTool createLabelWithFrame:CGRectMake(SCREEN_WIDTH - 80 - right_width, 0 , 80, cell.frame.size.height) textString:@"审核中" textColor:MINE_CENTER_LIST_TIP_COLOR textFont:MINE_CENTER_LIST_TIP_FONT];
            label.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:label];
        }
    }
    if (indexPath.section == 3)
    {
        
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
