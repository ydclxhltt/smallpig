//
//  HouseListCell.m
//  SmallPig
//
//  Created by chenlei on 14/11/26.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//


#import "RentalHouseListCell.h"
#import "CreateViewTool.h"
#import "CommonHeader.h"

@interface RentalHouseListCell()
{
    float start_x;
    float start_y;
}

@property(nonatomic, strong) UIImageView *houseImageView;
@property(nonatomic, strong) UILabel *titleLabel;

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
        //初始化视图
        [self createUI];
    }
    return self;
}


#pragma mark 添加UI
//添加UI
- (void)createUI
{
    start_x = 15.0;
    [self addHouseImageView];
    [self addLabels];
}

//添加图片控件
- (void)addHouseImageView
{
    UIImage *defaultImage = [UIImage imageNamed:@"house_image_default.png"];
    _houseImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(start_x, (HOUSE_LIST_HEIGHT - defaultImage.size.height/2)/2, defaultImage.size.width/2, defaultImage.size.height/2) placeholderImage:defaultImage];
    [CommonTool clipView:self.houseImageView withCornerRadius:5.0];
    [self.contentView addSubview:_houseImageView];
    start_y = (HOUSE_LIST_HEIGHT - defaultImage.size.height/2)/2;
    start_x += _houseImageView.frame.size.width +15.0;
    if(CURRENT_SCALE > 1)
        start_y = (HOUSE_LIST_HEIGHT - defaultImage.size.height/2)/2 + 5;
}

//添加各种标签
- (void)addLabels
{
    _titleLabel = [CreateViewTool createLabelWithFrame:CGRectMake(start_x, start_y, (self.frame.size.width - start_x - 20.0) * CURRENT_SCALE, 35) textString:@"" textColor:HOUSE_LIST_TITLE_COLOR textFont:HOUSE_LIST_TITLE_FONT];
    _titleLabel.numberOfLines = 2;
    [self.contentView addSubview:_titleLabel];
    
    start_y += _titleLabel.frame.size.height;
    float width = 55 * CURRENT_SCALE;
    for (int j = 0; j < 2; j++)
    {
        for (int i = 0; i < 3; i++)
        {
            UILabel *label = [CreateViewTool createLabelWithFrame:CGRectMake(start_x + (width + 5) * i, start_y + j * (15 + 5), width, 15) textString:@"" textColor:HOUSE_LIST_DETAIL_COLOR textFont:HOUSE_LIST_DETAIL_FONT];
            label.tag = i + 3 * j + 1;
            if (label.tag == 6)
            {
                label.textColor = HOUSE_LIST_PRICE_COLOR;
                label.font = HOUSE_LIST_PRICE_FONT;
            }
            [self.contentView addSubview:label];
        }
    }
}

#pragma mark 设置数据
- (void)setCellImageWithUrl:(NSString *)imageUrl titleText:(NSString *)title localText:(NSString *)local parkText:(NSString *)park timeText:(NSString *)time typeText:(NSString *)type sizeText:(NSString *)size priceText:(NSString *)price
{
    
    self.titleLabel.text = title;
    
    if(imageUrl && ![@"" isEqualToString:imageUrl])
    {
        [self.houseImageView  setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"house_image_default.png"]];
    }
    
    NSArray *array = @[local,park,time,type,size,price];

    for (int i = 0; i < [array count];i++)
    {
        UILabel *label = (UILabel *)[self.contentView viewWithTag:i + 1];
        label.text = [array objectAtIndex:i];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
