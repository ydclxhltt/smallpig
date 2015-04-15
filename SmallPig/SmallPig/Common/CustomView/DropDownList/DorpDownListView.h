//
//  DorpDownListView.h
//  SmallPig
//
//  Created by chenlei on 14/11/26.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DorpDownListViewSelectedItem)(int column,int row);

@interface DorpDownListView : UIView <UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, retain) NSArray *columnArray;
@property(nonatomic, retain) NSArray *columnListArray;
@property(nonatomic, weak)   DorpDownListViewSelectedItem selectedItem;

- (void)setListViewWithColumnArray:(NSArray *)array;
- (void)reloadTableViewDataWithIndex:(int)index;
@end
