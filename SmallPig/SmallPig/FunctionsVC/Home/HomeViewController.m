//
//  HomeViewController.m
//  SmallPig
//
//  Created by clei on 14/11/6.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "HomeViewController.h"
#import "LoginViewController.h"
@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    UIView *greenView;
}
@end

@implementation HomeViewController

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self= [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
        // Custom initialization
        //self.title=@"首页";
        self.dataArray = (NSMutableArray *)@[@[@"新房",@"第一时间获取新房资讯"],@[@"租房",@"真实小区物业资讯"],@[@"二手房",@"二手房买卖真实房源"],@[@"经纪人",@"每周评出积分最高的经纪人"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addPersonItem];
    
    [self createUI];
    
    //去掉阴影和导航条下方黑线
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    UINavigationController  *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
    [self presentViewController:nav animated:YES completion:Nil];
    // Do any additional setup after loading the view.
}


- (void)createUI
{
    [self addGreenView];
}

- (void)addGreenView
{
    greenView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 220 - NAV_HEIGHT)];
    greenView.backgroundColor = APP_MAIN_COLOR;
    [self.view addSubview:greenView];
    
    float city_w = 50.0;
    UIImage *homeLogoImage = [UIImage imageNamed:@"home_logo.png"];
    UIImageView *logoImageView = [CreateViewTool createImageViewWithFrame:CGRectMake((SCREEN_WIDTH - homeLogoImage.size.width/2 - city_w)/2, 40, homeLogoImage.size.width/2, homeLogoImage.size.height/2) placeholderImage:homeLogoImage];
    [greenView addSubview:logoImageView];
    
    UIImage *searchBgImage = [UIImage imageNamed:@"search_input.png"];
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - searchBgImage.size.width/2)/2, greenView.frame.size.height - searchBgImage.size.height/2 - 15, searchBgImage.size.width/2, searchBgImage.size.height/2)];
    searchBar.delegate = self;
    searchBar.barStyle = UISearchBarStyleDefault;
    searchBar.translucent = YES;
    searchBar.tintColor = [UIColor clearColor];
    //RGB(27, 133, 82);
    //[searchBar setBackgroundImage:[[UIImage alloc] init]];
    searchBar.placeholder = @"搜索";
    //searchBar.backgroundColor = [UIColor clearColor];
    [greenView addSubview:searchBar];
    [self resetSearchBar:searchBar];
    //[[searchBar.subviews objectAtIndex:0] removeFromSuperview];
    
    float y = greenView.frame.origin.y + greenView.frame.size.height + 7;
    [self addTableViewWithFrame:CGRectMake(10, y, SCREEN_WIDTH - 10*2, SCREEN_HEIGHT - y - NAV_HEIGHT) tableType:UITableViewStylePlain tableDelegate:self];
    self.table.separatorInset = UIEdgeInsetsZero;
    self.table.backgroundColor = [UIColor clearColor];
}

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
        if ([view isKindOfClass:NSClassFromString(@"UISearchBarTextField")])
        {
            [view setBackgroundColor:RGB(27, 132, 81)];
        }
        if ([view isKindOfClass:[UIButton class]])
        {
            UIButton* cancelbutton = (UIButton* )view;
            [cancelbutton setTitleColor:WIHTE_COLOR forState:UIControlStateNormal];
            [cancelbutton setTitle:@"取消" forState:UIControlStateNormal];
            break;
        }
    }
}

#pragma mark UISearchBar and UISearchDisplayController Delegate Methods

//searchBar开始编辑时改变取消按钮的文字
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
    [self resetSearchBar:searchBar];
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
  
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
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
    return HOME_ICON_ROWHEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *homeCellID = @"homeCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:homeCellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:homeCellID];
        cell.backgroundColor = WIHTE_COLOR;
        cell.imageView.transform = CGAffineTransformScale(cell.imageView.transform, 0.5, 0.5);
    }
    NSArray *array = self.dataArray[indexPath.section];
    cell.textLabel.text = array[0];
    cell.detailTextLabel.text = array[1];
    cell.textLabel.textColor = HOME_LIST_TITLE_COLOR;
    cell.detailTextLabel.textColor = HOME_LIST_DETAIL_COLOR;
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"home_icon%d.png",indexPath.section + 1]];
    
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
