//
//  DorpDownListView.h
//  SmallPig
//
//  Created by chenlei on 14/11/26.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DorpDownListViewDelegate;

//typedef void (^DorpDownListViewSelectedItem)(int column,int row);
//typedef void (^DorpDownListViewIsSelected)();

@interface DorpDownListView : UIView <UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, strong) NSArray *columnArray;
@property(nonatomic, strong) NSArray *columnListArray;
@property(nonatomic, assign) id<DorpDownListViewDelegate> delegate;
//@property(nonatomic, weak)   DorpDownListViewSelectedItem selectedItem;
//@property(nonatomic, weak)   DorpDownListViewIsSelected isSelectedItem;
@property(nonatomic, strong) NSString *showName;

- (void)setListViewWithColumnArray:(NSArray *)array;
- (void)reloadTableViewDataWithIndex:(int)index;
@end

@protocol DorpDownListViewDelegate <NSObject>

- (void)dorpDownListView:(DorpDownListView *)dorpDownListView selectedColunmItem:(int)colunm selectedRowItem:(int)row;
@end
