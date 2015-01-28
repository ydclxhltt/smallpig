//
//  HouseDetailHeader.m
//  SmallPig
//
//  Created by clei on 15/1/28.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "HouseDetailHeader.h"

@interface HouseDetailHeader()<UIScrollViewDelegate>
{
    UIScrollView *imageScrollView;
    UILabel *countLabel;
}
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation HouseDetailHeader

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame  delegate:(id)delegate
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.delegate = delegate;
        [self initView];
    }
    return self;
}

#pragma mark 初始化UI
- (void)initView
{
    [self addScrollView];
    [self addButtons];
    [self addLabel];
}


- (void)addScrollView
{
    imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    imageScrollView.backgroundColor = BASIC_VIEW_BG_COLOR;
    imageScrollView.bounces = NO;
    imageScrollView.pagingEnabled = YES;
    imageScrollView.showsHorizontalScrollIndicator = NO;
    imageScrollView.showsVerticalScrollIndicator = NO;
    imageScrollView.delegate = self;
    [self addSubview:imageScrollView];
}

- (void)setImageScrollViewData:(NSArray *)array
{
    if (!array || [array count] == 0)
    {
        return;
    }
    self.dataArray = array;
    imageScrollView.contentSize =CGSizeMake(imageScrollView.frame.size.width * [array count], imageScrollView.frame.size.height);
    [self addImageViewWithIndex:1];
}

- (void)addImageViewWithIndex:(int)index
{
    UIImageView *imageView = (UIImageView *)[imageScrollView viewWithTag:index];
    if (!imageView)
    {
        imageView = [CreateViewTool createImageViewWithFrame:CGRectMake((index - 1)* imageScrollView.frame.size.width, 0, imageScrollView.frame.size.width, imageScrollView.frame.size.height) placeholderImage:[UIImage imageNamed:@"house_image_default.png"] imageUrl:self.dataArray[index - 1] isShowProcess:YES];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.tag = index;
        [imageScrollView addSubview:imageView];
    }
    countLabel.text = [NSString stringWithFormat:@"<%d/%d>",index,[self.dataArray count]];
}


- (void)addButtons
{
    float height = STATUS_HEIGHT + 5.0;
    float space_x = 10.0;
    UIImage *backImage = [UIImage imageNamed:@"detail_back_up.png"];
    UIButton *backButton = [CreateViewTool createButtonWithFrame:CGRectMake(space_x, height, backImage.size.width/2,  backImage.size.height/2) buttonImage:@"detail_back" selectorName:@"backButtonPressed:" tagDelegate:self.delegate];
    [self addSubview:backButton];
    
    UIImage *saveImage = [UIImage imageNamed:@"detail_save_up.png"];
    UIButton *saveButton = [CreateViewTool createButtonWithFrame:CGRectMake(self.frame.size.width - saveImage.size.width/2 , backButton.frame.origin.y, saveImage.size.width/2,  saveImage.size.height/2) buttonImage:@"detail_save" selectorName:@"saveButtonPressed:" tagDelegate:self.delegate];
    [self addSubview:saveButton];
    
    UIImage *shareImage = [UIImage imageNamed:@"detail_share_up.png"];
    UIButton *shareButton = [CreateViewTool createButtonWithFrame:CGRectMake(saveButton.frame.origin.x - shareImage.size.width/2, backButton.frame.origin.y, shareImage.size.width/2,  shareImage.size.height/2) buttonImage:@"detail_share" selectorName:@"shareButtonPressed:" tagDelegate:self.delegate];
    [self addSubview:shareButton];
}

- (void)addLabel
{
    countLabel = [CreateViewTool createLabelWithFrame:CGRectMake(20.0, self.frame.size.height - 35.0, self.frame.size.width - 20.0 * 2, 35.0) textString:@"" textColor:[UIColor whiteColor] textFont:FONT(16.0)];
    countLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:countLabel];
}


#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x/scrollView.frame.size.width;
    [self addImageViewWithIndex:page + 1];
}


@end
