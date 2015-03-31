//
//  HouseDetailSeeInfoView.m
//  SmallPig
//
//  Created by clei on 15/1/29.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "HouseDetailSeeInfoView.h"

@interface HouseDetailSeeInfoView()
{
    UILabel *titleLabel;
    UILabel *timeLabel;
    UILabel *seeCountLabel;
    
}
@property (nonatomic ,strong) NSArray *titleArray;
@end

@implementation HouseDetailSeeInfoView

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
        //初始化数据
        self.titleArray = @[@"",@"发布时间: ",@"浏览数: "];
        //初始化UI
        [self createUI];
    }
    return self;
}

#pragma mark 初始化UI
- (void)createUI
{
    [self addLabels];
}

- (void)addLabels
{
    titleLabel = [CreateViewTool createLabelWithFrame:CGRectMake(SEE_SPACE_X, SEE_SPACE_Y, self.frame.size.width - 2 * SEE_SPACE_X, SEE_LABEL_HEIGHT) textString:self.titleArray[0] textColor:HOUSE_DETAIL_TEXT_COLOR textFont:FONT(14.0)];
    titleLabel.tag = 1;
    [self addSubview:titleLabel];
    
    float labelWidth = (self.frame.size.width - 3 * SEE_SPACE_X)/2;
    timeLabel = [CreateViewTool createLabelWithFrame:CGRectMake(SEE_SPACE_X, titleLabel.frame.size.height + titleLabel.frame.origin.y + SEE_SPACE_Y, labelWidth, SEE_LABEL_HEIGHT) textString:self.titleArray[1] textColor:HOUSE_DETAIL_TITLE_COLOR textFont:FONT(14.0)];
    timeLabel.tag = 2;

    [self addSubview:timeLabel];
    
    float start_x = timeLabel.frame.size.width + titleLabel.frame.origin.x + SEE_SPACE_X;
    seeCountLabel = [CreateViewTool createLabelWithFrame:CGRectMake(start_x, timeLabel.frame.origin.y, labelWidth, SEE_LABEL_HEIGHT) textString:self.titleArray[1] textColor:HOUSE_DETAIL_TITLE_COLOR textFont:FONT(14.0)];
    seeCountLabel.tag = 3;
    seeCountLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:seeCountLabel];
}

#pragma mark 设置数据
- (void)setDataWithTitle:(NSString *)title publicTime:(NSString *)time seeCount:(NSString *)count
{
    NSArray *array = @[title,time,count];
    for (int i = 0; i < 3; i++)
    {
        UILabel *label = (UILabel *)[self viewWithTag:i + 1];
        NSString *textString = [NSString stringWithFormat:@"%@%@",self.titleArray[i],array[i]];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:textString];
        [CommonTool makeString:textString toAttributeString:attributedString withString:self.titleArray[i] withTextColor:HOUSE_DETAIL_TITLE_COLOR withTextFont:FONT(14.0)];
        [CommonTool makeString:textString toAttributeString:attributedString withString:array[i] withTextColor:HOUSE_DETAIL_TEXT_COLOR withTextFont:FONT(14.0)];
        label.attributedText = attributedString;
    }
    [self resetFrame];
}

- (void)resetFrame
{
    float height = [CommonTool labelHeightWithTextLabel:titleLabel textFont:titleLabel.font];
    titleLabel.numberOfLines = 0;
    CGRect frame = titleLabel.frame;
    frame.size.height = height;
    titleLabel.frame = frame;
    
    CGRect timeFrame = timeLabel.frame;
    timeFrame.origin.y = titleLabel.frame.origin.y + titleLabel.frame.size.height + SEE_SPACE_Y;
    timeLabel.frame = timeFrame;
    
    CGRect countFrame = seeCountLabel.frame;
    countFrame.origin.y = timeFrame.origin.y;
    seeCountLabel.frame = countFrame;
    
    CGRect selfFrame = self.frame;
    selfFrame.size.height = SEE_SPACE_Y * 3 + height + SEE_LABEL_HEIGHT;
    self.frame = selfFrame;
}

@end
