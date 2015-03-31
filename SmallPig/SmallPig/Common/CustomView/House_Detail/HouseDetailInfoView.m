//
//  HouseDetailInfoView.m
//  SmallPig
//
//  Created by clei on 15/1/28.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "HouseDetailInfoView.h"


@interface HouseDetailInfoView()
@property (nonatomic, assign) HouseScource houseType;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation HouseDetailInfoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame houseType:(HouseScource)type
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.houseType = type;
        //初始化数据
        if (self.houseType == HouseScourceFromRental)
        {
            self.titleArray = @[@"租金:",@"面积:",@"房源:",@"户型:",@"装修:",@"楼层:",@"朝向:"];
        }
        if (self.houseType == HouseScourceFromSecondHand)
        {
            self.titleArray = @[@"售价:",@"单价:",@"面积:",@"房源:",@"户型:",@"装修:",@"楼层:",@"朝向:"];
        }
        //初始化UI
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
    float space_y = 5.0;
    float space_x = 10.0;
    float width = (self.frame.size.width - 3 * space_x)/2;
    float height = 20.0;
    int m = 2;
    for (int i = 0; i < 4; i++)
    {
        if (self.houseType == HouseScourceFromRental)
        {
            if (i == 0)
            {
                width = self.frame.size.width - 2 * space_x;
                m = 1;
            }
            else
            {
                m = 2;
                width = (self.frame.size.width - 3 * space_x)/2;
            }
        }
        else
        {
            width = (self.frame.size.width - 3 * space_x)/2;
            m = 2;
        }
        for (int j = 0; j < m; j++)
        {
            float x = j * width + space_x;
            float y = i * (height + space_y) + space_y;
            int index = j + i * m + 1;
            if(self.houseType == HouseScourceFromRental && i > 0)
            {
                index = j + i * m;
            }
            UILabel *label = [CreateViewTool createLabelWithFrame:CGRectMake(x, y, width, height) textString:self.titleArray[index - 1] textColor:HOUSE_DETAIL_TITLE_COLOR textFont:FONT(14.0)];
            label.tag = index;
            [self addSubview:label];
        }
    }
}


#pragma mark 设置数据
- (void)setDataWithHousePrice:(NSString *)housePrice HousePriceInfo:(NSString *)priceInfo houseSize:(NSString *)size houseSource:(NSString *)scource houseType:(NSString *)type houseThings:(NSString *)things houseFloor:(NSString *)floor housePosition:(NSString *)position
{
    housePrice = (housePrice) ? housePrice : @"";
    size = (size) ? size : @"";
    priceInfo = (priceInfo) ? priceInfo : @"";
    scource = (scource) ? scource : @"";
    type = (type) ? type : @"";
    things = (things) ? things : @"";
    floor = (floor) ? floor : @"";
    position = (position) ? position : @"";
    if(self.houseType == HouseScourceFromRental)
    {
        self.dataArray = @[[housePrice stringByAppendingString:priceInfo],size,scource,type,things,floor,position];
    }
    else if (self.houseType == HouseScourceFromSecondHand)
    {
        self.dataArray = @[housePrice,priceInfo,size,scource,type,things,floor,position];
    }

    for (int i = 0; i < [self.dataArray count]; i++)
    {
        UILabel *label = (UILabel *)[self viewWithTag:i + 1];
        NSString *textString = [self.titleArray[i] stringByAppendingString:self.dataArray[i]];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:textString];
        if (i == 0)
        {
            [CommonTool makeString:textString toAttributeString:attributedString withString:housePrice withTextColor:HOUSE_LIST_PRICE_COLOR withTextFont:FONT(15.0)];
            [CommonTool makeString:textString toAttributeString:attributedString withString:priceInfo withTextColor:HOUSE_DETAIL_TITLE_COLOR withTextFont:FONT(14.0)];
        }
        else
        {
            [CommonTool makeString:textString toAttributeString:attributedString withString:self.dataArray[i] withTextColor:HOUSE_DETAIL_TEXT_COLOR withTextFont:FONT(14.0)];
        }
        label.attributedText = attributedString;
    }
}




@end
