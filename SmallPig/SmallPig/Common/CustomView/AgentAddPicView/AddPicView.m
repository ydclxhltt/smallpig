//
//  AddPicView.m
//  SmallPig
//
//  Created by clei on 15/3/11.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "AddPicView.h"

#define PIC_WH          65.0
#define PIC_ADD_X       10.0
#define ADD_IMAGE_NAME  @"Detail_add_pic.png"

@interface AddPicView()
{
    UIScrollView *picScrollView;
    UIButton *addImageButton;
}
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation AddPicView

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
        [self initUI];
    }
    return self;
}


#pragma mark 初始化UI
- (void)initUI
{
    if (!picScrollView)
    {
        picScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        picScrollView.bounces = NO;
        picScrollView.showsHorizontalScrollIndicator = NO;
        picScrollView.showsVerticalScrollIndicator = NO;
        picScrollView.pagingEnabled = YES;
        [self addSubview:picScrollView];
        
        addImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        addImageButton.frame = CGRectMake(0, 0, PIC_WH, PIC_WH);
        [addImageButton setImage:[UIImage imageNamed:ADD_IMAGE_NAME] forState:UIControlStateNormal];
        [addImageButton addTarget:self action:@selector(addPicButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [picScrollView addSubview:addImageButton];
    }
}

#pragma mark 设置数据
- (void)setDataWithImageArray:(NSArray *)array
{
    if (!array || [array count] == 0)
    {
        return;
    }
    if (!self.dataArray)
    {
        self.dataArray = array;
    }
    else
    {
        NSMutableArray *newArray = [NSMutableArray arrayWithArray:self.dataArray];
        [newArray addObjectsFromArray:array];
        self.dataArray = newArray;
    }
    if (self.dataArray)
    {
        addImageButton.frame = CGRectMake(self.dataArray.count * (PIC_WH + PIC_ADD_X), 0 , PIC_WH, PIC_WH);
        if ([self.dataArray count] > self.maxPicCount)
        {
            [addImageButton setAlpha:.0];
        }
    }
    
    if (self.dataArray && [self.dataArray count] > 0)
    {
        for (int i = 0; i < [self.dataArray count]; i++)
        {
            if ([self.dataArray count] > self.maxPicCount)
            {
                return;
            }
            UIImageView *imageView = (UIImageView *)[picScrollView viewWithTag:i + 1];
            if (!imageView)
            {
                imageView = [CreateViewTool createImageViewWithFrame:CGRectMake(i * (PIC_WH + PIC_ADD_X), 0, PIC_WH, PIC_WH) placeholderImage:self.dataArray[i]];
                imageView.tag = i + 1;
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewPressed:)];
                [imageView addGestureRecognizer:tapGesture];
            }
            if (imageView.image != self.dataArray[i])
            {
                //上传
            }
            imageView.image = self.dataArray[i];

        }
    }
}


#pragma mark 添加图片
- (void)addPicButtonPressed:(UIButton *)sender
{
    
}


#pragma mark 点击图片
- (void)imageViewPressed:(UITapGestureRecognizer *)tapGesture
{
    
}


@end
