//
//  OrderDetailViewController.m
//  SmallPig
//
//  Created by clei on 15/3/11.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "HouseDetailInfoView.h"

#define ROW_AGENT_HEIGHT    60.0
#define ROW_HOUSE_HEIGHT    105.0
#define ROW_TIME_HEIGHT     44.0


@interface OrderDetailViewController ()
{
    int memberType;
    UIButton *commitButton;
    HouseDetailInfoView *detailInfoView;
}

@end

@implementation OrderDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    memberType = [SmallPigApplication shareInstance].memberType;
    //设置title
    self.title = @"订单详情";
    //添加item
    [self addBackItem];
    //初始化UI
    [self createUI];
    //获取订单详情
    //[self getOrderDetail];
    // Do any additional setup after loading the view.
}



#pragma mark 初始化UI
- (void)createUI
{
    [self addTableView];
    [self addCommitView];
}

- (void)addTableView
{
    [self addTableViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) tableType:UITableViewStylePlain tableDelegate:self];
}


- (void)addCommitView
{
    UIImage *image = [UIImage imageNamed:@"bottom_btn_bg.png"];
    float height = image.size.height/2 * scale;
    float buttonHeight = 35.0 * scale;
    float space_x = 40.0 * scale;
    float space_y = (height - buttonHeight)/2;
    UIImageView *mobileView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, self.view.frame.size.height - height, self.view.frame.size.width, height) placeholderImage:image];
    mobileView.userInteractionEnabled = YES;
    [self.view addSubview:mobileView];
    
    commitButton = [CreateViewTool createButtonWithFrame:CGRectMake(space_x, space_y, mobileView.frame.size.width - 2 * space_x, buttonHeight) buttonTitle:@"" titleColor:WHITE_COLOR normalBackgroundColor:APP_MAIN_COLOR highlightedBackgroundColor:LOGIN_BUTTON_PRESSED_COLOR selectorName:@"commitButtonPressed:" tagDelegate:self];
    commitButton.titleLabel.font = FONT(15.0);
    [CommonTool clipView:commitButton withCornerRadius:5.0];
    [mobileView addSubview:commitButton];
    
    int status = [self.detailDic[@"orderStatus"] intValue];
    NSString *text = @"";
    UIColor *color = APP_MAIN_COLOR;
    BOOL isEnable = YES;
    switch (status)
    {
        case 0:
            text = @"订单取消";
            color = RGB(138.0, 138.0, 138.0);
            isEnable = NO;
            break;
        case 1:
            text = (memberType == 2) ? @"确认订单" : @"等待客户确认";
            isEnable = (memberType == 2) ? YES : NO;
            break;
        case 2:
            text = @"客户已确认";
            isEnable = NO;
            break;
        case 3:
            text = @"订单完成";
            isEnable = NO;
            break;
        default:
            break;
    }
    [commitButton setTitle:text forState:UIControlStateNormal];
    [commitButton setBackgroundColor:color];
    commitButton.enabled = isEnable;
}


#pragma mark 获取订单详情
- (void)getOrderDetail
{
    typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:LOADING_DEFAULT];
    RequestTool *request = [[RequestTool alloc] init];
    NSDictionary *requestDic = @{@"id":self.orderID};
    [request requestWithUrl:MY_ORDER_DETAIL_URL requestParamas:requestDic requestType:RequestTypeAsynchronous requestSucess:^(AFHTTPRequestOperation *operation, id responseDic)
     {
         NSLog(@"order_responseDic===%@",responseDic);
         NSDictionary *dic = (NSDictionary *)responseDic;
         if ([dic[@"responseMessage"][@"success"] intValue] == 1)
         {
             [SVProgressHUD showSuccessWithStatus:LOADING_SUCESS];
             weakSelf.detailDic = dic;
             [weakSelf.table reloadData];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:LOADING_FAILURE];
         }
     }
    requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [SVProgressHUD showErrorWithStatus:LOADING_FAILURE];
         NSLog(@"login_error===%@",error);
     }];

}


#pragma mark 确认订单
- (void)commitButtonPressed:(UIButton *)sender
{
    commitButton.enabled = NO;
    [SVProgressHUD showWithStatus:@"正在确认订单..."];
    RequestTool *request = [[RequestTool alloc] init];
    NSDictionary *requestDic = @{@"id":self.orderID};
    [request requestWithUrl:COMMIT_ORDER_URL requestParamas:requestDic requestType:RequestTypeAsynchronous requestSucess:^(AFHTTPRequestOperation *operation, id responseDic)
     {
         NSLog(@"order_responseDic===%@",responseDic);
         NSDictionary *dic = (NSDictionary *)responseDic;
         if ([dic[@"responseMessage"][@"success"] intValue] == 1)
         {
             [SVProgressHUD showSuccessWithStatus:@"已确认"];
             commitButton.enabled = NO;
             [self.navigationController popViewControllerAnimated:YES];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:@"确认订单失败"];
             commitButton.enabled = YES;
         }
     }
     requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [SVProgressHUD showErrorWithStatus:@"确认订单失败"];
         commitButton.enabled = YES;
         NSLog(@"login_error===%@",error);
     }];
}


