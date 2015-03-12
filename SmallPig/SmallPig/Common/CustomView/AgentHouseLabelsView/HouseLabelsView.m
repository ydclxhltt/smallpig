//
//  HouseLabelsView.m
//  SmallPig
//
//  Created by clei on 15/3/11.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "HouseLabelsView.h"

#define SPACE_X         10.0
#define SPACE_Y         10.0
#define ADD_X           10.0
#define ADD_Y           10.0
#define LABEL_HEIGHT    20.0

@interface HouseLabelsView()
{
    UILabel *titleLabel;
    UIScrollView *scrollView;
}
@end

@implementation HouseLabelsView

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
        //初始化UI
        [self initUI];
    }
    return self;
}

#pragma mark 初始化UI
- (void)initUI
{
    titleLabel = [CreateViewTool  createLabelWithFrame:CGRectMake(SPACE_X, SPACE_Y, self.frame.size.width - 2 * SPACE_X, LABEL_HEIGHT) textString:@"房源亮点" textColor:[UIColor blackColor] textFont:FONT(15.0)];
    [self addSubview:titleLabel];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y + titleLabel.frame.size.height + ADD_Y, titleLabel.frame.size.width, self.frame.size.height - titleLabel.frame.size.height - 2 * SPACE_Y - ADD_Y)];
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = YES;
    scrollView.showsVerticalScrollIndicator = YES;
    [self addSubview:scrollView];
}

#pragma mark 设置数据
- (void)setLabelsWithArray:(NSArray *)array
{
    array = @[@"",@"",@"",@"",@"",@"",@"",@""];
    if (array && [array count] > 0)
    {
        
        int row = ceil([array count]/4);
        
        float labelHeight = (scrollView.frame.size.height - ADD_Y * (row - 1))/row;
        float labelWidth = (scrollView.frame.size.width - ADD_X * 3)/4;
        
        for (int i = 0; i < row; i++)
        {
            int m = ([array count]%4 != 0 && i == row - 1) ? [array count]%4 : 4;
            
            for (int j = 0; j < m; j++)
            {
                UIButton *button = [CreateViewTool createButtonWithFrame:CGRectMake((ADD_X + labelWidth) * j,(ADD_Y + labelHeight) * i , labelWidth, labelHeight) buttonTitle:@"美女云集" titleColor:LABEL_NORMAL_TITLE_COLOR normalBackgroundColor:LABEL_BG_COLOR highlightedBackgroundColor:LABEL_SELECTED_BG_COLOR selectorName:@"labelsButtonPressed:" tagDelegate:self];
                button.titleLabel.font = FONT(12.0);
                [button setTitleColor:LABEL_SELECTED_TITLE_COLOR forState:UIControlStateHighlighted];
                [button setTitleColor:LABEL_SELECTED_TITLE_COLOR forState:UIControlStateSelected];
                [scrollView addSubview:button];
            }
        }
    }
}

@end
