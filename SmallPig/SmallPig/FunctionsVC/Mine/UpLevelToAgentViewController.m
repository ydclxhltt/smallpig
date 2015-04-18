//
//  UpLevelToAgentViewController.m
//  SmallPig
//
//  Created by 陈磊 on 15/4/17.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "UpLevelToAgentViewController.h"
#import "AddPicView.h"
#import "AssetPickerController.h"
#import "CLPickerView.h"

#define  LIST_HEIGHT    44.0
#define  PIC_ROW_HEIGHT 75.0
#define  PIC_HEIGHT     65.0
#define  LABEL_WIDTH    75.0
#define  SPACE_X        10.0
#define  OFFSET_Y       480.0 - 568.0

@interface UpLevelToAgentViewController ()<AddPicViewDelegate,AssetPickerControllerDelegate,UITextFieldDelegate,UIScrollViewDelegate>
{
    AddPicView *picView;
    UITextField *currentTextField;
}
@property (nonatomic, strong) CLPickerView *pickView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *nidType;
@property (nonatomic, strong) NSString *nidString;
@property (nonatomic, strong) NSString *bankName;
@property (nonatomic, strong) NSString *bankUerName;
@property (nonatomic, strong) NSString *bankNumber;
//@property (nonatomic, strong) NSString *nidType;
@end

@implementation UpLevelToAgentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"审核资料";
    //self.titleArray = @[@"地区:",@"证件类型:",@"证件号码:",@"开户行:",@"账户名:",@"银行卡号:",@"身份证:"];
    self.titleArray = @[@"地区:",@"证件类型:",@"证件号码:",@"开户行:",@"账户名:",@"银行卡号:"];
    [self addBackItem];
    [self setNavBarItemWithTitle:@"提交" navItemType:rightItem selectorName:@"commitbuttonPressed:"];
    [self createUI];
    // Do any additional setup after loading the view.
}

#pragma mark 初始化UI
- (void)createUI
{
    [self addTableView];
    [self createPickerView];
}

- (void)addTableView
{
    [self addTableViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) tableType:UITableViewStylePlain tableDelegate:self];
}

- (void)createPickerView
{
    __block typeof(self) weakSelf = self;
    self.pickView = [[CLPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 240.0) pickerViewType:PickerViewTypeCustom
                    customSureBlock:^(CLPickerView *pickerView, int index)
                    {
                        NSDictionary *dic = pickerView.dataArray[index];
                        currentTextField.text = dic[@"showName"];
                        [currentTextField resignFirstResponder];
                        int tag = (int)currentTextField.tag;
                        if (tag == 101)
                        {
                            weakSelf.city = dic[@"paramCode"];
                        }
                        else if (tag == 102)
                        {
                            weakSelf.nidType = dic[@"paramCode"];
                        }
                        else if (tag == 104)
                        {
                            weakSelf.bankName = dic[@"paramCode"];
                        }
                    }
                    cancelBlock:^
                    {
                        [currentTextField resignFirstResponder];
                    }
                    pickerData:nil];

}

#pragma mark  提交
- (void)commitbuttonPressed:(UIButton *)sender
{
    [self isMoveTableView:NO];
    if ([self isCanCommit])
    {
        [self commitInfomation];
    }
}

- (BOOL)isCanCommit
{
    NSString *message = @"";
    if (!self.city || self.city.length == 0)
    {
        message = @"请选择地区";
    }
    else if (!self.nidType || self.nidType.length == 0)
    {
        message = @"请选择证件类型";
    }
    else if (!self.nidString || self.nidString.length == 0)
    {
        message = @"请输入证件号码";
    }
    else if (!self.bankName || self.bankName.length == 0)
    {
        message = @"请选择开户行";
    }
    else if (!self.bankUerName || self.bankUerName.length == 0)
    {
        message = @"请填写账户名";
    }
    else if (!self.bankNumber || self.bankNumber.length == 0)
    {
        message = @"请填写银行卡号";
    }
//    else if (!picView.picListArray || picView.picListArray.count < 2)
//    {
//        message = @"请上传身份证正反面照片";
//    }
    else if ([self.nidType intValue] == 1)
    {
        if (![CommonTool validateIdentityCard:self.nidString])
        {
            message = @"请输入正确的证件号";
        }
    }
    if (message.length == 0)
    {
        return YES;
    }
    [CommonTool addAlertTipWithMessage:message];
    return NO;
}

