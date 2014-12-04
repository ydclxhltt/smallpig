//
//  DropDownView.m
//  SmallPig
//
//  Created by clei on 14/12/4.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#define TITLE_LABEL_HEIGHT 20.0

#import "DropDownView.h"

@interface DropDownView()
@property(nonatomic, weak) void (^dropDownViewClicked)();
@end

@implementation DropDownView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
    }
    return self;
}

//初始化视图
- (void)createViewWithTitle:(NSString *)title clickedBlock:(void (^)())click
{
    UIImage *arrowImage = [UIImage imageNamed:@"home_arrow.png"];
    UIImageView *arrowImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(self.frame.size.width - arrowImage.size.width/2, self.frame.size.height - arrowImage.size.height/2 - 5, arrowImage.size.width/2, arrowImage.size.height/2) placeholderImage:arrowImage];
    [self addSubview: arrowImageView];
    
    _titleLabel = [CreateViewTool  createLabelWithFrame:CGRectMake(0,self.frame.size.height - TITLE_LABEL_HEIGHT, self.frame.size.width - arrowImage.size.width/2 - 3, TITLE_LABEL_HEIGHT) textColor:[UIColor whiteColor] textFont:[UIFont systemFontOfSize:16.0]];
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    _titleLabel.text = title;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    
    UIButton *button  = [CreateViewTool createButtonWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) buttonImage:nil selectorName:@"buttonPressed:" tagDelegate:self];
    button.showsTouchWhenHighlighted = YES;
    [self addSubview:button];
    
    if (click)
    {
        self.dropDownViewClicked = click;
    }
}

//按钮点击响应方法
- (void)buttonPressed:(UIButton *)sender
{
    if (self.dropDownViewClicked)
    {
        self.dropDownViewClicked();
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
