//
//  HouseLabelsView.m
//  SmallPig
//
//  Created by clei on 15/3/11.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "HouseLabelsView.h"



@interface HouseLabelsView()
{
    UILabel *titleLabel;
    UIScrollView *scrollView;
}
@property(nonatomic, strong) NSString *title;
@end

@implementation HouseLabelsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame  LablesTitle:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.title = title;
        //初始化UI
        [self initUI];
    }
    return self;
}

#pragma mark 初始化UI
- (void)initUI
{
    titleLabel = [CreateViewTool  createLabelWithFrame:CGRectMake(SPACE_X, SPACE_Y, self.frame.size.width - 2 * SPACE_X, LABEL_HEIGHT) textString:self.title textColor:[UIColor blackColor] textFont:FONT(15.0)];
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
    if (array && [array count] > 0)
    {
        
        int row = ceil([array count]/4);
        
        float labelHeight = (scrollView.frame.size.height - ADD_Y * (row - 1))/row;
        NSLog(@"self.frame.size.height===%f===labelHeight===%f===row==%d",self.frame.size.height,labelHeight,row);
        float labelWidth = (scrollView.frame.size.width - ADD_X * 3)/4;
        
        for (int i = 0; i < row; i++)
        {
            int m = ([array count]%4 != 0 && i == row - 1) ? [array count]%4 : 4;
            
            for (int j = 0; j < m; j++)
            {
                int index = i * 4 + j + 1;
                NSDictionary *dataDic = array[index];
                UIButton *button = (UIButton *)[scrollView viewWithTag:index];
                if (!button)
                {
                    button = [CreateViewTool createButtonWithFrame:CGRectMake((ADD_X + labelWidth) * j,(ADD_Y + labelHeight) * i , labelWidth, labelHeight) buttonTitle:dataDic[@"showName"] titleColor:LABEL_NORMAL_TITLE_COLOR normalBackgroundColor:LABEL_BG_COLOR highlightedBackgroundColor:LABEL_SELECTED_BG_COLOR selectorName:@"labelsButtonPressed:" tagDelegate:self];
                    button.tag =  index;
                    button.titleLabel.font = FONT(12.0);
                    [button setTitleColor:LABEL_SELECTED_TITLE_COLOR forState:UIControlStateHighlighted];
                    [button setTitleColor:LABEL_SELECTED_TITLE_COLOR forState:UIControlStateSelected];

                }
                [scrollView addSubview:button];
                if (self.selectedLabelArray)
                {
                    if ([self.selectedLabelArray indexOfObject:[NSString stringWithFormat:@"%d",(int)button.tag]] != NSNotFound)
                    {
                        button.selected = YES;
                    }
                    else
                    {
                        button.selected = NO;
                    }
                }
            }
        }
    }
}

#pragma mark
- (void)labelsButtonPressed:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (!self.selectedLabelArray)
    {
        self.selectedLabelArray = [[NSMutableArray alloc] init];
    }
    if (sender.selected)
    {
        [self.selectedLabelArray addObject:[NSString stringWithFormat:@"%d",(int)sender.tag]];
    }
    else
    {
        [self.selectedLabelArray removeObject:[NSString stringWithFormat:@"%d",(int)sender.tag]];
    }
}


@end
