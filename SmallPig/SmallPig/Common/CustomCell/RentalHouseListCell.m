//
//  HouseListCell.m
//  SmallPig
//
//  Created by chenlei on 14/11/26.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#define ROW_HEIGHT 100.0

#import "RentalHouseListCell.h"
#import "CreateViewTool.h"

@interface RentalHouseListCell()
{
    float start_x;
    float start_y;
}

@property(nonatomic, retain) UIImageView *houseImageView;
@property(nonatomic, retain) UILabel *titleLabel;
@property(nonatomic, retain) UILabel *localLabel;
@property(nonatomic, retain) UILabel *parkLabel;
@property(nonatomic, retain) UILabel *typeLabel;
@property(nonatomic, retain) UILabel *sizeLabel;
@property(nonatomic, retain) UILabel *timeLabel;
@property(nonatomic, retain) UILabel *priceLabel;

@end

@implementation RentalHouseListCell

- (void)awakeFromNib
{
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {

    }
    return self;
}

#pragma mark 添加UI
//添加UI
- (void)createUI
{
    start_x = 15.0;
    [self addHouseImageView];
}

//添加图片控件
- (void)addHouseImageView
{
    UIImage *defaultImage = [UIImage imageNamed:@"house_image_default.png"];
    _houseImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(start_x, (ROW_HEIGHT - defaultImage.size.height/2)/2, defaultImage.size.width/2, defaultImage.size.height/2) placeholderImage:defaultImage];
    [CommonTool clipView:self.houseImageView withCornerRadius:5.0];
    [self.contentView addSubview:_houseImageView];
    start_y = (self.frame.size.height - defaultImage.size.height/2)/2;
    start_x += _houseImageView.frame.size.width/2 +15.0;
}

//添加各种标签
- (void)addLabels
{
    //_titleLabel = [CreateViewTool createLabelWithFrame:CGRectMake(start_x, start_y, self.frame.size.width - start_x - 20.0, <#CGFloat height#>) textString:@"" textColor:HOUSE_LIST_TITLE_COLOR textFont:<#(UIFont *)#>];
}


- (void)drawRect:(CGRect)rect
{
    //初始化视图
    [self createUI];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
