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

@interface SearchHouseViewController ()<UISearchBarDelegate>
{
    UISearchBar *searchHouseBar;
    BOOL isShow;
}
@end

@implementation SearchHouseViewController

- (void)viewDidLoad
{
    self.houseSource = HouseScourceFromSecondHandSearch;
    [super viewDidLoad];
    isShow = NO;
    self.navigationItem.rightBarButtonItem = nil;
    // Do any additional setup after loading the view.
}


- (void)viewDidAppear:(BOOL)animated
{
    if (!searchHouseBar)
    {
        [self createUI];
    }
    [searchHouseBar becomeFirstResponder];
    //设置不可侧滑
    [self setMainSideCanSwipe:NO];
}

- (void)createUI
{
    [super createUI];
    //添加搜索视图
    //UIImage *searchBgImage = [UIImage imageNamed:@"search_input.png"];
    searchHouseBar = [[UISearchBar alloc]initWithFrame:CGRectMake(SPACE_X * CURRENT_SCALE, (44 - SEARCHBAR_HEIGHT)/2, SCREEN_WIDTH - 2 * SPACE_X * CURRENT_SCALE, SEARCHBAR_HEIGHT)];
    searchHouseBar.delegate = self;
    searchHouseBar.barStyle = UISearchBarStyleDefault;
    searchHouseBar.placeholder = @"搜索";
    searchHouseBar.showsCancelButton = YES;
    [self.navigationController.navigationBar addSubview:searchHouseBar];
    [self resetSearchBar:searchHouseBar];
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
            UIButton *button = [CreateViewTool createButtonWithFrame:CGRectMake(0, 0, LEFTVIEW_WIDTH, SEARCHBAR_HEIGHT) buttonTitle:@"二手房" titleColor:APP_MAIN_COLOR normalBackgroundColor:nil highlightedBackgroundColor:nil selectorName:@"buttonPressed:" tagDelegate:self];
            button.titleLabel.font = FONT(14.0);
            ((UITextField *)view).leftView = button;
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

- (void)getData
{
    
}

- (void)buttonPressed:(UIButton *)sender
{
    isShow = !isShow;
    NSString *title = (isShow) ? @"租房" : @"二手房";
    [sender setTitle:title forState:UIControlStateNormal];
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self dismissViewControllerAnimated:NO completion:nil];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.searchParma = searchBar.text;
    self.houseSource = (isShow)? HouseScourceFromSecondHandSearch : HouseScourceFromRentalSearch;
    [searchBar resignFirstResponder];
    [super getData];
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
