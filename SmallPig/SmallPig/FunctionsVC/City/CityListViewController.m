//
//  CityListViewController.m
//  SmallPig
//
//  Created by clei on 14/12/9.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "CityListViewController.h"
#import "BMapKit.h"

@interface CityListViewController ()<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    NSArray *titleArray;
    BMKLocationService *locationService;
    BMKGeoCodeSearch *geocodesearch;
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
    //初始化数据
    self.dataArray = [NSMutableArray array];
    [self.dataArray addObject:@[@"正在定位"]];
    NSArray *array = [SmallPigApplication shareInstance].cityList;
    array = (array) ? array : @[];
    [self.dataArray addObject:array];
    titleArray = @[@"GPS定位城市",@"热门城市"];
    //定位
    [self setLocation];
    [self startLocation];
    //获取城市
    if ([array count] == 0)
    {
        [self getCityList];
    }
    
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


#pragma mark  定位相关
- (void)setLocation
{
    locationService = [[BMKLocationService alloc]init];
    //定位的最小更新距离
    [BMKLocationService setLocationDistanceFilter:kCLDistanceFilterNone];
    //定位精确度
    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyBest];
}

- (void)startLocation
{
    locationService.delegate = self;
    [locationService startUserLocationService];
}


- (void)stopLocation
{
    locationService.delegate = nil;
    [locationService stopUserLocationService];
    
}



#pragma mark 编译地址
- (void)getReverseGeocodeWithLocation:(CLLocationCoordinate2D)locaotion
{
    if (!geocodesearch)
    {
        geocodesearch = [[BMKGeoCodeSearch alloc] init];
        geocodesearch.delegate = self;
    }
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = locaotion;
    BOOL flag = [geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
}




#pragma mark 获取城市列表
- (void)getCityList
{
    [SVProgressHUD showWithStatus:@"正在获取..."];
    __weak typeof(self) weakSelf = self;
    NSDictionary  *requestDic = @{@"paramCategory":@"AREA>COMMUNITY>BUILDING>ROOM"};
    RequestTool *request = [[RequestTool alloc] init];
    [request requestWithUrl:SORT_LIST_URL requestParamas:requestDic requestType:RequestTypeAsynchronous
    requestSucess:^(AFHTTPRequestOperation *operation, id responseDic)
    {
        NSLog(@"responseDic====%@",responseDic);
        [SVProgressHUD showSuccessWithStatus:@"获取成功"];
        int sucessCode = [responseDic[@"responseMessage"][@"success"] intValue];
        if (sucessCode == 1)
        {
            NSArray *array = responseDic[@"model"][@"paramList"];
            if (array && [array count] > 0)
            {
                [weakSelf.dataArray replaceObjectAtIndex:1 withObject:array];
                [weakSelf.table reloadData];
            }
        }
       
    }
    requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        [SVProgressHUD showErrorWithStatus:@"获取失败"];
    }];
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
    NSString *city = @"";
    if ([array[indexPath.row] isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dic = (NSDictionary *)array[indexPath.row];
        city = dic[@"fullName"];
    }
    else
    {
        city = array[indexPath.row];
    }
    cell.textLabel.text = city;
    cell.textLabel.font = FONT(16.0);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     NSDictionary *rowDic = self.dataArray[1][indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (![@"正在定位" isEqualToString:cell.textLabel.text])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectedCity" object:rowDic];
        [self dismissViewControllerAnimated:YES completion:Nil];
    }
    
}



#pragma mark 坐标转换地址Delegate
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSLog(@"result====%@",[[result addressDetail] city]);
    [self.dataArray replaceObjectAtIndex:0 withObject:@[[[result addressDetail] city]]];
    [self.table reloadData];
}

#pragma mark locationManageDelegate

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"userLocation====%@",[userLocation.location description]);
    [self getReverseGeocodeWithLocation:userLocation.location.coordinate];
    [self stopLocation];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc
{
    if (locationService)
    {
        [self stopLocation];
        locationService.delegate = nil;
        locationService = nil;
    }
    if (geocodesearch)
    {
        geocodesearch.delegate = nil;
        geocodesearch = nil;
    }
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
