//
//  RoomListCell.m
//  SmallPig
//
//  Created by chenlei on 14/11/26.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "RoomListCell.h"
#import "CreateViewTool.h"

@interface RoomListCell()
{
    UIImageView *imageView;
}
@end

@implementation RoomListCell

- (void)awakeFromNib
{
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        imageView = [CreateViewTool createImageViewWithFrame:CGRectMake(5, 5, 60 , 45) placeholderImage:[UIImage imageNamed:@"room_pic_default"]];
        [self.contentView addSubview:imageView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
