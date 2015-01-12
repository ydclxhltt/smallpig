//
//  HomeViewController.m
//  SmallPig
//
//  Created by clei on 14/11/6.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "HomeViewController.h"
#import "DropDownView.h"
#import "NewHouseListViewController.h"
#import "HouseListViewController.h"
#import "SearchHouseViewController.h"
#import "CityListViewController.h"
#import "AgentRankListViewController.h"

@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    UIView *greenView;
    DropDownView *dropDownView;
}
@end

@implementation HomeViewController

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self= [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
        // Custom initialization
        //self.title=@"首页";
        self.dataArray = (NSMutableArray *)@[@[@"租房",@"真实小区物业资讯"],@[@"二手房",@"二手房买卖真实房源"],@[@"新房",@"第一时间获取新房资讯"],@[@"经纪人",@"每周评出积分最高的经纪人"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //初始化UI
    [self createUI];
    //添加侧滑item
    [self addPersonItem];
    // Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self setMainSideCanSwipe:YES];
}

#pragma mark 添加UI
//初始化视图
- (void)createUI
{
    [self addGreenView];
    [self addTableView];
}

//添加上半部分绿色视图
- (void)addGreenView
{
    //添加绿色背景视图
    greenView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 220 * scale)];
    greenView.backgroundColor = APP_MAIN_COLOR;
    [self.view addSubview:greenView];
    
    //添加logo视图
    float city_w = 55.0 * scale;
    float space_w = 5.0 * scale;
    UIImage *homeLogoImage = [UIImage imageNamed:@"home_logo.png"];
    UIImageView *logoImageView = [CreateViewTool createImageViewWithFrame:CGRectMake((SCREEN_WIDTH - homeLogoImage.size.width/2  * scale - city_w - space_w)/2, 40 + NAV_HEIGHT, homeLogoImage.size.width/2 * scale, homeLogoImage.size.height/2 * scale) placeholderImage:homeLogoImage];
    [greenView addSubview:logoImageView];
    
    //添加城市显示视图
    dropDownView = [[DropDownView alloc] initWithFrame:CGRectMake(space_w + logoImageView.frame.origin.x + logoImageView.frame.size.width, logoImageView.frame.origin.y, city_w, logoImageView.frame.size.height)];
    [dropDownView createViewWithTitle:@"深圳" clickedBlock:^{[self showCityList];}];
    [greenView addSubview:dropDownView];
    
    //添加搜索视图
    UIImage *searchBgImage = [UIImage imageNamed:@"search_input.png"];
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - searchBgImage.size.width/2  * scale)/2, greenView.frame.size.height - searchBgImage.size.height/2 * scale - 15 * scale, searchBgImage.size.width/2 * scale, searchBgImage.size.height/2 * scale)];
    searchBar.barStyle = UISearchBarStyleDefault;
    //searchBar.tintColor = WHITE_COLOR;
    searchBar.placeholder = @"搜索";
    [greenView addSubview:searchBar];
    [self resetSearchBar:searchBar];
    
    UIButton *button = [CreateViewTool createButtonWithFrame:searchBar.frame buttonTitle:@"" titleColor:[UIColor clearColor] normalBackgroundColor:[UIColor clearColor] highlightedBackgroundColor:nil selectorName:@"showSearchView:" tagDelegate:self];
    [greenView addSubview:button];
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
            UITextField *textField = (UITextField *)view;
            textField.borderStyle = UITextBorderStyleNone;
            //textField.backgroundColor = [UIColor whiteColor];
            textField.background = [UIImage imageNamed:@"search_input.png"];
            //[view setBackgroundColor:;];
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

//添加表视图
- (void)addTableView
{
    float y = greenView.frame.origin.y + greenView.frame.size.height + 7;
    [self addTableViewWithFrame:CGRectMake(10, y, SCREEN_WIDTH - 10*2, SCREEN_HEIGHT - y) tableType:UITableViewStylePlain tableDelegate:self];
    self.table.separatorInset = UIEdgeInsetsZero;
    self.table.backgroundColor = [UIColor clearColor];
}


#pragma mark 点击搜索响应事件
- (void)showSearchView:(UIButton *)sender
{
//    SearchHouseViewController *searchHouseViewController = [[SearchHouseViewController alloc]init];
//    UINavigationController *searchNav = [[UINavigationController alloc] initWithRootViewController:searchHouseViewController];
//    [self presentViewController:searchNav animated:NO completion:Nil];
}

- (void)showCityList
{
    CityListViewController *cityListViewController = [[CityListViewController alloc]init];
    UINavigationController *cityListNav = [[UINavigationController alloc]initWithRootViewController:cityListViewController];
    [self presentViewController:cityListNav animated:YES completion:Nil];
}

#pragma mark - tableView代理

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 2.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *imageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 2.0) placeholderImage:nil];
    imageView.backgroundColor = [UIColor clearColor];
    return imageView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HOME_ICON_ROWHEIGHT  * scale;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *homeCellID = @"homeCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:homeCellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:homeCellID];
        cell.backgroundColor = WHITE_COLOR;
        cell.imageView.transform = CGAffineTransformScale(cell.imageView.transform, 0.5, 0.5);
    }
    NSArray *array = self.dataArray[indexPath.section];
    cell.textLabel.text = array[0];
    cell.detailTextLabel.text = array[1];
    cell.textLabel.textColor = HOME_LIST_TITLE_COLOR;
    cell.detailTextLabel.textColor = HOME_LIST_DETAIL_COLOR;
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"home_icon%d.png",(int)indexPath.section + 1]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self pushViewControllerWithIndex:(int)indexPath.section];
}

#pragma mark 点击行视图跳转方法
- (void)pushViewControllerWithIndex:(int)index
{
    UIViewController *viewController = nil;
    switch (index)
    {
        case 0:
            viewController = [[HouseListViewController alloc]init];
            ((HouseListViewController *)viewController).houseSource = HouseScourceFromRental;
            break;
        case 1:
            viewController = [[HouseListViewController alloc]init];
            ((HouseListViewController *)viewController).houseSource = HouseScourceFromSecondHand;
            break;
        case 2:
            viewController = [[NewHouseListViewController alloc]init];
            break;
        case 3:
            viewController = [[AgentRankListViewController alloc]init];
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:viewController animated:YES];

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
