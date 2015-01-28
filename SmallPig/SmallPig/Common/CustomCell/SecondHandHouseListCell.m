//
//  SecondHandHouseListCell.m
//  SmallPig
//
//  Created by clei on 14/12/11.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "SecondHandHouseListCell.h"
#import "CreateViewTool.h"
#import "CommonHeader.h"

@interface SecondHandHouseListCell()
{
    float start_x;
    float start_y;
}
@property(nonatomic, retain) UIImageView *houseImageView;
@property(nonatomic, retain) UILabel *titleLabel;
@end

@implementation SecondHandHouseListCell

- (void)awakeFromNib {
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

#pragma mark 创建UI
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
    _titleLabel = [CreateViewTool createLabelWithFrame:CGRectMake(start_x, start_y, self.frame.size.width - start_x - 20.0, 20.0) textString:@"" textColor:HOUSE_LIST_TITLE_COLOR textFont:HOUSE_LIST_TITLE_FONT];
    [self.contentView addSubview:_titleLabel];
    
    start_y += _titleLabel.frame.size.height;
    
    for (int j = 0; j < 3; j++)
    {
        for (int i = 0; i < 3; i++)
        {
            if (i == 2 && j == 1)
            {
                break;
            }
             float width = 55 * CURRENT_SCALE;
            UILabel *label = [CreateViewTool createLabelWithFrame:CGRectMake(start_x + (width + 5) * i, start_y + j * (15 + 5), width, 15) textString:@"" textColor:HOUSE_LIST_DETAIL_COLOR textFont:HOUSE_LIST_DETAIL_FONT];
            label.tag = i + 3 * j + 1;
            
            if (i == 2 && j == 0)
            {
                label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width, 15 * 2);
                label.textAlignment = NSTextAlignmentRight;
                label.textColor = HOUSE_LIST_PRICE_COLOR;
                label.font = HOUSE_LIST_PRICE_FONT;
            }
            
            if (j == 2)
            {
                label.tag = i + 3 * j;
                label.textAlignment = NSTextAlignmentCenter;
                [CommonTool clipView:label withCornerRadius:5.0];
                label.backgroundColor = APP_MAIN_COLOR;
                label.textColor = WHITE_COLOR;
            }
            
            [self.contentView addSubview:label];
        }
    }
}


#pragma mark 设置数据
- (void)setCellImageWithUrl:(NSString *)imageUrl titleText:(NSString *)title localText:(NSString *)local parkText:(NSString *)park priceText:(NSString *)price typeText:(NSString *)type sizeText:(NSString *)size advantage1Text:(NSString *)advantage1 advantage2Text:(NSString *)advantage2 advantage3Text:(NSString *)advantage3
{
    
    self.titleLabel.text = title;
    
    if(imageUrl && ![@"" isEqualToString:imageUrl])
    {
        [self.houseImageView  setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"house_image_default.png"]];
    }
    
    NSArray *array = @[local,park,price,type,size,advantage1,advantage2,advantage3];
    
    for (int i = 0; i < [array count];i++)
    {
        UILabel *label = (UILabel *)[self.contentView viewWithTag:i + 1];
        label.text = [array objectAtIndex:i];
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
