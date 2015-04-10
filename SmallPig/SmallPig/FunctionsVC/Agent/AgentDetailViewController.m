//
//  AgentDetailViewController.m
//  SmallPig
//
//  Created by clei on 14/12/11.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#define AGENT_DETAIL_HEADER_HEIGHT 30.0

#import "AgentDetailViewController.h"
#import "RentalHouseListCell.h"
#import "SecondHandHouseListCell.h"


@interface AgentDetailViewController ()
{
    UIImageView *headerImageView;
    int buttonSelectedIndex;
}

@property(nonatomic, retain) NSArray *imagesArray;
@property(nonatomic, assign) HouseScource houseScource;

@end

@implementation AgentDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置title
    self.title = AGENT_DETAIL_TITLE;
    //添加返回item
    [self addBackItem];
    //初始化UI
    [self createUI];
    //初始化数据
    buttonSelectedIndex = 1;
    currentPage = 1;
    self.houseScource = HouseScourceFromSecondHand;
    self.imagesArray = @[@"telephone_icon.png"];
    //获取发布房源数据
    [self getPublicRoomList];
    // Do any additional setup after loading the view.
}

#pragma mark 创建UI
//创建UI
- (void)createUI
{
    [self addTableViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) tableType:UITableViewStyleGrouped tableDelegate:self];
    self.table.backgroundColor = WHITE_COLOR;
    self.table.separatorColor = AGENT_DETAIL_LINE_COLOR;
}


#pragma mark 设置分区表头
- (void)settableViewHeader
{
    if (!headerImageView)
    {
        headerImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AGENT_DETAIL_HEADER_HEIGHT) placeholderImage:nil];
        headerImageView.userInteractionEnabled = YES;
        headerImageView.backgroundColor = [UIColor clearColor];
        
        UIImageView *imageViewLine = [CreateViewTool createImageViewWithFrame:CGRectMake(0, -10, SCREEN_WIDTH, .5) placeholderImage:nil];
        imageViewLine.backgroundColor = AGENT_DETAIL_LINE_COLOR;
        [headerImageView addSubview:imageViewLine];
        
        NSArray *array = @[@"二手房",@"租房"];
        
        for (int i = 0; i < 2; i++)
        {
            UIButton *button = [CreateViewTool createButtonWithFrame:CGRectMake(i * SCREEN_WIDTH/2, -2.5, SCREEN_WIDTH/2, headerImageView.frame.size.height) buttonImage:nil selectorName:@"houseTypeButtonPressed:" tagDelegate:self];
            button.tag = 1 + i;
            [button setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
            [button setTitleColor:AGENT_DETAIL_TYPE_COLOR forState:UIControlStateNormal];
            [button setTitleColor:APP_MAIN_COLOR forState:UIControlStateSelected];
            button.titleLabel.font = AGENT_DETAIL_FONT;
            [headerImageView addSubview:button];
            
            if (i == 0)
            {
                UIImageView *imageViewLine1 = [CreateViewTool createImageViewWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, .5, headerImageView.frame.size.height - 5) placeholderImage:nil];
                imageViewLine1.backgroundColor = AGENT_DETAIL_LINE_COLOR;
                [headerImageView addSubview:imageViewLine1];
            }
        }
      
    }
    UIButton *button = (UIButton *)[headerImageView viewWithTag:buttonSelectedIndex];
    button.selected = YES;
}


