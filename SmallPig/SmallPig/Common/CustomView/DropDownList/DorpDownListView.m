//
//  DorpDownListView.m
//  SmallPig
//
//  Created by chenlei on 14/11/26.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//


//行高
#define ROW_HEIGHT                  44.0
//下方空白区域
#define BOTTOM_Height               44.0
//#define LEFT_TABLE_WIDTH          120.0
#define LEFT_TABLE_COLOR            RGB(38.0, 38.0, 38.0)
#define RIGHT_TABLE_COLOR           RGB(31.0, 31.0, 31.0)
#define RIGHT_TABLE_SELECTED_COLOR  RGB(29.0, 29.0, 29.0)

#import "DorpDownListView.h"

@interface DorpDownListView()
{
    UIView *bgView;
    int leftSelectindex;
    int rightSelectindex;
}
@property (nonatomic, strong) NSString *showName1;
@property (nonatomic, strong) NSString *showName2;
@end

@implementation DorpDownListView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //添加黑色背景
        bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        bgView.backgroundColor = [UIColor colorWithRed:.0 green:.0 blue:.0 alpha:.5];
        [self addSubview:bgView];
        leftSelectindex = 0;
        rightSelectindex = 0;
        self.showName = @"";
    }
    return self;
}

//设置数据
- (void)setListViewWithColumnArray:(NSArray *)array
{
    if (array)
    {
        self.columnArray = array;
        if ([self.columnArray  count] > 0)
        {
            [self createTableView];
        }
    }
    
}

//创建表视图
- (void)createTableView
{

    float height = self.frame.size.height - BOTTOM_Height;
    
    for (int i = 0; i < 2; i++)
    {
        float width = self.frame.size.width;
        width = (i == 0) ? self.frame.size.width : self.frame.size.width/2;
        float start_x = (i == 0) ? 0 : self.frame.size.width/2;
        UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(start_x, 0, width, height) style:UITableViewStylePlain];
        table.delegate =self;
        table.dataSource = self;
        table.tag = i + 1;
        table.backgroundColor = (i == 0) ? LEFT_TABLE_COLOR : RIGHT_TABLE_COLOR;
        table.bounces = NO;
        table.showsVerticalScrollIndicator = NO;
        table.separatorColor = LIFT_SIDE_SEPLINE_COLOR;
        table.separatorInset = UIEdgeInsetsZero;
        [self addSubview:table];
        if (i == 1)
        {
            table.hidden = YES;
        }
        [table reloadData];
    }

}

#pragma mark 选择行后刷新视图
- (void)reloadTableViewDataWithIndex:(int)index
{
    UITableView *table1 = (UITableView *)[self viewWithTag:1];
    UITableView *table2 = (UITableView *)[self viewWithTag:2];
    float width = table1.frame.size.width;
    if (!self.columnListArray)
    {
        table2.hidden = YES;
        width = self.frame.size.width;
    }
    else
    {
        width = self.frame.size.width/2;
        table2.hidden = NO;
    }
    if (index == 0)
    {
        self.columnListArray = nil;
        table2.hidden = YES;
        table2.hidden = YES;
        width = self.frame.size.width;
        leftSelectindex = 0;
        rightSelectindex = 0;
        self.showName1 = nil;
        self.showName2 = nil;
        self.showName = nil;
    }
    table1.frame = CGRectMake(0, 0, width, table1.frame.size.height);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(dorpDownListView:selectedColunmItem:selectedRowItem:)] && !self.columnListArray && index != 0)
    {
        [self.delegate dorpDownListView:self selectedColunmItem:leftSelectindex selectedRowItem:rightSelectindex];
    }
    [table1 reloadData];
    [table2 reloadData];
}


#pragma mark TableViewDelegate & TableViewDataSource
//表代理
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    long count = (tableView.tag == 1) ? ([self.columnArray count] + 1) : ([self.columnListArray count] + 1);
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"DorpDownListViewCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView  dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    UIImageView *cellBgView = [CreateViewTool createImageViewWithFrame:cell.frame placeholderImage:nil];
    cellBgView.backgroundColor = LEFT_TABLE_COLOR;
    UIImageView *cellSelectedBgView = [CreateViewTool createImageViewWithFrame:cell.frame placeholderImage:nil];
    cellSelectedBgView.backgroundColor = RIGHT_TABLE_COLOR;
    UIImageView *rightCellSelectedBgView = [CreateViewTool createImageViewWithFrame:cell.frame placeholderImage:nil];
    rightCellSelectedBgView.backgroundColor = RIGHT_TABLE_SELECTED_COLOR;
    
    cell.backgroundView = (tableView.tag == 1) ? cellBgView : cellSelectedBgView;
    cell.selectedBackgroundView =  (tableView.tag == 1) ? cellSelectedBgView : rightCellSelectedBgView;
    
    int selectIndex = (tableView.tag == 1) ? leftSelectindex : rightSelectindex;
    NSArray *dataArray = (tableView.tag == 1) ? self.columnArray : self.columnListArray;
    if (selectIndex == indexPath.row)
    {
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    if (dataArray && [dataArray count] >= indexPath.row)
    {
        NSString *showName = @"";
        if (indexPath.row == 0)
        {
            showName = @"不限";
        }
        else
        {
            NSDictionary *rowDic = dataArray[indexPath.row - 1];
            showName = rowDic[@"showName"];
            showName = (showName) ? showName : @"";
        }
        cell.textLabel.font = FONT(15.0);
        cell.textLabel.text = showName;
        cell.textLabel.textColor =  (selectIndex == indexPath.row) ? APP_MAIN_COLOR : WHITE_COLOR;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (tableView.tag == 2)
//    {
//        [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    }
    if (tableView.tag == 2)
    {
        if (rightSelectindex == (int)indexPath.row && rightSelectindex != 0)
        {
            return;
        }
        rightSelectindex = (int)indexPath.row;
        if (indexPath.row == 0)
        {
            //return;
            self.showName2 = nil;
        }
        else
        {
            NSDictionary *rowDic = self.columnListArray[indexPath.row - 1];
            NSLog(@"self.columnListArray====%@",rowDic[@"showName"]);
            self.showName2 = rowDic[@"showName"];
        }
    }
    else if (tableView.tag == 1)
    {
        if (leftSelectindex == (int)indexPath.row && leftSelectindex != 0)
        {
            return;
        }
        leftSelectindex = (int)indexPath.row;
        rightSelectindex = 0;
        if (indexPath.row == 0)
        {
            self.columnListArray = nil;
            self.showName1 = nil;
            self.showName2 = nil;
        }
        else
        {
            NSDictionary *rowDic = self.columnArray[indexPath.row - 1];
            self.columnListArray = rowDic[@"children"];
            if ([self.columnListArray count] == 0)
            {
                self.columnListArray = nil;
            }
            self.showName1 = rowDic[@"showName"];
        }
    }
    
    if (!self.showName1)
    {
        self.showName = nil;
    }
    else if(self.showName2)
    {
        self.showName = self.showName2;
    }
    else
    {
        self.showName = self.showName1;
    }
    
    [self reloadTableViewDataWithIndex:1];
    
    if (tableView.tag == 2)
    {
        //选择结束
        if (self.delegate && [self.delegate respondsToSelector:@selector(dorpDownListView:selectedColunmItem:selectedRowItem:)])
        {
            [self.delegate dorpDownListView:self selectedColunmItem:leftSelectindex selectedRowItem:rightSelectindex];
        }
    }
}

@end
