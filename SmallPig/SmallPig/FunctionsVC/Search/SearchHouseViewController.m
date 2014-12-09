//
//  SearchHouseViewController.m
//  SmallPig
//
//  Created by clei on 14/12/9.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "SearchHouseViewController.h"

@interface SearchHouseViewController ()<UISearchBarDelegate>
{
    UISearchBar *searchHouseBar;
}
@end

@implementation SearchHouseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createUI];
    // Do any additional setup after loading the view.
}


- (void)viewDidAppear:(BOOL)animated
{
    [searchHouseBar becomeFirstResponder];
}

- (void)createUI
{
    //添加搜索视图
    UIImage *searchBgImage = [UIImage imageNamed:@"search_input.png"];
    searchHouseBar = [[UISearchBar alloc]initWithFrame:CGRectMake(10, (44 - searchBgImage.size.height/2)/2,searchBgImage.size.width/2, searchBgImage.size.height/2)];
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
            UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
            leftView.backgroundColor = [UIColor redColor];
            ((UITextField *)view).leftView = leftView;
            [view setBackgroundColor:HOME_SEARCHBAR_BG_COLOR];
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
    [searchBar resignFirstResponder];
    [self.navigationController dismissViewControllerAnimated:YES completion:Nil];
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
