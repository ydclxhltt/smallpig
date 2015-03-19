//
//  AgentHouseInfoViewController.m
//  SmallPig
//
//  Created by clei on 15/1/30.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "AgentHouseInfoViewController.h"
#import "AgentFormInfoViewController.h"
#import "LeftRightLableCell.h"
#import "AgentLabelsListViewController.h"
#import "AddPicView.h"
#import "HouseLabelsView.h"
#import "AssetPickerController.h"

#define ROW_NORMAL_HEIGHT   44.0
#define ROW_PIC_HEIGHT      85.0
#define ROW_LABEL_HEIGHT    75.0
#define ROW_TEXTVIEW_HEIGHT 60.0
#define LABELS_HEIGHT       25.0
@interface AgentHouseInfoViewController ()<UIActionSheetDelegate,AddPicViewDelegate,AssetPickerControllerDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    float sectionCount;
    AddPicView *picView;
    HouseLabelsView *houseLabelsView;
    HouseLabelsView *houseGoodLabelsView;
    UITextField *titleTextField;
    UITextView *contentTextView;
    float labelsHeight;
    float goodLabelsHeight;
}
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) NSArray *titleArray;
//选择选项后保存选中的数据
@property (nonatomic, strong) NSMutableDictionary *labelDic;
//保存点过的ID
@property (nonatomic, strong) NSMutableArray *paramArray;
@property (nonatomic, strong) NSArray *houseLabelArray;
@property (nonatomic, strong) NSArray *houseGoodLabelArray;
@property (nonatomic, strong) NSString *roomID;
@end

@implementation AgentHouseInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置title
    NSString *title = (self.houseInfoType == HouseInfoTypePublic) ? @"1.填写房源信息" : @"房源详情";
    self.title = title;
    //添加item
    if (self.houseInfoType == HouseInfoTypePublic)
    {
        [self setNavBarItemWithTitle:@"下一步" navItemType:rightItem selectorName:@"nextButtonPressed:"];
    }
    [self addBackItem];
    //获取房屋标签
    self.houseLabelArray = [[SmallPigApplication shareInstance] houseLabelsArray];
    if (!self.houseLabelArray)
    {
        [APP_DELEGATE getHouseLabels];
        labelsHeight = ROW_LABEL_HEIGHT;
    }
    else
    {
        int row = ceil([self.houseLabelArray count]/4);
        labelsHeight = LABELS_HEIGHT * row + ADD_Y * (row - 1) + 2 * SPACE_Y  + LABEL_HEIGHT + ADD_Y;
    }
    self.houseGoodLabelArray = [[SmallPigApplication shareInstance] houseGoodLabelsArray];
    if (!self.houseGoodLabelArray)
    {
        [APP_DELEGATE getGoodHouseLabels];
        goodLabelsHeight = ROW_LABEL_HEIGHT;
    }
    else
    {
        int row = ceil([self.houseGoodLabelArray count]/4);
        goodLabelsHeight = LABELS_HEIGHT * row + ADD_Y * (row - 1) + 2 * SPACE_Y  + LABEL_HEIGHT + ADD_Y;
    }
    //初始化数据
    sectionCount = 7;
    
    self.titleArray = @[@[@" 方式"],@[@" 城市",@" 分区",@" 片区",@" 小区",@" 楼栋",@" 房间"],@[@" 价格",@" 面积",@" 搂层",@" 户型",@" 装修",@" 朝向"],@[@""],@[@"房源标签"],@[@"房源亮点"],@[@" 标题:",@" 描述:"]];
    _labelDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"",@"showName",@"",@"paramId",@"",@"paramCode",nil];
    _paramArray = [[NSMutableArray alloc] init];
    //初始化UI
    [self createUI];
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedLabel:) name:@"SelectedLabel" object:nil];
    // Do any additional setup after loading the view.
}

#pragma mark 初始化UI
- (void)createUI
{
    [self addTableView];
}

- (void)addTableView
{
    [self addTableViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) tableType:UITableViewStylePlain tableDelegate:self];
    self.table.backgroundColor = [UIColor clearColor];
    //self.table.separatorInset = UIEdgeInsetsZero;
}

#pragma mark 下一步
- (void)nextButtonPressed:(UIButton *)sender
{
    AgentFormInfoViewController *formInfoViewController = [[AgentFormInfoViewController alloc] init];
    [self.navigationController pushViewController:formInfoViewController animated:YES];
}

