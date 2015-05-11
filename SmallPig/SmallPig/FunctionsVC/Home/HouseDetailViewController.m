//
//  HouseDetailViewController.m
//  SmallPig
//
//  Created by clei on 15/1/28.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "HouseDetailViewController.h"
#import "HouseDetailHeader.h"
#import "HouseDetailInfoView.h"
#import "HouseDetailAgentView.h"
#import "HouseDetailOneInfoView.h"
#import "HouseDetailSeeInfoView.h"
#import "AddInformViewController.h"
#import "LoginViewController.h"

#define HOUSE_DETAIL_NORMAL_HEIGHT  55.0
#define HOUSE_DETAIL_INFO_HEIGHT    105.0
#define HOUSE_DETAIL_AGENT_HEIGHT   145.0
#define HOUSE_DETAIL_MAP_HEIGHT     175.0
#define HOUSE_DETAIL_SEE_HEIGHT     55.0

@interface HouseDetailViewController ()<UIScrollViewDelegate>
{
    HouseDetailHeader *headerView;
    HouseDetailInfoView *detailInfoView;
    HouseDetailAgentView *agentView;
    HouseDetailOneInfoView *mapInfoView;
    HouseDetailSeeInfoView *seeInfoView;
    UIImageView *mobileView;
    UIButton *mobileButton;
    float lastPoint;
}
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSString *titleText;
@property (nonatomic, strong) NSDictionary *detailDic;
@end

@implementation HouseDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getHouseDetail) name:@"RerequestInfo" object:nil];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //初始化数据
    if (self.houseSource == HouseScourceFromRental)
    {
        self.titleArray = @[@"房间描述",@"房间配置",@"小区信息",@"位置与周边"];
        self.dataArray = @[@"",@"",@"",@""];
    }
    else if (self.houseSource == HouseScourceFromSecondHand)
    {
        self.titleArray = @[@"房间描述",@"房间优势",@"小区信息",@"位置与周边"];
        self.dataArray = @[@"",@"",@"",@""];
    }
    self.titleText = @"";
    lastPoint = 0.0;
    //初始化UI
    [self createUI];
    [self addBackItem];
    //获取房屋详情
    [self getHouseDetail];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavBarAndStatusHidden:YES];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self setNavBarAndStatusHidden:NO];
}


#pragma mark  设置状态栏，导航条是否隐藏
- (void)setNavBarAndStatusHidden:(BOOL)isHidden
{
    //[[UIApplication sharedApplication] setStatusBarHidden:isHidden withAnimation:UIStatusBarAnimationSlide];
    [self.navigationController setNavigationBarHidden:isHidden animated:YES];
}

#pragma mark 初始化UI
- (void)createUI
{
    [self addtableView];
    [self addTableHeaderView];
    [self addMobileView];
}

- (void)addtableView
{
    [self addTableViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) tableType:UITableViewStylePlain tableDelegate:self];
    self.table.bounces = NO;
}   

- (void)addTableHeaderView
{
    float height = 240.0 * scale;
    headerView = [[HouseDetailHeader alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height) delegate:self];
    headerView.delegate = self;
    [self.table setTableHeaderView:headerView];
}

- (void)addMobileView
{
    UIImage *image = [UIImage imageNamed:@"bottom_btn_bg.png"];
    float height = image.size.height/2 * scale;
    float buttonHeight = 35.0 * scale;
    float space_x = 40.0 * scale;
    float space_y = (height - buttonHeight)/2;
    mobileView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, self.view.frame.size.height - height, self.view.frame.size.width, height) placeholderImage:image];
    mobileView.userInteractionEnabled = YES;
    [self.view addSubview:mobileView];
    
    mobileButton = [CreateViewTool createButtonWithFrame:CGRectMake(space_x, space_y, mobileView.frame.size.width - 2 * space_x, buttonHeight) buttonTitle:@"" titleColor:WHITE_COLOR normalBackgroundColor:APP_MAIN_COLOR highlightedBackgroundColor:LOGIN_BUTTON_PRESSED_COLOR selectorName:@"mobileButtonPressed:" tagDelegate:self];
    mobileButton.titleLabel.font = FONT(15.0);
    [CommonTool clipView:mobileButton withCornerRadius:5.0];
    [mobileView addSubview:mobileButton];
    
}


