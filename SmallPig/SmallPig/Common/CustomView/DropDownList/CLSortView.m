//
//  CLSortView.m
//  SmallPig
//
//  Created by clei on 15/4/15.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "CLSortView.h"
#import "DorpDownListView.h"

#define BUTTONBAR_HEIGHT   40.0
#define BUTTONBAR_COLOR    RGB(19.0,19.0,19.0)

@interface CLSortView ()<DorpDownListViewDelegate>
@property (nonatomic, strong) DorpDownListView *dorpView;
@end

@implementation CLSortView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSMutableArray *)array
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //_titleDic = [[NSMutableDictionary alloc] init];
        self.clipsToBounds = YES;
        self.selectedIndex = 0;
        self.titleArray = array;
        [self initView];
    }
    return self;
}

#pragma mark 初始化UI
- (void)initView
{
    if (!self.titleArray || [self.titleArray count] == 0)
    {
        return;
    }
    
    float width = self.frame.size.width/[self.titleArray count];
    
    for (int i = 0; i < [self.titleArray count]; i ++)
    {
        UIButton *button = [CreateViewTool createButtonWithFrame:CGRectMake(i * width, 0, width, BUTTONBAR_HEIGHT) buttonTitle:self.titleArray[i] titleColor:WHITE_COLOR normalBackgroundColor:BUTTONBAR_COLOR highlightedBackgroundColor:BUTTONBAR_COLOR selectorName:@"buttonBarPressed:" tagDelegate:self];
        button.titleLabel.font = FONT(14.0);
        [button setTitleColor:APP_MAIN_COLOR forState:UIControlStateSelected];
        button.tag = i + 1;
        [self addSubview:button];
        
        UIImageView *lineView = [CreateViewTool createImageViewWithFrame:CGRectMake(i * width, 2.0, 1.0, BUTTONBAR_HEIGHT - 4.0) placeholderImage:nil];
        lineView.backgroundColor = RGB(38.0, 38.0, 38.0);
        [self addSubview:lineView];
    }
    if (self.dataArray)
    {
        [self initSortListView];
    }
    
}

- (void)initSortListView
{
    
    if (!_dorpView && self.dataArray)
    {
        _dorpView = [[DorpDownListView alloc] initWithFrame:CGRectMake(0, BUTTONBAR_HEIGHT, self.frame.size.width, SCREEN_HEIGHT - self.frame.origin.y - BUTTONBAR_HEIGHT)];
        _dorpView.delegate = self;
        [_dorpView setListViewWithColumnArray:self.dataArray];
        [self addSubview:_dorpView];
    }
    else
    {
        _dorpView.columnArray = self.dataArray;
        [_dorpView reloadTableViewDataWithIndex:0];
    }

}

#pragma mark 设置dataArray
- (void)setDataArray:(NSArray *)dataArray
{
    if (dataArray)
    {
        _dataArray = dataArray;
        [self initSortListView];
    }
}


#pragma mark 筛选按钮
- (void)buttonBarPressed:(UIButton *)sender
{
    CGRect frame = self.frame;
    for (int i = 1; i < 5; i++)
    {
        UIButton *button = (UIButton *)[self viewWithTag:i];
        button.selected = NO;
    }
    if (self.selectedIndex == sender.tag)
    {
        sender.selected = NO;
        frame.size.height = BUTTONBAR_HEIGHT;
        self.selectedIndex = 0;
    }
    else
    {
         sender.selected = YES;
        frame.size.height = SCREEN_HEIGHT - frame.origin.y;
        //if (self.delegate && [self.delegate performSelector:@selector(sortView:buttonBarPressedIndex:)])
        {
            [self.delegate sortView:self buttonBarPressedIndex:(int)sender.tag - 1];
        }
        self.selectedIndex = (int)sender.tag;
    }
    
    [UIView animateWithDuration:.3 animations:^
    {
        self.frame = frame;
    }];
    
}

#pragma mark dorpListViewDelegate

- (void)dorpDownListView:(DorpDownListView *)dorpDownListView selectedColunmItem:(int)colunm selectedRowItem:(int)row
{
    //if (self.delegate && [self.delegate performSelector:@selector(sortView:sortViewListItemPressedColumn:sortViewListItemPressedRow:)])
    {
        [self.delegate sortView:self sortViewListItemPressedColumn:colunm sortViewListItemPressedRow:row];
    }
    UIButton *button = (UIButton *)[self viewWithTag:self.selectedIndex];
    NSString *title = ([self.dorpView.showName isEqualToString:@"不限"] || !self.dorpView.showName) ? self.titleArray[self.selectedIndex - 1] : self.dorpView.showName;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateSelected];
    
    self.selectedIndex = 0;
    button.selected = NO;
    CGRect frame = self.frame;
    frame.size.height = BUTTONBAR_HEIGHT;
    [UIView animateWithDuration:.3 animations:^
     {
         self.frame = frame;
     }];
}

@end