#pragma mark tableViewDelegate
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return sectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titleArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3)
    {
        return ROW_PIC_HEIGHT;
    }
    if (indexPath.section == 5)
    {
        return labelsHeight;
    }
    if (indexPath.section == 4)
    {
        return goodLabelsHeight;
    }
    else if (indexPath.section == 6)
    {
        if (indexPath.row == 1)
        {
            return ROW_TEXTVIEW_HEIGHT;
        }
    }
    return ROW_NORMAL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *leftRightCellID = @"LeftRightCell";
    static NSString *cellID = @"cellID";
    UITableViewCell *cell;
    
    if (indexPath.section < 3)
    {
        cell = (LeftRightLableCell *)[tableView dequeueReusableCellWithIdentifier:leftRightCellID];
        if (!cell)
        {
            cell = [[LeftRightLableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:leftRightCellID];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        [(LeftRightLableCell *)cell setLeftColor:[UIColor blackColor] rightColor:HOUSE_DETAIL_TITLE_COLOR];
        if ([self.dataArray[indexPath.section] count] > indexPath.row)
        {
            [(LeftRightLableCell *)cell setDataWithLeftText:self.titleArray[indexPath.section][indexPath.row] rightText:self.dataArray[indexPath.section][indexPath.row]];
        }
        else
        {
            [(LeftRightLableCell *)cell setDataWithLeftText:self.titleArray[indexPath.section][indexPath.row] rightText:@""];
        }

    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        
        for (UIView *view in cell.contentView.subviews)
        {
            [view removeFromSuperview];
        }
        
        if (indexPath.section == 3)
        {
            if (!picView)
            {
                picView = [[AddPicView alloc] initWithFrame:CGRectMake(15.0, 10.0, cell.frame.size.width - 2 * 15.0, 65.0)];
                picView.delegate = self;
                picView.maxPicCount = 4;
            }
            [cell.contentView addSubview:picView];
        }
        else if (indexPath.section == 4)
        {
            if (!houseGoodLabelsView)
            {
                houseGoodLabelsView = [[HouseLabelsView alloc] initWithFrame:CGRectMake(SPACE_X,0,cell.frame.size.width - 2 * SPACE_X,goodLabelsHeight) LablesTitle:self.titleArray[indexPath.section][indexPath.row]];
                houseGoodLabelsView.backgroundColor = [UIColor clearColor];
            }
            [houseGoodLabelsView setLabelsWithArray:self.houseGoodLabelArray];
            [cell.contentView addSubview:houseGoodLabelsView];
            
        }

        else if (indexPath.section == 5)
        {
            if (!houseLabelsView)
            {
                houseLabelsView = [[HouseLabelsView alloc] initWithFrame:CGRectMake(SPACE_X,0,cell.frame.size.width - 2 * SPACE_X,labelsHeight) LablesTitle:self.titleArray[indexPath.section][indexPath.row]];
                houseLabelsView.backgroundColor = [UIColor clearColor];
            }
            [houseLabelsView setLabelsWithArray:self.houseLabelArray];
            [cell.contentView addSubview:houseLabelsView];
            
        }
        else if (indexPath.section == 6)
        {
            if (indexPath.row == 0)
            {
                cell.textLabel.text = self.titleArray[indexPath.section][indexPath.row];
                cell.textLabel.font = FONT(15.0);
                if (!titleTextField)
                {
                    titleTextField = [CreateViewTool createTextFieldWithFrame:CGRectMake(60.0, 0, cell.frame.size.width - 65.0 - 10.0, cell.frame.size.height) textColor:HOUSE_LIST_TITLE_COLOR textFont:FONT(15.0) placeholderText:@"5-30个字,不能填写电话"];
                    titleTextField.delegate = self;
                }
                [cell.contentView addSubview:titleTextField];
            }
            else if (indexPath.row == 1)
            {
                cell.textLabel.text = @"";
                UILabel *titleLabel = [CreateViewTool createLabelWithFrame:CGRectMake(15.0, 5, 60.0, 20.0) textString:@" 描述:" textColor:[UIColor blackColor] textFont:FONT(15.0)];
                [cell.contentView  addSubview:titleLabel];
                if (!contentTextView)
                {
                    contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(60.0, 10.0, cell.frame.size.width - 65.0 - 10.0, ROW_TEXTVIEW_HEIGHT - 10.0)];
                    contentTextView.delegate = self;
                }
                [cell.contentView addSubview:contentTextView];
            }

        }
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.houseInfoType == HouseInfoTypePublic)
    {
        int section = (int)indexPath.section;
        int row = (int)indexPath.row;
        
        if (section == 0)
        {
            [self addActionSheetView];
        }
        else
        {
            if (section >= 2)
            {
                return;
            }
            if (!self.dataArray)
            {
                [CommonTool addAlertTipWithMessage:@"请选择方式"];
            }
            else
            {
                NSArray *array = self.dataArray[indexPath.section];
                if ([array count] < indexPath.row)
                {
                    NSString *tipString = [NSString stringWithFormat:@"请选择%@",self.titleArray[section][row - 1]];
                    [CommonTool addAlertTipWithMessage:tipString];
                }
                else
                {
                    self.selectedIndexPath = indexPath;
                    //获取列表
                    [self goToListView];
                }
            }
        }
    }
}


