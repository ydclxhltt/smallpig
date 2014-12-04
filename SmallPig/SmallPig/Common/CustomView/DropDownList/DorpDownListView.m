//
//  DorpDownListView.m
//  SmallPig
//
//  Created by chenlei on 14/11/26.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

//屏幕高度
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
//行高
#define ROW_HEIGHT    44.0
//下方空白区域
#define BOTTOM_Height 40.0

#import "DorpDownListView.h"

@interface DorpDownListView()
{
    UIView *bgView;
}
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
            [self createTableViewWithColumn:0];
        }
    }
    
}

//创建表视图
- (void)createTableViewWithColumn:(int)column
{
    if ([self.columnArray count] <= column)
    {
        return;
    }
    NSArray *array = [self.columnArray objectAtIndex:column];
    if (array && [array count] > 0)
    {
        float height = 0.0;
        if (ROW_HEIGHT * [array count] >= self.frame.size.height - BOTTOM_Height)
        {
            height = self.frame.size.height - BOTTOM_Height;
        }
        else
        {
            height = ROW_HEIGHT * [array count];
        }
        UITableView *table = (UITableView *)[self viewWithTag:column + 1];
        if (!table)
        {
            UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(column * SCREEN_WIDTH/[self.columnArray count], 0, SCREEN_WIDTH/[self.columnArray count], height)];
            table.delegate =self;
            table.dataSource = self;
            table.tag = column + 1;
            table.backgroundColor = [UIColor whiteColor];
            [self addSubview:table];
        }
        [table reloadData];
    }
}

#pragma mark TableViewDelegate & TableViewDataSource
//表代理
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.columnArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"DorpDownListViewCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView  dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = @"1";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == [self.columnArray count])
    {
        //选择结束
    }
    else
    {
        [self createTableViewWithColumn:(int)tableView.tag];
    }
}

@end
