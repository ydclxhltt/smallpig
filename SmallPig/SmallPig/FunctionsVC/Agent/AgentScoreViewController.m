//
//  AgentScoreViewController.m
//  SmallPig
//
//  Created by clei on 15/2/2.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "AgentScoreViewController.h"
#import "LeftRightLableCell.h"

#define AGENTCSCORE_LIST_HEIGHT   50.0
#define AGENTCSCORE_HEADER_HEIGHT 15.0
#define SPACE_Y                   110.0
#define ADD_SPACE_X               0.0
#define ADD_SPACE_Y               15.0
#define TIP_LABEL_WH              35.0
#define SCORE_LABEL_WIDTH         140.0
#define SCORE_LABEL_HEIGHT        50.0

@interface AgentScoreViewController ()
{
    UILabel *scoreLabel;
    UILabel *infoLabel;
}
@end

@implementation AgentScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置title
    self.title = AGENT_SCORE_TITLE;
    //初始化数据
    self.dataArray = (NSMutableArray *)@[@[@"完成房租预定",@"积分+50"],@[@"完成房租预定",@"积分+50"],@[@"完成房租预定",@"积分+50"],@[@"完成房租预定",@"积分+50"],@[@"完成房租预定",@"积分+50"],@[@"完成房租预定",@"积分+50"]];
    //添加侧滑item
    [self addBackItem];
    //初始化UI
    [self createUI];
    // Do any additional setup after loading the view.
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
    
    float space_x = (SCREEN_WIDTH - (ADD_SPACE_X + TIP_LABEL_WH + SCORE_LABEL_WIDTH) * scale)/2;
    
    UILabel *tipLable = [CreateViewTool createLabelWithFrame:CGRectMake(space_x, SPACE_Y * scale, TIP_LABEL_WH, TIP_LABEL_WH) textString:@"本月新增" textColor:WHITE_COLOR textFont:FONT(14.0)];
    tipLable.numberOfLines = 2;
    tipLable.textAlignment = NSTextAlignmentCenter;
    tipLable.contentMode = UIViewContentModeBottom;
    [greenView addSubview:tipLable];
    
    float height = SCORE_LABEL_HEIGHT * scale;
    float width = SCORE_LABEL_WIDTH * scale;
    scoreLabel = [CreateViewTool  createLabelWithFrame:CGRectMake(tipLable.frame.origin.x + tipLable.frame.size.width + ADD_SPACE_X * scale, tipLable.frame.origin.y - (height - tipLable.frame.size.height), width, height) textString:@"" textColor:WHITE_COLOR textFont:FONT(60.0)];
    scoreLabel.textAlignment = NSTextAlignmentCenter;
    scoreLabel.contentMode = UIViewContentModeBottom;
    scoreLabel.attributedText = [self makeAttributedString:@"1234"];
    [greenView addSubview:scoreLabel];
    
    infoLabel = [CreateViewTool createLabelWithFrame:CGRectMake(0, scoreLabel.frame.size.height + scoreLabel.frame.origin.y + ADD_SPACE_Y * scale, SCREEN_WIDTH, 20.0) textString:@"根据您本月积分,可兑现888元" textColor:WHITE_COLOR textFont:FONT(14.0)];
    infoLabel.textAlignment = NSTextAlignmentCenter;
    [greenView addSubview:infoLabel];
    
    startHeight = greenView.frame.origin.y + greenView.frame.size.height;
}

- (void)addTableView
{
    [self addTableViewWithFrame:CGRectMake(0, startHeight, SCREEN_WIDTH, SCREEN_HEIGHT - startHeight) tableType:UITableViewStyleGrouped tableDelegate:self];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,AGENTCSCORE_HEADER_HEIGHT * scale)];
    self.table.tableHeaderView = view;
}



- (NSMutableAttributedString *)makeAttributedString:(NSString *)string
{
    NSMutableAttributedString * text = [[NSMutableAttributedString alloc] initWithString:@"1234"];
    NSShadow *shodow = [[NSShadow alloc] init];
    shodow.shadowOffset = CGSizeMake(0, 5.0);
    shodow.shadowBlurRadius = 0.0;
    shodow.shadowColor = [[UIColor grayColor] colorWithAlphaComponent:.4];
    [text addAttributes:@{NSShadowAttributeName:shodow} range:NSMakeRange(0, text.length)];
    return text;
}


#pragma mark tableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return AGENTCSCORE_HEADER_HEIGHT * scale;
}

- (NSString *)tableView:(UITableView *)tableView  titleForHeaderInSection:(NSInteger)section
{
    return @"2015-02-02";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIImageView *imageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, .00001) placeholderImage:nil];
//    return imageView;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return AGENTCSCORE_LIST_HEIGHT * scale;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    LeftRightLableCell *cell = (LeftRightLableCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[LeftRightLableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    [cell setDataWithLeftText:self.dataArray[indexPath.section][0] rightText:self.dataArray[indexPath.section][1]];
    [cell setLeftColor:nil rightColor:APP_MAIN_COLOR];
    return cell;
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
