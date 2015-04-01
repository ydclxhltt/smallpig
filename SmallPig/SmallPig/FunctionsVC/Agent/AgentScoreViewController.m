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
    //添加侧滑item
    [self addBackItem];
    //初始化UI
    [self createUI];
    //获取数据
    [self getScoreList];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //设置不可侧滑
    [self setMainSideCanSwipe:NO];
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
    scoreLabel.attributedText = [self makeAttributedString:[NSString stringWithFormat:@"%d",[SmallPigApplication shareInstance].point]];
    [greenView addSubview:scoreLabel];
    
//    infoLabel = [CreateViewTool createLabelWithFrame:CGRectMake(0, scoreLabel.frame.size.height + scoreLabel.frame.origin.y + ADD_SPACE_Y * scale, SCREEN_WIDTH, 20.0) textString:@"根据您本月积分,可兑现888元" textColor:WHITE_COLOR textFont:FONT(14.0)];
//    infoLabel.textAlignment = NSTextAlignmentCenter;
//    [greenView addSubview:infoLabel];
    
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
    NSMutableAttributedString * text = [[NSMutableAttributedString alloc] initWithString:string];
    NSShadow *shodow = [[NSShadow alloc] init];
    shodow.shadowOffset = CGSizeMake(0, 5.0);
    shodow.shadowBlurRadius = 0.0;
    shodow.shadowColor = [[UIColor grayColor] colorWithAlphaComponent:.4];
    [text addAttributes:@{NSShadowAttributeName:shodow} range:NSMakeRange(0, text.length)];
    return text;
}


#pragma mark 获取数据
- (void)getScoreList
{
    [SVProgressHUD showWithStatus:LOADING_DEFAULT];
    __weak typeof(self) weakSelf = self;
    NSDictionary *requestDic = @{@"queryBean.pageSize":@(10),@"queryBean.pageNo":@(currentPage)};
    RequestTool *request = [[RequestTool alloc] init];
    [request requestWithUrl:MY_SCORE_URL requestParamas:requestDic requestType:RequestTypeAsynchronous
              requestSucess:^(AFHTTPRequestOperation *operation, id responseObj)
     {
         NSLog(@"responseObj====%@",responseObj);
         isCanGetMore = YES;
         NSDictionary *dic = (NSDictionary *)responseObj;
         int sucess = [dic[@"responseMessage"][@"success"] intValue];
         if (sucess == 1)
         {
             [SVProgressHUD showSuccessWithStatus:LOADING_SUCESS];
             [weakSelf setHouseDataWithDictionary:dic];
         }
         else
         {
             if (currentPage > 1)
             {
                 currentPage--;
             }
             [SVProgressHUD showErrorWithStatus:LOADING_FAILURE];
             [weakSelf.table reloadData];
         }
     }
     requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"error====%@",error);
         if (currentPage > 1)
         {
             currentPage--;
         }
         isCanGetMore = YES;
         [SVProgressHUD showErrorWithStatus:LOADING_FAILURE];
         [weakSelf.table reloadData];
     }];
}

#pragma mark 加载更多
- (void)getMoreData
{
    if (!isCanGetMore)
    {
        currentPage--;
        return;
    }
    isCanGetMore = NO;
    [self getScoreList];
}

#pragma mark 设置数据
- (void)setHouseDataWithDictionary:(NSDictionary *)dic
{
    NSArray *array = dic[@"pageBean"][@"data"];
    int pageCount = [dic[@"pageBean"][@"totalPages"] intValue];
    
    if (!self.dataArray)
    {
        if (!array || [array count] == 0)
        {
            [CommonTool addAlertTipWithMessage:@"暂无数据"];
        }
        else
        {
            self.dataArray = [NSMutableArray arrayWithArray:array];
        }
    }
    else
    {
        if (array && [array count] > 0)
            [self.dataArray addObjectsFromArray:array];
    }
    [self.table reloadData];
    
    if (pageCount > currentPage)
    {
        [self addGetMoreView];
    }
    else
    {
        [self removeGetMoreView];
        isCanGetMore = NO;
    }
}


#pragma mark tableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return AGENTCSCORE_HEADER_HEIGHT ;
}

- (NSString *)tableView:(UITableView *)tableView  titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *rowDic = self.dataArray[section];
    NSString *time = rowDic[@"createDate"];
    time = (time) ? time : @"";
    time = [SmallPigTool formatTimeWithString:time];
    return time;
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
    return AGENTCSCORE_LIST_HEIGHT;
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
    NSDictionary *rowDic = self.dataArray[indexPath.section];
    NSString *channel = rowDic[@"channel"];
    channel = (channel) ? channel : @"";
    NSString *point = [NSString stringWithFormat:@"%@",rowDic[@"point"]];
    point = (point) ? point : @"";
    [cell setDataWithLeftText:channel rightText:point];
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