#pragma mark 获取详情
- (void)getHouseDetail
{
    //HOUSE_DETAIL_URL
    [SVProgressHUD showWithStatus:LOADING_DEFAULT];
    __weak typeof(self) weakSelf = self;
    NSDictionary *requestDic = @{@"Id":self.roomID};
    NSString *url = (self.houseSource == HouseScourceFromSecondHand) ? HOUSE_DETAIL_URL : RENTAL_DETAIL_URL;
    RequestTool *request = [[RequestTool alloc] init];
    [request requestWithUrl:url requestParamas:requestDic requestType:RequestTypeAsynchronous
    requestSucess:^(AFHTTPRequestOperation *operation, id responseDic)
    {
        NSLog(@"responseDic===%@",operation.responseString);
        NSDictionary *dic = (NSDictionary *)responseDic;
        int sucess = [dic[@"responseMessage"][@"success"] intValue];
        if (sucess == 1)
        {
            weakSelf.detailDic = dic;
            [SVProgressHUD showSuccessWithStatus:LOADING_SUCESS];
            [weakSelf setDataWithDictionary:dic];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:LOADING_FAILURE];
        }
    }
    requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        [SVProgressHUD showErrorWithStatus:LOADING_FAILURE];
    }];
}

#pragma mark 设置数据
- (void)setDataWithDictionary:(NSDictionary *)dataDic
{
    if (!self.detailDic[@"model"])
    {
        return;
    }
    
    BOOL isSelected = [self.detailDic[@"model"][@"isFavorite"] intValue];
    if (headerView)
    {
        [headerView setSaveButtonState:isSelected];
    }
    
    
    self.roomID = [NSString stringWithFormat:@"%@",self.detailDic[@"model"][@"id"]];
    //设置图片
    NSArray *array = dataDic[@"model"][@"photoList"];
    NSMutableArray *picListUrlArray = [NSMutableArray array];
    if (array && [array count] > 0)
    {
        for (NSDictionary *dic in array)
        {
            NSString *picUrl = [SmallPigTool makePhotoUrlWithPhotoUrl:dic[@"photoUrl"] photoSize:HOUSE_DETAIL_PIC_SIZE photoType:dic[@"photoType"]];
            if (picUrl && ![@"" isEqualToString:picUrl])
            {
                NSLog(@"picUrl===%@",picUrl);
                [picListUrlArray addObject:picUrl];
            }
        }
    }
    [headerView setImageScrollViewData:picListUrlArray];
    
    //设置title描述
    self.titleText = dataDic[@"model"][@"description"];
//   self.titleText = [self.titleText stringByReplacingOccurrencesOfString:@"\r" withString:@" "];
//    self.titleText = [self.titleText stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    //设置电话
    NSString *mobile = dataDic[@"model"][@"publisher"][@"mobile"];
    mobile = (mobile) ? mobile : @"";
    [mobileButton setTitle:mobile forState:UIControlStateNormal];
    
    if (![SmallPigApplication shareInstance].userInfoDic)
    {
        [mobileButton setTitle:@"登录查看经纪人信息" forState:UIControlStateNormal];
    }

    NSMutableArray *featureArray = [NSMutableArray array];
    //房间描述（标签）
    NSString *roomLabelString = dataDic[@"model"][@"roomLabel"];
    roomLabelString = (roomLabelString) ? roomLabelString : @"";
    roomLabelString = (self.houseSource == HouseScourceFromSecondHand) ? [SmallPigTool makeHouseFeature:roomLabelString type:2] : [SmallPigTool makeHouseFeature:roomLabelString type:4];
    [featureArray addObject:roomLabelString];
    
    //房子亮点
    NSString *roomFeatureString = dataDic[@"model"][@"roomFeature"];
    roomFeatureString = (roomFeatureString) ? roomFeatureString : @"";
    roomFeatureString = (self.houseSource == HouseScourceFromSecondHand) ? [SmallPigTool makeHouseFeature:roomFeatureString type:1] : [SmallPigTool makeHouseFeature:roomFeatureString type:3];
    [featureArray addObject:roomFeatureString];
    
    //小区信息
    NSString *parkInfoString = dataDic[@"model"][@"room"][@"community"][@"description"];
    parkInfoString = (parkInfoString) ? parkInfoString : @"";
    [featureArray addObject:parkInfoString];
    
    //位置与周边
    NSString *addressString1 = dataDic[@"model"][@"room"][@"community"][@"address"];
    addressString1 = (addressString1) ? addressString1 : @"";
    NSString *addressString2 = dataDic[@"model"][@"room"][@"building"][@"community"][@"showName"];
    addressString2 = (addressString2) ? addressString2 : @"";
    NSString *addressString = [NSString stringWithFormat:@"%@ %@",addressString1,addressString2];
    [featureArray addObject:addressString];
    
    self.dataArray = featureArray;
    
    [self.table reloadData];
}