#pragma mark 获取发布房源数据
- (void)getPublicRoomList
{
    [SVProgressHUD showWithStatus:LOADING_DEFAULT];
    __weak typeof(self) weakSelf = self;
    NSDictionary *requestDic = @{@"queryBean.params.publisher_id_long":self.agentID,@"queryBean.pageNo":@(currentPage),@"queryBean.pageSize":@(10)};
    RequestTool *request = [[RequestTool alloc] init];
    [request requestWithUrl:AGENT_PUBLICROOM_URL requestParamas:requestDic requestType:RequestTypeAsynchronous
              requestSucess:^(AFHTTPRequestOperation *operation, id responseObj)
     {
         NSLog(@"responseObj====%@",responseObj);
         isCanGetMore = YES;
         NSDictionary *dic = (NSDictionary *)responseObj;
         int sucess = [dic[@"responseMessage"][@"success"] intValue];
         if (sucess == 1)
         {
             [SVProgressHUD showSuccessWithStatus:LOADING_SUCESS];
             [weakSelf setHouseDataWithDictionary:dic];
         }
         else
         {
             if (currentPage > 1)
             {
                 currentPage--;
             }
             [SVProgressHUD showErrorWithStatus:LOADING_FAILURE];
         }
     }
    requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"error====%@",error);
         isCanGetMore = YES;
         if (currentPage > 1)
         {
             currentPage--;
         }
         [SVProgressHUD showErrorWithStatus:LOADING_FAILURE];
     }];
}

#pragma mark 加载更多
- (void)getMoreData
{
    if (!isCanGetMore)
    {
        currentPage--;
        return;
    }
    isCanGetMore = NO;
    [self getPublicRoomList];
}

#pragma mark 设置数据
- (void)setHouseDataWithDictionary:(NSDictionary *)dic
{
    NSArray *array = dic[@"pageBean"][@"data"];
    int pageCount = [dic[@"pageBean"][@"totalPages"] intValue];
    
    if (!self.dataArray)
    {
        if (!array || [array count] == 0)
        {
            [CommonTool addAlertTipWithMessage:@"暂无数据"];
        }
        else
        {
            self.dataArray = [NSMutableArray arrayWithArray:array];
        }
    }
    else
    {
        if (array && [array count] > 0)
            [self.dataArray addObjectsFromArray:array];
    }
    [self.table reloadData];
    
    if (pageCount > currentPage)
    {
        [self addGetMoreView];
    }
    else
    {
        [self removeGetMoreView];
        isCanGetMore = NO;
    }
}


#pragma mark 切换房源响应事件

- (void)houseTypeButtonPressed:(UIButton *)sender
{
    buttonSelectedIndex = (int)sender.tag;
    sender.selected = YES;
    UIButton *button = (UIButton *)[headerImageView viewWithTag:(sender.tag == 1) ? 2 : 1];
    button.selected = NO;
    self.houseScource = (sender.tag == 1) ? HouseScourceFromSecondHand : HouseScourceFromRental;
    [self.table reloadData];
}

