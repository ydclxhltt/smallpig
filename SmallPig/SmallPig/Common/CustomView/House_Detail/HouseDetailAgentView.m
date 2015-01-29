//
//  HouseDetailAgentView.m
//  SmallPig
//
//  Created by clei on 15/1/29.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "HouseDetailAgentView.h"

@interface HouseDetailAgentView()
{
    UIImageView *iconImageView;
    UILabel *tipLabel;
}
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation HouseDetailAgentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame delegate:(id)delegate
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.delegate = delegate;
        self.titleArray = @[@"",@"联系方式: ",@"所属公司: ",@"在线房源: "];
        [self createUI];
    }
    return self;
}

#pragma mark 初始化UI
- (void)createUI
{
    [self addInfoView];
}

- (void)addInfoView
{
    float space_x = 10.0;
    float space_y = 5.0;
    float start_y = space_y;
    float labelHeight = 20.0;
    float icon_Height = 80.0;
    float icon_Width = 60.0;
    
    UILabel *titleLable = [CreateViewTool createLabelWithFrame:CGRectMake(space_x, start_y, self.frame.size.width, labelHeight) textString:@"中介信息" textColor:HOUSE_DETAIL_TITLE_COLOR textFont:FONT(14.0)];
    [self addSubview:titleLable];
    
    start_y += titleLable.frame.size.height + space_y;
    
    iconImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(titleLable.frame.origin.x, start_y, icon_Width, icon_Height) placeholderImage:[UIImage imageNamed:@"agent_icon_default.png"]];
    iconImageView.clipsToBounds = YES;
    iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:iconImageView];
    
    float right_space_x = 20.0;
    float buttonWidth = 60.0;
    float buttonHeight = 30.0;
    float button_x = self.frame.size.width  - right_space_x - buttonWidth;
    float button_y = titleLable.frame.origin.y + titleLable.frame.size.height/2;
    UIButton *reportButton = [CreateViewTool createButtonWithFrame:CGRectMake(button_x, button_y, buttonWidth, buttonHeight) buttonTitle:@"举报" titleColor:WHITE_COLOR normalBackgroundColor:RGB(236.0, 142.0, 102.0) highlightedBackgroundColor:RGB(240.0, 202.0, 185.0) selectorName:@"reportButtonPressed:" tagDelegate:self.delegate];
    reportButton.titleLabel.font = FONT(15.0);
    [self addSubview:reportButton];

    float start_x = iconImageView.frame.origin.x + iconImageView.frame.size.width + space_x;
    float labelWidth = self.frame.size.width - start_x - space_x;
    
    for (int i = 0; i < 4; i++)
    {
        UILabel *label = [CreateViewTool createLabelWithFrame:CGRectMake(start_x, start_y, labelWidth, labelHeight) textString:self.titleArray[i] textColor:HOUSE_DETAIL_TEXT_COLOR textFont:FONT(14.0)];
        if (i == 0)
        {
            label.font = FONT(15.0);
        }
        label.tag = i + 1;
        [self addSubview:label];
        
        start_y +=  label.frame.size.height;
    }
    
    tipLabel = [CreateViewTool createLabelWithFrame:CGRectMake(space_x, start_y, self.frame.size.width - 2 * space_x, labelHeight) textString:@"房源信息由  提供,详情请致电." textColor:HOUSE_DETAIL_TITLE_COLOR textFont:FONT(13.0)];
    [self addSubview:tipLabel];
}

#pragma mark 设置数据
- (void)setDataWithAgentName:(NSString *)name phoneNumber:(NSString *)mobile companyName:(NSString *)company  houseScourceCount:(NSString *)count
{
    self.dataArray = @[name,mobile,company,count];
    for (int i = 0; i < 4; i++)
    {
        UILabel *label = (UILabel *)[self viewWithTag:i+1];
        label.text = [NSString stringWithFormat:@"%@%@",self.titleArray[i],self.dataArray[i]];
    }
    tipLabel.text = [NSString stringWithFormat:@"房源信息由%@提供,详情请致电.",name];
}

@end