#pragma mark mobile
- (void)mobileButtonPressed:(UIButton *)sender
{
    if ([self isNeedLogin])
    {
        return;
    }
    NSString *buttonTitle = [sender titleForState:UIControlStateNormal];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",buttonTitle]];
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"联系中介" message:buttonTitle delegate:self cancelButtonTitle:@"拨打" otherButtonTitles:@"取消", nil];
        [alertView show];
    }
    else
    {
        //设备不支持
        [CommonTool addAlertTipWithMessage:@"设备不支持"];
    }
    
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if ([@"拨打" isEqualToString:title])
    {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",alertView.message]];
        [[UIApplication sharedApplication] openURL:url];
    }
}

#pragma mark back
- (void)backButtonPressed:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark share
- (void)shareButtonPressed:(UIButton *)sender
{
    
}

#pragma mark save
- (void)saveButtonPressed:(UIButton *)sender
{

    //ADD_SAVE_URL
    if ([self isNeedLogin])
    {
        return;
    }
    
    if (!self.detailDic)
    {
        return;
    }
    
    sender.enabled = NO;
    
    if (!self.roomID || [self.roomID isEqualToString:@""])
    {
        return;
    }
    NSDictionary *requestDic = (sender.selected) ? @{@"id":self.roomID} : @{@"publishRoom.id":self.roomID};
    NSString *url = (sender.selected) ? DELETE_SAVE_URL : ADD_SAVE_URL;
    RequestTool *request = [[RequestTool alloc] init];
    [request requestWithUrl:url requestParamas:requestDic requestType:RequestTypeAsynchronous requestSucess:
    ^(AFHTTPRequestOperation *operation, id responseDic)
    {
        
        sender.enabled = YES;
        NSDictionary *dic = (NSDictionary *)responseDic;
        int sucess = [dic[@"responseMessage"][@"success"] intValue];
        if (sucess == 1)
        {
            sender.selected = !sender.selected;
            [SVProgressHUD showSuccessWithStatus:@"收藏成功" duration:1.0];
        }
        else
        {
            NSString *message = dic[@"responseMessage"][@"message"];
            message = (message) ? message : @"";
            [SVProgressHUD showErrorWithStatus:@"收藏失败" duration:.3];
            [CommonTool addAlertTipWithMessage:message];
        }
        NSLog(@"saveresponseDic===%@",operation.responseString);
    }
    requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"error====%@",error);
        sender.enabled = YES;
        [SVProgressHUD showErrorWithStatus:@"收藏失败" duration:1.0];
    }];
}

#pragma mark report
- (void)reportButtonPressed:(UIButton *)sender
{
    if ([self isNeedLogin])
    {
        return;
    }
    AddInformViewController *informViewController = [[AddInformViewController alloc] init];
    informViewController.roomID = self.roomID;
    [self.navigationController pushViewController:informViewController animated:YES];
}

#pragma mark 是否需要登录
- (BOOL)isNeedLogin
{
    if (![SmallPigApplication shareInstance].userInfoDic)
    {
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        UINavigationController  *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:Nil];
        return YES;
    }
    return NO;
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    float offset_y = scrollView.contentOffset.y;
    if (offset_y >= NAV_HEIGHT)
    {
        [self moveMobileViewIsShow:NO];
    }
    else if(offset_y <= 20)
    {
        [self moveMobileViewIsShow:YES];
    }
    if ((int)offset_y == (int)self.table.contentSize.height - SCREEN_HEIGHT)
    {
        [self moveMobileViewIsShow:YES];
    }
 
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    float offset_y = scrollView.contentOffset.y;
//    if (offset_y >= self.table.contentSize.height - self.table.frame.size.height)
//    {
//         [self moveMobileViewIsShow:YES];
//    }
}