#pragma mark - tableView代理

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1)
    {
        return .1;
    }
    return 5.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.1;
    }
    return AGENT_DETAIL_HEADER_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return nil;
    }
    [self settableViewHeader];
    return headerImageView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 2;
    }
    else if (section == 1)
    {
        return [self.dataArray count];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            return AGENT_LIST_HEIGHT;
        }
    }
    else if (indexPath.section == 1)
    {
        return HOUSE_LIST_HEIGHT;
    }
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *agentCellID = @"AgentDetailCellID";
    static NSString *rentalHouseCellID = @"RentalHouseCellID";
    static NSString *secondHouseCellID = @"SecondhandHouseCellID";
    
    UITableViewCell *cell ;
    
    if (indexPath.section == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:agentCellID];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:agentCellID];
            cell.backgroundColor = WHITE_COLOR;
            cell.imageView.transform = CGAffineTransformScale(cell.imageView.transform, 0.5, 0.5);
            cell.separatorInset = UIEdgeInsetsZero;
        }
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        NSString *textString = @"";
        NSString *detailTextString = @"";
        if (indexPath.row == 0)
        {
            textString = self.name;
            detailTextString = [NSString stringWithFormat:@"积分 %@",self.score];
            cell.textLabel.textColor = AGENT_DETAIL_NAME_COLOR;
            cell.detailTextLabel.textColor = AGENT_DETAIL_SCORE_COLOR;
            [CommonTool clipView:cell.imageView withCornerRadius:10.0];
            [cell.imageView setImageWithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:[UIImage imageNamed:@"agent_icon_default.png"]];
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            textString =  [NSString stringWithFormat:@"电话: %@",self.mobile];
            detailTextString = @"";
            cell.textLabel.font = AGENT_DETAIL_FONT;
            cell.textLabel.textColor = AGENT_DETAIL_FONT_COLOR;
            cell.imageView.image = [UIImage imageNamed:[self.imagesArray objectAtIndex:indexPath.row - 1]];
        }
        
        cell.textLabel.text = textString;
        cell.detailTextLabel.text = detailTextString;

    }
    else if (indexPath.section == 1)
    {
        NSDictionary *rowDic = self.dataArray[indexPath.row];
        NSString *title = rowDic[@"title"];
        title = (title) ? title : @"";
        NSString *imageUrl = [SmallPigTool makePhotoUrlWithPhotoUrl:rowDic[@"coverPhoto"][@"photoUrl"] photoSize:HOUSE_LIST_ICON_SIZE photoType:rowDic[@"coverPhoto"][@"photoType"]];
        NSLog(@"imageUrl===%@",imageUrl );
        NSString *local = rowDic[@"room"][@"community"][@"address"];
        local = (local) ? local : @"";
        NSLog(@"local===%@",local);
        NSString *park = rowDic[@"room"][@"community"][@"name"];
        park = (park) ? park : @"";
        NSString *square = [NSString stringWithFormat:@"%@平米",rowDic[@"room"][@"square"]];
        square = (square) ? square : @"";
        float price = [rowDic[@"price"] floatValue]/10000.0;
        NSString *roomPrice = [NSString stringWithFormat:@"%.0f万",price];
        NSString *roomStyle = [SmallPigTool makeEasyRoomStyleWithRoomDictionary:rowDic];
        
        if (HouseScourceFromSecondHand == self.houseScource)
        {
            cell = (SecondHandHouseListCell *)[tableView dequeueReusableCellWithIdentifier:secondHouseCellID];
            if (!cell)
            {
                cell = [[SecondHandHouseListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:secondHouseCellID];
                cell.backgroundColor = [UIColor whiteColor];
                cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
                if (SCREEN_WIDTH > 320.0)
                {
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
            }
            NSString *feature = [SmallPigTool makeHouseFeature:rowDic[@"roomFeature"] type:1];
            NSArray *array = [feature componentsSeparatedByString:@", "];
            NSString *string1 = @"";
            NSString *string2 = @"";
            NSString *string3 = @"";
            if (array && [array count] > 0)
            {
                string1 = array[0];
                if ([array count] > 1)
                {
                    string2 = array[1];
                }
                if ([array count] > 2)
                {
                    string3 = array[2];
                }
            }
            [(SecondHandHouseListCell *)cell setCellImageWithUrl:imageUrl titleText:title localText:local parkText:park priceText:roomPrice typeText:roomStyle sizeText:square advantage1Text:string1 advantage2Text:string2 advantage3Text:string3];
        }
        else if (HouseScourceFromRental == self.houseScource)
        {
            cell = (RentalHouseListCell *)[tableView dequeueReusableCellWithIdentifier:rentalHouseCellID];
            if (!cell)
            {
                cell = [[RentalHouseListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rentalHouseCellID];
                cell.backgroundColor = [UIColor whiteColor];
                cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
                if (SCREEN_WIDTH > 320.0)
                {
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
            }
            //@"http://b.pic1.ajkimg.com/display/xinfang/51255643cbafacad2f37506a86e1ccae/245x184c.jpg"
            [(RentalHouseListCell *)cell setCellImageWithUrl:imageUrl titleText:title localText:local parkText:park timeText:@"" typeText:roomStyle sizeText:square priceText:[NSString stringWithFormat:@"%.0f元",[rowDic[@"price"] floatValue]]];
        }

    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0)
    {
        if (indexPath.row == 1)
        {
            [self makeCall];
        }
    }
}


#pragma mark 打电话
- (void)makeCall
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.mobile]];
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"联系中介" message:self.mobile delegate:self cancelButtonTitle:@"拨打" otherButtonTitles:@"取消", nil];
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
