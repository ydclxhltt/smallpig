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
    int type;
}
@property (nonatomic, strong) NSArray *titleArray;
@end

@implementation InformAgainstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    type = 1;
    //设置title
    if ([SmallPigApplication shareInstance].memberType == 0)
    {
        self.title = @"我的举报";
    }
    else
    {
        [self setTitleViewWithArray:@[@"我的举报",@"举报我的"]];
    }
    //添加返回item
    [self addBackItem];
    //初始化数据
    self.titleArray = @[@"标题:",@"举报理由:",@"处理结果:"];
    //初始化UI
    [self createUI];
    //获取数据
    [self getInformListWithType:type];
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
    [self addTableView];
}

- (void)addTableView
{
    [self addTableViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) tableType:UITableViewStyleGrouped tableDelegate:self];
}


#pragma mark 按钮事件
- (void)buttonPressed:(UIButton *)sender
{
    [super buttonPressed:sender];
    if (type == (int)sender.tag)
    {
        return;
    }
    currentPage = 1;
    type = (int)sender.tag;
    self.dataArray = nil;
    [self getInformListWithType:type];
}


#pragma mark 获取数据
- (void)getInformListWithType:(int)requestType
{
    [SVProgressHUD showWithStatus:LOADING_DEFAULT];
    NSString *userID = [[SmallPigApplication shareInstance] userID];
    __weak typeof(self) weakSelf = self;
    NSDictionary *requestDic = @{@"queryBean.pageSize":@(10),@"queryBean.pageNo":@(currentPage),@"queryBean.params.publishRoom_publisher_id_long":userID};
    if (requestType == 1)
    {
        requestDic = @{@"queryBean.pageSize":@(10),@"queryBean.pageNo":@(currentPage)};
    }
    RequestTool *request = [[RequestTool alloc] init];
    [request requestWithUrl:INFORMED_LIST_URL requestParamas:requestDic requestType:RequestTypeAsynchronous
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
    [self getInformListWithType:type];
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *rowDic = self.dataArray[section];
    NSString *time = rowDic[@"createDate"];
    time = (time) ? time : @"";
    time = [SmallPigTool formatTimeWithString:time];
    return time;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  44.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titleArray count];
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
    NSDictionary *rowDic = self.dataArray[indexPath.section];
    NSString *title = rowDic[@"publishRoom"][@"title"];
    title = (title) ? title : @"";
    NSString *content = rowDic[@"content"];
    content = (content) ? content : @"";
    int status = [rowDic[@"complaintStatus"] intValue];
    titleLabel.text = self.titleArray[indexPath.row];

    if (indexPath.row == 0)
    {
        contentLable.text = title;
        contentLable.textColor = [UIColor grayColor];
    }
    if (indexPath.row == 1)
    {
        contentLable.text = content;
        contentLable.textColor = [UIColor grayColor];
    }
    if (indexPath.row == 2)
    {
        NSString *statusStr = @"";
        if (status == 0)
        {
            statusStr = @"已撤销";
        }
        if (status == 1)
        {
            statusStr = @"未处理";
        }
        if (status == 2)
        {
            statusStr = @"处理中";
        }
        if (status == 3)
        {
            statusStr = @"已处理";
        }
        contentLable.text = statusStr;
        contentLable.textColor = (status == 3) ? [UIColor grayColor] : RGB(245.0, 0.0, 8.0);
    }
    
    
    return cell;
}



@end
