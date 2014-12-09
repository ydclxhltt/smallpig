//
//  AgentRankListCell.m
//  SmallPig
//
//  Created by clei on 14/12/9.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "AgentRankListCell.h"
#import "CreateViewTool.h"
#import "CommonHeader.h"

@interface AgentRankListCell()
@property(nonatomic, retain) UILabel *rankLabel;
@property(nonatomic, retain) UIImageView *iconImageView;
@property(nonatomic, retain) UILabel *namelabel;
@property(nonatomic, retain) UILabel *scoreLabel;
@end

@implementation AgentRankListCell

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
    float start_x = 15.0;
    _rankLabel = [CreateViewTool createLabelWithFrame:CGRectMake(start_x, (AGENT_LIST_HEIGHT - 20)/2, 20, 20) textString:@"" textColor:REGISTER_TITLE_COLOR textFont:AGENT_RANK_FONT];
    [self.contentView addSubview:_rankLabel];
    
    start_x += 15.0 + _rankLabel.frame.size.width;
    
    UIImage *agentDefaultImage = [UIImage imageNamed:@"agent_icon_default.png"];
    _iconImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(start_x, (AGENT_LIST_HEIGHT - agentDefaultImage.size.height/2)/2 , agentDefaultImage.size.width/2, agentDefaultImage.size.height/2) placeholderImage:agentDefaultImage];
    [self.contentView addSubview:_iconImageView];
    
    start_x += 15.0 + _iconImageView.frame.size.width;
    float start_y = 25.0;
    _namelabel = [CreateViewTool createLabelWithFrame:CGRectMake(start_x,start_y, self.frame.size.width - start_x - 40, 20) textString:@"你妹你大爷" textColor:AGENT_NAME_COLOR textFont:AGENT_NAME_FONT];
    [self.contentView addSubview:_namelabel];
    
    start_y += _namelabel.frame.size.height;
    
    _scoreLabel = [CreateViewTool createLabelWithFrame:CGRectMake(start_x,start_y, self.frame.size.width - start_x - 40, 20) textString:@"积分：1100" textColor:AGENT_SCORE_COLOR textFont:AGENT_SCORE_FONT];
    [self.contentView addSubview:_scoreLabel];
    
    
}

#pragma mark 设置数据
- (void)setCellDataWithRank:(int)rank
{
    self.rankLabel.text = [NSString stringWithFormat:@"%d",rank];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
