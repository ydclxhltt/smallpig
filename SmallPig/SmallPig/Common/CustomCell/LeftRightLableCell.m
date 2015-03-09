//
//  LeftRightLableCell.m
//  SmallPig
//
//  Created by clei on 15/1/30.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "LeftRightLableCell.h"

#define SPACE_X          10.0
#define ADD_SPACE_X      20.0
#define ARROW_WIDTH      30.0
#define SELF_HEIGHT      50.0
#define TIME_LABEL_WIDTH 120.0


@interface LeftRightLableCell()
{
    UILabel *leftLabel;
    UILabel *rightLabel;
}
@end

@implementation LeftRightLableCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
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
    rightLabel = [CreateViewTool createLabelWithFrame:CGRectMake(self.frame.size.width - ARROW_WIDTH - TIME_LABEL_WIDTH, 0, TIME_LABEL_WIDTH, SELF_HEIGHT) textString:@"" textColor:HOUSE_DETAIL_TITLE_COLOR textFont:FONT(14.0)];
    rightLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:rightLabel];
    
    leftLabel = [CreateViewTool createLabelWithFrame:CGRectMake(SPACE_X, 0, rightLabel.frame.origin.x - ADD_SPACE_X * CURRENT_SCALE, SELF_HEIGHT) textString:@"" textColor:HOUSE_DETAIL_TEXT_COLOR textFont:FONT(15.0)];
    [self.contentView addSubview:leftLabel];
}

#pragma mark 设置数据
- (void)setDataWithLeftText:(NSString *)left rightText:(NSString *)right
{
    leftLabel.text = (left) ? left : @"";
    rightLabel.text = (right) ? right : @"";
}

- (void)setLeftColor:(UIColor *)l_color rightColor:(UIColor *)r_color
{
    if (l_color)
        leftLabel.textColor = l_color;
    if (r_color)
        rightLabel.textColor = r_color;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