#pragma mark - tableView代理


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *imageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15.0) placeholderImage:nil];
    imageView.backgroundColor = [UIColor clearColor];
    return imageView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
         return ROW_TIME_HEIGHT;
    }
    if (indexPath.row == 0)
    {
       if (memberType == 0)
       {
           return ROW_AGENT_HEIGHT;
       }
       else
       {
           return ROW_HOUSE_HEIGHT;
       }
       
    }
    if (indexPath.row == 1)
    {
        if (memberType == 0)
        {
            return ROW_HOUSE_HEIGHT;
        }
        else
        {
            return ROW_TIME_HEIGHT;
        }
        
    }
    return ROW_TIME_HEIGHT;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return (self.roomType == 2) ? 1 : 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        if (memberType == 0)
        {
            return 3;
        }
        else
        {
            return 2;
        }
    }
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"CellID";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.imageView.transform = CGAffineTransformMakeScale(.5, .5);
    }
    
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
    NSString *bookPrice = [NSString stringWithFormat:@"%@",self.detailDic[@"bookPrice"]];
    NSString *text = [NSString stringWithFormat:@"定金: %@ 元",bookPrice];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text];
    [CommonTool  makeString:text toAttributeString:string withString:@"定金:" withTextColor:HOUSE_DETAIL_TITLE_COLOR withTextFont:FONT(15.0)];
    [CommonTool  makeString:text toAttributeString:string withString:@"元" withTextColor:HOUSE_DETAIL_TITLE_COLOR withTextFont:FONT(15.0)];
    [CommonTool  makeString:text toAttributeString:string withString:bookPrice withTextColor:HOUSE_DETAIL_TEXT_COLOR withTextFont:FONT(15.0)];
    
    NSString *time = [NSString  stringWithFormat:@"%d",[self.detailDic[@"period"] intValue]];
    time = (time) ? time : @"";
    NSString *timeText = [NSString stringWithFormat:@"租期: %@ 个月",time];
    NSMutableAttributedString *timeString = [[NSMutableAttributedString alloc] initWithString:text];
    [CommonTool  makeString:timeText toAttributeString:timeString withString:@"租期:" withTextColor:HOUSE_DETAIL_TITLE_COLOR withTextFont:FONT(15.0)];
    [CommonTool  makeString:timeText toAttributeString:timeString withString:@"个月" withTextColor:HOUSE_DETAIL_TITLE_COLOR withTextFont:FONT(15.0)];
    [CommonTool  makeString:timeText toAttributeString:timeString withString:time withTextColor:HOUSE_DETAIL_TEXT_COLOR withTextFont:FONT(15.0)];
    
    if (indexPath.section == 0)
    {
        if (memberType == 0)
        {
            if (indexPath.row == 0)
            {
                [cell.imageView setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"agent_icon_default.png"]];
                NSString *name = self.detailDic[@"model"][@"publishRoom"][@"publisher"][@"bankAcctName"];
                name = (name) ? name : @"";
                cell.textLabel.text = name;
                cell.textLabel.font = FONT(15.0);
                cell.detailTextLabel.text = @"经纪人";
                cell.detailTextLabel.font = FONT(13.0);
            }
            if (indexPath.row == 1)
            {
                [self setDetailInfoViewData];
                [cell.contentView addSubview:detailInfoView];
            }
            else if (indexPath.row == 2)
            {
                cell.textLabel.font = FONT(15.0);
                cell.textLabel.attributedText = string;
            }
            else if (indexPath.row == 3)
            {
                cell.textLabel.font = FONT(15.0);
                cell.textLabel.attributedText = timeString;
            }
        }
        else
        {
            if (indexPath.row == 0)
            {
                [self setDetailInfoViewData];
                [cell.contentView addSubview:detailInfoView];
            }
            if (indexPath.row == 1)
            {
                cell.textLabel.font = FONT(15.0);
                cell.textLabel.attributedText = string;
            }
            if (indexPath.row == 2)
            {
                cell.textLabel.attributedText = timeString;
            }
        }

    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //COMMIT_ORDER_URL
}

#pragma mark 设置房屋信息
- (void)setDetailInfoViewData
{
    if (!detailInfoView)
    {
        detailInfoView = [[HouseDetailInfoView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ROW_HOUSE_HEIGHT) houseType:(self.roomType == 2) ? HouseScourceFromSecondHand : HouseScourceFromRental];
    }
    
    NSString *price = [SmallPigTool getHousePrice:self.detailDic[@"publishRoom"][@"price"]];
    NSString *otherPrice = self.detailDic[@"publishRoom"][@"price"];
    otherPrice = (otherPrice) ? otherPrice : @"";
    otherPrice = [NSString stringWithFormat:@" %@元/月",otherPrice];
    price = (self.roomType == 2) ? price : otherPrice;
    
    NSString *perPrice = self.detailDic[@"publishRoom"][@"room"][@"community"][@"price"];
    perPrice = (perPrice) ? perPrice : @"";
    perPrice = [NSString stringWithFormat:@" %@/平米",perPrice];
    perPrice = (self.roomType == 2) ? perPrice : @"";
    
    NSString *size = self.detailDic[@"publishRoom"][@"room"][@"square"];
    size = (size) ? size : @"";
    size = [NSString stringWithFormat:@" %@平米",size];
    
    NSString *type = [SmallPigTool makeRoomStyleWithRoomDictionary:self.detailDic[@"publishRoom"]];
    type = [@" " stringByAppendingString:type];
    
    NSString *things = [SmallPigTool getDecorateWithIndex:[self.detailDic[@"publishRoom"][@"room"][@"decorate"] intValue]];
    things = [@" " stringByAppendingString:things];
    
    NSString *towards = self.detailDic[@"publishRoom"][@"room"][@"towards"];
    towards = (towards) ? towards : @"";
    towards = [SmallPigTool getTowardsWithIdentification:towards];
    towards = [NSString stringWithFormat:@" %@",towards];
    
    NSString *floor1 = self.detailDic[@"publishRoom"][@"room"][@"floor"];
    floor1 = (floor1) ? floor1 : @"";
    NSString *floor2 = self.detailDic[@"publishRoom"][@"room"][@"building"][@"floor2"];
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