#pragma mark 方式
- (void)addActionSheetView
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"二手房",@"租房", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 2)
    {
        NSString *string = (buttonIndex == 0) ? @"二手房" : @"租房";
        [self setDataWithSection:0 row:0 value:string];
    }
}

#pragma mark 获取列表数据
- (void)goToListView
{
    int section = (int)self.selectedIndexPath.section;
    int row = (int)self.selectedIndexPath.row;
    AgentLabelsListViewController *listViewController = [[AgentLabelsListViewController alloc] init];
    listViewController.titleStr = self.titleArray[section][row];
    listViewController.paramStr = [self getparamWithRow:row];
    listViewController.isRoomList = (row == 5) ? YES : NO;
    UINavigationController *listNav = [[UINavigationController alloc] initWithRootViewController:listViewController];
    [self presentViewController:listNav animated:YES completion:Nil];
}

#pragma mark  获取参数
- (NSString *)getparamWithRow:(int)row
{
    NSString *paramStr = @"";
    
    if ([self.paramArray count] > row)
    {
        paramStr = self.paramArray[row];
        return paramStr;
    }
    
    if (row < 3)
    {
        paramStr = self.labelDic[@"paramId"];
        paramStr = (!paramStr || [@"" isEqualToString:paramStr]) ? @"AREA>COMMUNITY>BUILDING>ROOM" : [NSString stringWithFormat:@"AREA@%@>COMMUNITY>BUILDING>ROOM",paramStr];
    }
    else
    {
        paramStr = self.labelDic[@"paramCode"];
        if (row == 3)
        {
            paramStr= [NSString stringWithFormat:@"AREA>COMMUNITY$%@>BUILDING>ROOM",paramStr];
        }
        else if (row == 4)
        {
            paramStr= [NSString stringWithFormat:@"AREA>COMMUNITY>BUILDING$%@>ROOM",paramStr];
        }
        else if (row == 5)
        {
            paramStr= [NSString stringWithFormat:@"AREA>COMMUNITY>BUILDING>ROOM$%@",paramStr];
        }
    }
    [self.paramArray addObject:paramStr];
    return paramStr;
}