- (void)moveMobileViewIsShow:(BOOL)isShow
{
    float move_y = mobileView.frame.size.height;
    move_y = (isShow) ? 0 : move_y;
    [UIView animateWithDuration:.3 animations:^
    {
        mobileView.transform = CGAffineTransformMakeTranslation(0, move_y);
    }];
}


#pragma mark tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        if (self.titleText && ![@"" isEqualToString:self.titleText])
        {
            float textHeight = [CommonTool labelHeightWithText:self.titleText textFont:FONT(14.0) labelWidth:self.view.frame.size.width - 2 * SEE_SPACE_X];
            return SEE_SPACE_Y * 3 + textHeight + SEE_LABEL_HEIGHT;
        }

        return HOUSE_DETAIL_SEE_HEIGHT;
    }
    if (indexPath.row == 1)
    {
        return HOUSE_DETAIL_INFO_HEIGHT;
    }
    if (indexPath.row > 1 && indexPath.row < 6)
    {
        if (self.dataArray)
        {
            int index = (int)indexPath.row - 2;
            if (index > [self.dataArray count] - 1)
            return HOUSE_DETAIL_NORMAL_HEIGHT;
            float textHeight = [CommonTool labelHeightWithText:self.dataArray[indexPath.row - 2] textFont:FONT(14.0) labelWidth:SCREEN_WIDTH - 2 * SPACE_X];
            if (indexPath.row == 5)
            {
                return  SPACE_Y * 3 + textHeight + SPACE_Y + MAPVIEW_HEIGHT + LABEL_HEIGHT;
            }
            return  SPACE_Y * 3 + textHeight + LABEL_HEIGHT;
        }
        return HOUSE_DETAIL_MAP_HEIGHT;
    }
    if (indexPath.row == 6)
    {
        return HOUSE_DETAIL_AGENT_HEIGHT;
    }
    return HOUSE_DETAIL_NORMAL_HEIGHT;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.separatorInset = UIEdgeInsetsMake(0, 10.0, 0, 10.0);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    if (indexPath.row == 0)
    {
        if (!seeInfoView)
        {
            seeInfoView = [[HouseDetailSeeInfoView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, HOUSE_DETAIL_SEE_HEIGHT)];
        }
        NSString *time = self.detailDic[@"model"][@"publisher"][@"createDate"];
        NSString *browseCount = [NSString stringWithFormat:@"%@",self.detailDic[@"model"][@"browseCount"]];
        browseCount = (browseCount)  ? [browseCount stringByAppendingString:@"次"]: @"";
        time = [SmallPigTool formatTimeWithString:time];
        NSLog(@"self.titleText===%@",self.titleText);
        [seeInfoView setDataWithTitle:self.titleText publicTime:time seeCount:browseCount];
        [cell.contentView addSubview:seeInfoView];
    }
    if (indexPath.row == 1)
    {
        if (!detailInfoView)
        {
            detailInfoView = [[HouseDetailInfoView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, HOUSE_DETAIL_INFO_HEIGHT) houseType:self.houseSource];
        }
        
        NSString *price = [SmallPigTool getHousePrice:self.detailDic[@"model"][@"price"]];
        NSString *otherPrice = self.detailDic[@"model"][@"price"];
        otherPrice = (otherPrice) ? otherPrice : @"";
        otherPrice = [NSString stringWithFormat:@" %@元/月",otherPrice];
        price = (self.houseSource == HouseScourceFromSecondHand) ? price : otherPrice;
        
        NSString *perPrice = self.detailDic[@"model"][@"room"][@"building"][@"community"][@"price"];
        perPrice = (perPrice) ? perPrice : @"";
        perPrice = [NSString stringWithFormat:@" %@/平米",perPrice];
        perPrice = (self.houseSource == HouseScourceFromSecondHand) ? perPrice : @"";
        
        NSString *size = self.detailDic[@"model"][@"room"][@"square"];
        size = (size) ? size : @"";
        size = [NSString stringWithFormat:@" %@平米",size];
        
        NSString *type = [SmallPigTool makeRoomStyleWithRoomDictionary:self.detailDic[@"model"]];
        type = [@" " stringByAppendingString:type];
        
        NSString *things = [SmallPigTool getDecorateWithIndex:[self.detailDic[@"model"][@"room"][@"decorate"] intValue]];
        things = [@" " stringByAppendingString:things];
        
        NSString *towards = self.detailDic[@"model"][@"room"][@"towards"];
        towards = (towards) ? towards : @"";
        towards = [SmallPigTool getTowardsWithIdentification:towards];
        towards = [NSString stringWithFormat:@" %@",towards];
        
        NSString *floor1 = self.detailDic[@"model"][@"room"][@"floor"];
        floor1 = (floor1) ? floor1 : @"";
        NSString *floor2 = self.detailDic[@"model"][@"room"][@"building"][@"floor2"];
        floor2 = (floor2) ? floor2 : @"";
        NSString *floor= [NSString stringWithFormat:@" %@/%@",floor1,floor2];
        
        [detailInfoView setDataWithHousePrice:price
                               HousePriceInfo:perPrice
                                    houseSize:size
                                  houseSource:@" 现有房源"
                                    houseType:type
                                  houseThings:things
                                   houseFloor:floor
                                housePosition:towards];
        [cell.contentView addSubview:detailInfoView];
    }
    if (indexPath.row > 1 && indexPath.row < 6)
    {
        if (indexPath.row == 5)
        {
            [self addMapInfoViewToCell:cell];
        }
        else
        {
            HouseDetailOneInfoView *infoView = [[HouseDetailOneInfoView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, HOUSE_DETAIL_INFO_HEIGHT) viewType:InfoViewTypeNormal viewTitle:self.titleArray[indexPath.row - 2]];
            [infoView setDataWithDetailText:self.dataArray[indexPath.row - 2]];
            [cell.contentView addSubview:infoView];
        }
    }
    if (indexPath.row == 6)
    {
        if (!agentView)
        {
            agentView = [[HouseDetailAgentView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, HOUSE_DETAIL_AGENT_HEIGHT) delegate:self];
        }
        //设置中介信息
        NSLog(@"self.detailDic[@\"model\"][@\"publisher\"]===%@",self.detailDic[@"model"][@"publisher"]);
        NSString *name = self.detailDic[@"model"][@"publisher"][@"name"];
        name = (name) ? name : @"";
        NSString *mobile = self.detailDic[@"model"][@"publisher"][@"mobile"];
        mobile = (mobile) ? mobile : @"";
        NSString *iconUrl = [SmallPigTool makePhotoUrlWithPhotoUrl:self.detailDic[@"model"][@"publisher"][@"avatarPhoto"][@"photoUrl"] photoSize:AGENT_LIST_ICON_SIZE photoType:self.detailDic[@"model"][@"publisher"][@"avatarPhoto"][@"photoType"]];
        [agentView setDataWithAgentIcon:iconUrl  agentName:name phoneNumber:mobile companyName:@"" houseScourceCount:@""];
        [cell.contentView addSubview:agentView];
    }
    
    return cell;
}


- (void)addMapInfoViewToCell:(UITableViewCell *)cell
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^
    {
        if (!mapInfoView)
        {
            mapInfoView = [[HouseDetailOneInfoView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, HOUSE_DETAIL_INFO_HEIGHT) viewType:InfoViewTypeMap viewTitle:self.titleArray[3]];
        }
        dispatch_sync(dispatch_get_main_queue(), ^
        {
            //设置地图数据
            float lat = [self.detailDic[@"model"][@"room"][@"community"][@"lat"] floatValue];
            float lng = [self.detailDic[@"model"][@"room"][@"community"][@"lng"] floatValue];
            NSString *parkName =  self.detailDic[@"model"][@"room"][@"building"][@"community"][@"name"];
            parkName = (parkName) ? parkName : @"";
            NSLog(@"lat===lng===parkName===%f===%f===%@",lat,lng,parkName);
            [mapInfoView setDataWithDetailText:self.dataArray[3]];
            [mapInfoView setLocationCoordinate:CLLocationCoordinate2DMake(lat, lng) locationText:parkName];
            [cell.contentView addSubview:mapInfoView];
        });
    });

    
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