#pragma mark 
- (void)commitInfomation
{
    [SVProgressHUD showWithStatus:@"正在提交..."];

    NSString *url = [UPLEVEL_URL stringByAppendingString:@"?"];
   
//    if (picView.picListArray && picView.picListArray.count >0)
//    {
//        for (int i = 0; i < picView.picListArray.count; i++)
//        {
//             NSString *string = @"&";
//            if (i == 0)
//            {
//                string = @"";
//            }
//            url = [NSString stringWithFormat:@"%@%@photoList.id=%@",url,string,picView.picListArray[i]];
//        }
//    }
    
    NSDictionary  *requestDic = @{@"id":[SmallPigApplication shareInstance].userID,@"city":self.city,@"nidType":self.nidType,@"nid":self.nidString,@"bankName":self.bankName,@"bankAcctName":self.bankUerName,@"bankCard":self.bankNumber};
    NSLog(@"requestDic====%@=====url===%@",requestDic,url);
    RequestTool *request = [[RequestTool alloc] init];
    [request requestWithUrl:url requestParamas:requestDic requestType:RequestTypeAsynchronous
              requestSucess:^(AFHTTPRequestOperation *operation, id responseDic)
     {
         NSLog(@"responseDic====%@",operation.responseString    );
         
         int sucessCode = [responseDic[@"responseMessage"][@"success"] intValue];
         if (sucessCode == 1)
         {
             [SVProgressHUD showSuccessWithStatus:@"提交成功"];
             [self.navigationController popViewControllerAnimated:YES];
         }
         else
         {
             NSString *message = responseDic[@"responseMessage"][@"message"];
             message = (message) ? message : @"";
             [SVProgressHUD showErrorWithStatus:[@"提交失败 " stringByAppendingString:message]];
         }
         
     }
    requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [SVProgressHUD showErrorWithStatus:@"提交失败"];
     }];

}


#pragma mark - tableView代理

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row == self.titleArray.count - 1)
//    {
//        return PIC_ROW_HEIGHT;
//    }
    return LIST_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titleArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"CellID";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    UILabel *label = (UILabel *)[cell viewWithTag:100];
    UITextField *textField = (UITextField *)[cell viewWithTag:(int)indexPath.row + 101];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.backgroundColor = WHITE_COLOR;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        label = [CreateViewTool createLabelWithFrame:CGRectMake(10, 0, LABEL_WIDTH, cell.frame.size.height) textString:self.titleArray[indexPath.row] textColor:RGB(0, 0, 0) textFont:FONT(15.0)];
        label.tag = 100;
        label.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:label];
        
        textField = [CreateViewTool createTextFieldWithFrame:CGRectMake(label.frame.origin.x + label.frame.size.width + SPACE_X, 0, cell.frame.size.width - (label.frame.origin.x + label.frame.size.width + SPACE_X + 30.0), cell.frame.size.height) textColor:[UIColor grayColor] textFont:FONT(15.0) placeholderText:@""];
        textField.tag = indexPath.row + 101;
        textField.delegate = self;
        textField.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:textField];
    }
    
//    CGRect frame = label.frame;
//    frame.size.height = (indexPath.row == self.titleArray.count - 1) ? PIC_ROW_HEIGHT : LIST_HEIGHT;
//    label.frame = frame;
    label.text = self.titleArray[indexPath.row];
    
    int maxCount = 2;
    if (!picView)
    {
        picView = [[AddPicView alloc] initWithFrame:CGRectMake(cell.frame.size.width - 30.0 - maxCount * PIC_HEIGHT  - maxCount * SPACE_X, (PIC_ROW_HEIGHT - PIC_HEIGHT)/2 , maxCount * PIC_HEIGHT  + maxCount * SPACE_X, PIC_HEIGHT)];
        picView.delegate = self;
        picView.maxPicCount = maxCount;
    }

//    textField.frame = CGRectMake(textField.frame.origin.x, textField.frame.origin.y, textField.frame.size.width, frame.size.height);
//    if (indexPath.row == self.titleArray.count - 1)
//    {
//        textField.hidden =  YES;
//        [cell.contentView addSubview:picView];
//    }
    
    if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 3)
    {
        textField.inputView = self.pickView;
    }
    else
    {
        if (indexPath.row == 2)
        {
            textField.keyboardType = UIKeyboardTypeNamePhonePad;
        }
        if (indexPath.row == 5)
        {
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark 点击添加按钮
- (void)addPicButtonClicked:(AddPicView *)addPicView
{
    int maxCount = 2;
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
                                          [picView setDataWithImageArray:array upLoadType:4];
                                      });
                   });
}


#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    currentTextField = textField;
    int tag = (int)textField.tag;
    NSArray *array = nil;
    switch (tag)
    {
        case 101:
            array = [SmallPigApplication shareInstance].citysArray;
            break;
        case 102:
            array = [SmallPigApplication shareInstance].nidTypeArray;
            break;
        case 104:
            array = [SmallPigApplication shareInstance].openBankArray;
            break;
        default:
            break;
    }
    self.pickView.dataArray = array;
    
    if (tag == 105 || tag == 106)
    {
        if (SCREEN_HEIGHT == 480.0)
        {
            [self isMoveTableView:YES];
        }
    }

    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    int tag = (int)textField.tag;
    NSString *text = textField.text;
    text = (text) ? text : @"";
    switch (tag)
    {
        case 103:
            self.nidString = text;
            break;
        case 105:
            self.bankUerName = text;
            break;
        case 106:
            self.bankNumber = text;
            break;
        default:
            break;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark moveTable
- (void)isMoveTableView:(BOOL)isMove
{
    [UIView animateWithDuration:.3 animations:^
    {
        self.table.transform = CGAffineTransformMakeTranslation(0, (isMove) ? OFFSET_Y : 0.0);
    }];
}


#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self isMoveTableView:NO];
    [currentTextField resignFirstResponder];
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
