//
//  HouseLabelsView.m
//  SmallPig
//
//  Created by clei on 15/3/11.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "HouseLabelsView.h"

#define SPACE_X  10.0
#define SPACE_Y  10.0
#define ADD_X    10.0
#define ADD_Y    5.0

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
    titleLabel = [CreateViewTool  createLabelWithFrame:CGRectMake(SPACE_X, SPACE_Y, self.frame.size.width - 2 * SPACE_X, self.frame.size.height) textString:@"房源亮点" textColor:[UIColor blackColor] textFont:FONT(16.0)];
}

@end
