//
//  InformAgainstViewController.m
//  SmallPig
//
//  Created by chenlei on 15/1/27.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "InformAgainstViewController.h"

@interface InformAgainstViewController()<UITableViewDataSource,UITableViewDelegate>
{
    UIImageView *titleView;
}
@property (nonatomic, strong) NSArray *titleArray;
@end

@implementation InformAgainstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置title
    [self setTitleView];
    //添加返回item
    [self addBackItem];
    //初始化数据
    self.dataArray = (NSMutableArray *)@[@[@"湖畔百货小区两房一厅",@"虚假房屋信息!",@"1"],@[@"白金假日小区两房一厅",@"虚假房屋信息",@"0"]];
    self.titleArray = @[@"标题:",@"举报理由:",@"处理结果:"];
    //初始化UI
    [self createUI];

}

#pragma mark 设置titleView
- (void)setTitleView
{
    
    float width = 150.0 * scale;
    float height = 30.0;
    titleView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, 0, width, height) placeholderImage:nil];
    titleView.clipsToBounds = YES;
    titleView.userInteractionEnabled = YES;
    [CommonTool setViewLayer:titleView withLayerColor:[UIColor whiteColor] bordWidth:1.0];
    [CommonTool clipView:titleView withCornerRadius:5.0];
    self.navigationItem.titleView = titleView;
    
    NSArray *array = @[@"我的举报",@"举报我的"];
    
    for (int i = 0; i<[array count]; i++)
    {
        UIButton *button = [CreateViewTool  createButtonWithFrame:CGRectMake(i * width/2, 0, width/2, titleView.frame.size.height) buttonTitle:array[i] titleColor:[UIColor whiteColor] normalBackgroundColor:[UIColor clearColor] highlightedBackgroundColor:[UIColor clearColor] selectorName:@"buttonPressed:" tagDelegate:self];
        button.tag = i + 1;
        button.titleLabel.font = FONT(15.0);
        [button setBackgroundImage:[CommonTool imageWithColor:[UIColor whiteColor]] forState:UIControlStateSelected];
        [button setTitleColor:APP_MAIN_COLOR forState:UIControlStateSelected];
        button.selected = (i == 0) ? YES : NO;
        [titleView addSubview:button];
    }
    
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


#pragma mark 按钮事件
- (void)buttonPressed:(UIButton *)sender
{
    sender.selected = YES;
    for (UIButton *button in titleView.subviews)
    {
        button.selected = (button.tag == sender.tag) ? YES : NO;
    }
    [self.table reloadData
     ];
}

#pragma mark tableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"2015-01-27";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  44.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray[section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:100];
    UILabel *contentLable = (UILabel *)[cell.contentView viewWithTag:101];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.separatorInset = UIEdgeInsetsMake(0, 100, 0, 0);
        
        float space_x = 20.0 * scale;
        
        titleLabel = [CreateViewTool createLabelWithFrame:CGRectMake(space_x, 0, 80.0 * scale, cell.frame.size.height) textString:@"" textColor:[UIColor grayColor] textFont:FONT(15.0)];
        titleLabel.tag = 100;
        [cell.contentView addSubview:titleLabel];
        
        contentLable = [CreateViewTool createLabelWithFrame:CGRectMake(titleLabel.frame.size.width + titleLabel.frame.origin.x, 0, cell.frame.size.width - 2 * space_x, cell.frame.size.height) textString:@"" textColor:[UIColor blackColor] textFont:FONT(15.0)];
        contentLable.tag = 101;
        [cell.contentView addSubview:contentLable];
    }
    
    titleLabel.text = self.titleArray[indexPath.row];
    contentLable.text = self.dataArray[indexPath.section][indexPath.row];
    if (indexPath.row == 2)
    {
        contentLable.text = ([contentLable.text intValue] == 1) ? @"已处理" : @"等待处理";
        contentLable.textColor = ([contentLable.text intValue] == 1) ? [UIColor grayColor] : RGB(245.0, 0.0, 8.0);
    }
    
    
    return cell;
}



@end
