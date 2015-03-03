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

#define HOUSE_DETAIL_NORMAL_HEIGHT  55.0
#define HOUSE_DETAIL_INFO_HEIGHT    105.0
#define HOUSE_DETAIL_AGENT_HEIGHT   135.0
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
    float lastPoint;
}
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSString *titleText;
@end

@implementation HouseDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //初始化数据
    if (self.houseSource == HouseScourceFromRental)
    {
        self.titleArray = @[@"房间描述",@"房间配置",@"小区信息",@"位置与周边"];
        self.dataArray = @[@"房东急租,房间宽敞,压二付一,不可错过",@"床 空调 宽带 热水器 衣柜 洗衣机 阳台 独立卫生间",@"蛇口中心区",@"蛇口中心位置，四海公园旁，育才学校旁边，生活便利环境优雅."];
    }
    else if (self.houseSource == HouseScourceFromSecondHand)
    {
        self.titleArray = @[@"房间描述",@"房间优势",@"小区信息",@"位置与周边"];
        self.dataArray = @[@"房东急租,房间宽敞,压二付一,不可错过",@"学位房 经济实惠 朝南",@"蛇口中心区",@"蛇口中心位置，四海公园旁，育才学校旁边，生活便利环境优雅."];
    }
    self.titleText = @"蛇口中心位置，四海公园旁，育才学校旁边，生活便利环境优雅.房东急租,房间宽敞,压二付一,不可错过";
    lastPoint = 0.0;
    //初始化UI
    [self createUI];
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
    //self.table.bounces = NO;
}

- (void)addTableHeaderView
{
    float height = 240.0 * scale;
    headerView = [[HouseDetailHeader alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height) delegate:self];
    headerView.delegate = self;
    [headerView setImageScrollViewData:@[@"http://pic1.ajkimg.com/display/xinfang/511f5c20201f6e60241b4d250fac4835/800x600c.jpg",@"http://pic1.ajkimg.com/display/xinfang/4e65e9d08df87df05d1536dbb60ebd25/800x600c.jpg",@"http://pic1.ajkimg.com/display/xinfang/3c440a580dd0244d4b69d0a0dba8dc10/800x600c.jpg"]];
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
    
    UIButton *mobileButton = [CreateViewTool createButtonWithFrame:CGRectMake(space_x, space_y, mobileView.frame.size.width - 2 * space_x, buttonHeight) buttonTitle:@"13893893838" titleColor:WHITE_COLOR normalBackgroundColor:APP_MAIN_COLOR highlightedBackgroundColor:LOGIN_BUTTON_PRESSED_COLOR selectorName:@"mobileButtonPressed:" tagDelegate:self];
    mobileButton.titleLabel.font = FONT(15.0);
    [CommonTool clipView:mobileButton withCornerRadius:5.0];
    [mobileView addSubview:mobileButton];
    
}


#pragma mark 获取详情
- (void)getHouseDetail
{
    //HOUSE_DETAIL_URL
    NSDictionary *requestDic = @{@"Id":@"1111"};
    RequestTool *request = [[RequestTool alloc] init];
    [request requestWithUrl:HOUSE_DETAIL_URL requestParamas:requestDic requestType:RequestTypeAsynchronous
    requestSucess:^(AFHTTPRequestOperation *operation, id responseDic)
    {
        NSLog(@"responseDic===%@",responseDic);
    }
    requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        
    }];
}





#pragma mark mobile
- (void)mobileButtonPressed:(UIButton *)sender
{
    
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
    
}

#pragma mark report
- (void)reportButtonPressed:(UIButton *)sender
{
    
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
            int index = indexPath.row - 2;
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
        [seeInfoView setDataWithTitle:self.titleText publicTime:@"2015-1-29" seeCount:@"2345次"];
        [cell.contentView addSubview:seeInfoView];
    }
    if (indexPath.row == 1)
    {
        if (!detailInfoView)
        {
            detailInfoView = [[HouseDetailInfoView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, HOUSE_DETAIL_INFO_HEIGHT) houseType:self.houseSource];
        }
        if (self.houseSource == HouseScourceFromRental)
        {
            [detailInfoView setDataWithHousePrice:@" 5200/月" HousePriceInfo:@" (押二付一)" houseSize:@" 160平米" houseSource:@" 现有房源" houseType:@" 三室一厅" houseThings:@" 精装修" houseFloor:@" 12/32" housePosition:@" 朝南"];
        }
        if (self.houseSource == HouseScourceFromSecondHand)
        {
            [detailInfoView setDataWithHousePrice:@" 480万" HousePriceInfo:@" 30000/平米" houseSize:@" 160平米" houseSource:@" 现有房源" houseType:@" 三室一厅" houseThings:@" 精装修" houseFloor:@" 12/32" housePosition:@" 朝南"];
        }
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
        [agentView setDataWithAgentName:@"林骚津" phoneNumber:@"13893893838" companyName:@"HooRay" houseScourceCount:@"38套"];
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
        dispatch_async(dispatch_get_main_queue(), ^
        {
            [mapInfoView setDataWithDetailText:self.dataArray[3]];
            [mapInfoView setLocationCoordinate:CLLocationCoordinate2DMake(22.5389288, 113.95620107) locationText:@"蛇口中心位置"];
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