#pragma mark 选中选项
- (void)selectedLabel:(NSNotification *)notification
{
    NSDictionary *dic = (NSDictionary *)notification.object;
    [self.labelDic setValue:dic[@"paramId"] forKey:@"paramId"];
    NSString *showName = dic[@"showName"];
    if (self.selectedIndexPath.section == 1 && self.selectedIndexPath.row == 5)
    {
        showName = dic[@"model"][@"room"][@"showName"];
        self.roomID = dic[@"model"][@"room"][@"id"];
    }
    showName = (showName) ? showName : @"";
    [self.labelDic setValue:showName forKey:@"showName"];
    [self.labelDic setValue:dic[@"paramCode"] forKey:@"paramCode"];
    [self setDataWithSection:(int)self.selectedIndexPath.section row:(int)self.selectedIndexPath.row value:self.labelDic[@"showName"]];
    
    //清掉更改选项后面的数据
    if ([self.paramArray count] > self.selectedIndexPath.row + 1)
    {
        NSString *oldParamID = self.paramArray[self.selectedIndexPath.row + 1];
        NSString *paramID = dic[@"paramId"];
        paramID = [NSString stringWithFormat:@"AREA@%@>COMMUNITY>BUILDING>ROOM",paramID];
        
        if (self.selectedIndexPath.row >= 3)
        {
            paramID = dic[@"paramCode"];
            if (self.selectedIndexPath.row == 3)
            {
                paramID= [NSString stringWithFormat:@"AREA>COMMUNITY$%@>BUILDING>ROOM",paramID];
            }
            else if (self.selectedIndexPath.row == 4)
            {
                paramID= [NSString stringWithFormat:@"AREA>COMMUNITY>BUILDING$%@>ROOM",paramID];
            }
        }
        
        if (![oldParamID isEqualToString:paramID])
        {
            [self clearCacheData];
        }
    }
    
    //选完房间验证通过后 刷新表
    if (self.selectedIndexPath.section == 1 && self.selectedIndexPath.row == 5)
    {
        NSString *price = [NSString stringWithFormat:@"%.0f万",[dic[@"model"][@"price"] floatValue]/10000];
        NSString *square = [NSString stringWithFormat:@"%@",dic[@"model"][@"room"][@"square"]];
        square = (square) ? [square stringByAppendingString:@"平米"] : @"";
        NSString *floor= [NSString stringWithFormat:@"%@",dic[@"model"][@"room"][@"floor"]];
        floor = (floor) ? [floor stringByAppendingString:@"层"] : @"";
        int bedroomCount = [dic[@"model"][@"room"][@"bedroomCount"] intValue];
        int hallCount = [dic[@"model"][@"room"][@"hallCount"] intValue];
        int kitchenCount = [dic[@"model"][@"room"][@"kitchenCount"] intValue];
        int bathroomCount = [dic[@"model"][@"room"][@"bathroomCount"] intValue];
        NSString *roomType = [NSString stringWithFormat:@"%d室%d厅%d厨%d卫",bedroomCount,hallCount,kitchenCount,bathroomCount];
        NSString *roomFeature = [SmallPigTool getDecorateWithIndex:[dic[@"model"][@"room"][@"decorate"] intValue]];
        roomFeature = (roomFeature) ? roomFeature : @"";
        NSString *towards = dic[@"model"][@"room"][@"towards"];
        towards = (towards) ? towards : @"";
        towards = [SmallPigTool getTowardsWithIdentification:towards];
        
        NSArray *array = @[price,square,floor,roomType,roomFeature,towards];
        [self.dataArray replaceObjectAtIndex:self.selectedIndexPath.section + 1 withObject:array];
        sectionCount = 7;
        [self.table reloadData];
    }
}

- (void)clearCacheData
{
    int index = (int)self.selectedIndexPath.row;
    int section = (int)self.selectedIndexPath.section;
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i <= index; i++)
    {
        [array addObject:self.dataArray[section][i]];
    }
    [self.dataArray replaceObjectAtIndex:section withObject:array];
    [self.dataArray replaceObjectAtIndex:2 withObject:@[@"",@"",@"",@"",@"",@""]];
    sectionCount = 3;
    [self.table reloadData];
}


#pragma mark 设置数据
- (void)setDataWithSection:(int)section row:(int)row value:(NSString *)value
{
    if (!self.dataArray)
    {
        self.dataArray = [NSMutableArray arrayWithArray:@[@[],@[],@[],@[],@[],@[]]];
    }
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.dataArray[section]];
    if ([array count] < row + 1)
    {
        [array addObject:value];
    }
    else
    {
        [array replaceObjectAtIndex:row withObject:value];
    }
    
    [self.dataArray replaceObjectAtIndex:section withObject:array];
    [self.table reloadData];
}

#pragma mark 点击添加按钮
- (void)addPicButtonClicked:(AddPicView *)addPicView
{
    int maxCount = 4;
    if (addPicView.dataArray)
    {
        maxCount -= [addPicView.dataArray count];
    }
    AssetPickerController *picker = [[AssetPickerController alloc] init];
//    [picker.navigationController.navigationBar setBackgroundImage:[CommonTool imageWithColor:APP_MAIN_COLOR] forBarMetrics:UIBarMetricsDefault];
    [picker.navigationBar setTintColor:WHITE_COLOR];
    picker.maximumNumberOfSelection = maxCount;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups=NO;
    picker.delegate = self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings)
                              {
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo])
        {
            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 5;
        }
        else
        {
            return YES;
        }
    }];
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - AssetPickerController Delegate
-(void)assetPickerController:(AssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
    ^{
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i < assets.count; i++)
        {
            ALAsset *asset=assets[i];
            UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            [array addObject:tempImg];
        }
        dispatch_async(dispatch_get_main_queue(),
       ^{
           [picView setDataWithImageArray:array];
        });
    });
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//#pragma mark UITextViewDelegate
//
//- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
//{
//    [textView resignFirstResponder];
//    return YES;
//}
//
//- (void)textViewDidEndEditing:(UITextView *)textView
//{
//    [textView resignFirstResponder];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
