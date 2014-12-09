//
//  CityListViewController.m
//  SmallPig
//
//  Created by clei on 14/12/9.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "CityListViewController.h"

@interface CityListViewController ()
{
    NSArray *titleArray;
}
@end

@implementation CityListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置title
    self.title = CITY_LIST_TITLE;
    //添加返回Item
    [self addBackItem];
    //初始化视图
    [self createUI];
    //test
    self.dataArray = (NSMutableArray *)@[@[@"深圳"],@[@"深圳",@"珠海",@"惠州",@"东莞",@"深圳",@"珠海",@"惠州",@"东莞",@"深圳",@"珠海",@"惠州",@"东莞",@"深圳",@"珠海",@"惠州",@"东莞"]];
    titleArray = @[@"GPS定位城市",@"热门城市"];
    // Do any additional setup after loading the view.
}

#pragma mark  创建UI
- (void)createUI
{
    [self addTableViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) tableType:UITableViewStylePlain tableDelegate:self];
}

#pragma mark 返回按钮响应方法
- (void)backButtonPressed:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:Nil];
}

#pragma mark - tableView代理


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [titleArray objectAtIndex:section];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.dataArray objectAtIndex:section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *homeCellID = @"cityCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:homeCellID];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:homeCellID];
        cell.backgroundColor = WHITE_COLOR;
    }
    NSArray *array = self.dataArray[indexPath.section];
    cell.textLabel.text = array[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismissViewControllerAnimated:YES completion:Nil];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
