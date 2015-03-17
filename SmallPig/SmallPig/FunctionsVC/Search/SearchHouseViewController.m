//
//  SearchHouseViewController.m
//  SmallPig
//
//  Created by clei on 14/12/9.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "SearchHouseViewController.h"

#define SPACE_X          10.0
#define SEARCHBAR_HEIGHT 30.0
#define LEFTVIEW_WIDTH   50.0

@interface SearchHouseViewController ()<UISearchBarDelegate,UISearchBarDelegate,UISearchDisplayDelegate,UITableViewDataSource>
{
    UISearchBar *searchHouseBar;
}
@end

@implementation SearchHouseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavBarItemWithTitle:@"" navItemType:LeftItem selectorName:@""];
    // Do any additional setup after loading the view.
}


- (void)viewDidAppear:(BOOL)animated
{
    if (!searchHouseBar)
    {
        [self createUI];
    }
    [searchHouseBar becomeFirstResponder];
}

- (void)createUI
{
    //添加搜索视图
    //UIImage *searchBgImage = [UIImage imageNamed:@"search_input.png"];
    searchHouseBar = [[UISearchBar alloc]initWithFrame:CGRectMake(SPACE_X * CURRENT_SCALE, 0, SCREEN_WIDTH - 2 * SPACE_X * CURRENT_SCALE, SEARCHBAR_HEIGHT)];
    searchHouseBar.delegate = self;
    searchHouseBar.barStyle = UISearchBarStyleDefault;
    searchHouseBar.placeholder = @"搜索";
    searchHouseBar.showsCancelButton = YES;
    [self.navigationController.navigationBar addSubview:searchHouseBar];
    [self resetSearchBar:searchHouseBar];
    
    UISearchDisplayController *searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchHouseBar contentsController:self];
    searchDisplayController.delegate = self;
    searchDisplayController.searchResultsDataSource = self;
    //searchDisplayController.searchResultsDelegate = self;
    [searchDisplayController.searchResultsTableView reloadData];
}


//修改SearchBar
- (void)resetSearchBar:(UISearchBar *)searchBar
{
    NSArray *subViews;
    
    if (DEVICE_SYSTEM_VERSION >= 7.0)
    {
        subViews = [(searchBar.subviews[0]) subviews];
    }
    else
    {
        subViews = searchBar.subviews;
    }
    
    for (id view in subViews)
    {
        NSLog(@"view=====%@",view);
        if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
        {
            [view removeFromSuperview];
        }
        if ([view isKindOfClass:[UITextField class]])
        {
            UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LEFTVIEW_WIDTH, SEARCHBAR_HEIGHT)];
            leftView.backgroundColor = [UIColor clearColor];
            ((UITextField *)view).leftView = leftView;
            UILabel *lable = [CreateViewTool createLabelWithFrame:leftView.frame textString:@"二手房" textColor:APP_MAIN_COLOR textFont:FONT(14.0)];
            lable.textAlignment = NSTextAlignmentCenter;
            [leftView addSubview:lable];
            //[view setBackgroundColor:HOME_SEARCHBAR_BG_COLOR];
        }
        if ([view isKindOfClass:[UIButton class]])
        {
            UIButton* cancelbutton = (UIButton* )view;
            [cancelbutton setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
            [cancelbutton setTitle:@"取消" forState:UIControlStateNormal];
            break;
        }
    }
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [UIView animateWithDuration:.3 animations:^{[searchHouseBar removeFromSuperview];} completion:^(BOOL finish){}];
    [self.navigationController popViewControllerAnimated:NO];
}



#pragma mark - tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //searchDisplayController自身有一个searchResultsTableView，所以在执行操作的时候首先要判断是否是搜索结果的tableView，如果是显示的就是搜索结果的数据，如果不是，则显示原始数据。
    
    return 3;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell_identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = @"11111";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
