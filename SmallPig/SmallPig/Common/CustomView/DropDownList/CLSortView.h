//
//  CLSortView.h
//  SmallPig
//
//  Created by clei on 15/4/15.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SortViewDelegate;


//typedef void (^SortViewButtonBarPressedBlock) (int index);
//typedef void (^SortViewListItemPressedBlock) (int column, int row);

@interface CLSortView : UIView

@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) id<SortViewDelegate> delegate;
@property (nonatomic, assign) int selectedIndex;

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSMutableArray *)array;
@end

@protocol SortViewDelegate <NSObject>

- (void)sortView:(CLSortView *)sortView buttonBarPressedIndex:(int)index;
- (void)sortView:(CLSortView *)sortView sortViewListItemPressedColumn:(int)index sortViewListItemPressedRow:(int)row;

@end