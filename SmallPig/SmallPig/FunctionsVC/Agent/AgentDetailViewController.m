//
//  AgentDetailViewController.m
//  SmallPig
//
//  Created by clei on 14/12/11.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#define AGENT_DETAIL_HEADER_HEIGHT 30.0

#import "AgentDetailViewController.h"
#import "RentalHouseListCell.h"
#import "SecondHandHouseListCell.h"


@interface AgentDetailViewController ()
{
    UIImageView *headerImageView;
    int buttonSelectedIndex;
}

@property(nonatomic, retain) NSArray *imagesArray;
@property(nonatomic, assign) HouseScource houseScource;

@end

@implementation AgentDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置title
    self.title = AGENT_DETAIL_TITLE;
    //添加返回item
    [self addBackItem];
    //初始化UI
    [self createUI];
    //初始化数据
    buttonSelectedIndex = 1;
    self.houseScource = HouseScourceFromSecondHand;
    self.imagesArray = @[@"telephone_icon.png",@"message_icon.png"];
    self.dataArray = (NSMutableArray *)@[@"1",@"1",@"1",@"1",@"1",@"1",@"1"];
    // Do any additional setup after loading the view.
}

#pragma mark 创建UI
//创建UI
- (void)createUI
{
    [self addTableViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) tableType:UITableViewStyleGrouped tableDelegate:self];
    self.table.backgroundColor = WHITE_COLOR;
    self.table.separatorColor = AGENT_DETAIL_LINE_COLOR;
}


#pragma mark 设置分区表头
- (void)settableViewHeader
{
    if (!headerImageView)
    {
        headerImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AGENT_DETAIL_HEADER_HEIGHT) placeholderImage:nil];
        headerImageView.userInteractionEnabled = YES;
        headerImageView.backgroundColor = [UIColor clearColor];
        
        UIImageView *imageViewLine = [CreateViewTool createImageViewWithFrame:CGRectMake(0, -10, SCREEN_WIDTH, .5) placeholderImage:nil];
        imageViewLine.backgroundColor = AGENT_DETAIL_LINE_COLOR;
        [headerImageView addSubview:imageViewLine];
        
        NSArray *array = @[@"二手房",@"租房"];
        
        for (int i = 0; i < 2; i++)
        {
            UIButton *button = [CreateViewTool createButtonWithFrame:CGRectMake(i * SCREEN_WIDTH/2, -5, SCREEN_WIDTH/2, headerImageView.frame.size.height) buttonImage:nil selectorName:@"houseTypeButtonPressed:" tagDelegate:self];
            button.tag = 1 + i;
            [button setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
            [button setTitleColor:AGENT_DETAIL_TYPE_COLOR forState:UIControlStateNormal];
            [button setTitleColor:APP_MAIN_COLOR forState:UIControlStateSelected];
            button.titleLabel.font = AGENT_DETAIL_FONT;
            [headerImageView addSubview:button];
            
            if (i == 0)
            {
                UIImageView *imageViewLine1 = [CreateViewTool createImageViewWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, .5, headerImageView.frame.size.height - 5) placeholderImage:nil];
                imageViewLine1.backgroundColor = AGENT_DETAIL_LINE_COLOR;
                [headerImageView addSubview:imageViewLine1];
            }
        }
      
    }
    UIButton *button = (UIButton *)[headerImageView viewWithTag:buttonSelectedIndex];
    button.selected = YES;
}


#pragma mark 切换房源响应事件

- (void)houseTypeButtonPressed:(UIButton *)sender
{
    buttonSelectedIndex = (int)sender.tag;
    sender.selected = YES;
    UIButton *button = (UIButton *)[headerImageView viewWithTag:(sender.tag == 1) ? 2 : 1];
    button.selected = NO;
    self.houseScource = (sender.tag == 1) ? HouseScourceFromSecondHand : HouseScourceFromRental;
    [self.table reloadData];
}

#pragma mark - tableView代理

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.1;
    }
    return AGENT_DETAIL_HEADER_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return nil;
    }
    [self settableViewHeader];
    return headerImageView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 3;
    }
    else if (section == 1)
    {
        return [self.dataArray count];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            return AGENT_LIST_HEIGHT;
        }
    }
    else if (indexPath.section == 1)
    {
        return HOUSE_LIST_HEIGHT;
    }
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *agentCellID = @"AgentDetailCellID";
    static NSString *rentalHouseCellID = @"RentalHouseCellID";
    static NSString *secondHouseCellID = @"SecondhandHouseCellID";
    
    UITableViewCell *cell ;
    
    if (indexPath.section == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:agentCellID];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:agentCellID];
            cell.backgroundColor = WHITE_COLOR;
            cell.imageView.transform = CGAffineTransformScale(cell.imageView.transform, 0.5, 0.5);
            cell.separatorInset = UIEdgeInsetsZero;
        }
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        NSString *textString = @"";
        NSString *detailTextString = @"";
        if (indexPath.row == 0)
        {
            textString = @"你大爷";
            detailTextString = @"积分 1234";
            cell.textLabel.textColor = AGENT_DETAIL_NAME_COLOR;
            cell.detailTextLabel.textColor = AGENT_DETAIL_SCORE_COLOR;
            [cell.imageView setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"agent_icon_default.png"]];
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            textString = (indexPath.row == 1) ? @"电话: 18888888888" : @"累计评论(88)";
            detailTextString = @"";
            cell.textLabel.font = AGENT_DETAIL_FONT;
            cell.textLabel.textColor = AGENT_DETAIL_FONT_COLOR;
            cell.imageView.image = [UIImage imageNamed:[self.imagesArray objectAtIndex:indexPath.row - 1]];
        }
        
        cell.textLabel.text = textString;
        cell.detailTextLabel.text = detailTextString;

    }
    else if (indexPath.section == 1)
    {
        if (HouseScourceFromSecondHand == self.houseScource)
        {
            cell = (SecondHandHouseListCell *)[tableView dequeueReusableCellWithIdentifier:secondHouseCellID];
            if (!cell)
            {
                cell = [[SecondHandHouseListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:secondHouseCellID];
                cell.backgroundColor = [UIColor whiteColor];
                cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
                if (SCREEN_WIDTH > 320.0)
                {
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
            }
            //@"http://b.pic1.ajkimg.com/display/xinfang/51255643cbafacad2f37506a86e1ccae/245x184c.jpg"
            [(SecondHandHouseListCell *)cell setCellImageWithUrl:@"" titleText:@"业主直租核心地段超值两房急租" localText:@"宝安西乡" parkText:@"白金假日" priceText:@"125万" typeText:@"两房一厅" sizeText:@"43平米" advantage1Text:@"学位房" advantage2Text:@"朝南" advantage3Text:@"南北通风"];
            
        }
        else if (HouseScourceFromRental == self.houseScource)
        {
            cell = (RentalHouseListCell *)[tableView dequeueReusableCellWithIdentifier:rentalHouseCellID];
            if (!cell)
            {
                cell = [[RentalHouseListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rentalHouseCellID];
                cell.backgroundColor = [UIColor whiteColor];
                cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
                if (SCREEN_WIDTH > 320.0)
                {
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
            }
            //@"http://b.pic1.ajkimg.com/display/xinfang/51255643cbafacad2f37506a86e1ccae/245x184c.jpg"
            [(RentalHouseListCell *)cell setCellImageWithUrl:@"" titleText:@"业主直租核心地段超值两房急租" localText:@"宝安西乡" parkText:@"财富港" timeText:@"20分钟前" typeText:@"2室1厅" sizeText:@"75平米" priceText:@"2900元"];
        }
    }
    
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
