//
//  MineViewController.m
//  SmallPig
//
//  Created by clei on 14/11/6.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "MineViewController.h"
#import "CheckCodeViewController.h"
#import "ChangePasswordViewController.h"
#import "InformAgainstViewController.h"
#import "UpLoadPhotoTool.h"
#import "OrderListViewController.h"
#import "UpLevelToAgentViewController.h"
#import "MineOrderListViewController.h"

@interface MineViewController ()<UIAlertViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UploadPhotoDelegate>
{
    NSDictionary *userDic;
}
@property(nonatomic,strong) NSString *userName;
@property(nonatomic,strong) NSString *statusString;
@end

@implementation MineViewController


- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self= [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
        // Custom initialization
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置title
    self.title = MINE_CENTER_TITLE;
    //添加侧滑item
    [self addPersonItem];
    [self setNavBarItemWithTitle:@" 注销" navItemType:rightItem selectorName:@"exitButtonPressed:"];
    //初始化数据
    userDic = [SmallPigApplication shareInstance].userInfoDic;
    if ([SmallPigApplication shareInstance].memberType == 0)
    {
        self.dataArray = (NSMutableArray *)@[@[@"头像",@"昵称",@"性别"],@[@"密码修改",@"绑定手机"],@[@"举报管理",@"升级为经纪人"],@[@"我的订单"]];
    }
    else
    {
        self.dataArray = (NSMutableArray *)@[@[@"头像",@"昵称",@"性别"],@[@"密码修改",@"绑定手机"],@[@"举报管理"],@[@"我的订单"]];
    }

    //初始化UI
    [self createUI];
    //[self loadData];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setMainSideCanSwipe:YES];
    userDic = [SmallPigApplication shareInstance].userInfoDic;
    [self.table reloadData];
}


#pragma mark
- (void)createUI
{
    [self addTableViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) tableType:UITableViewStylePlain tableDelegate:self];
}

#pragma mark 注销
- (void)exitButtonPressed:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ExitLogin" object:nil];
}

- (void)loadData
{
    [SVProgressHUD showWithStatus:LOADING_DEFAULT];
    __block typeof(self) weakSelf = self;
    RequestTool *request = [[RequestTool alloc] init];
    [request requestWithUrl:UPLEVEL_STATUS_URL requestParamas:nil requestType:RequestTypeSynchronous
              requestSucess:^(AFHTTPRequestOperation *operation, id responseDic)
     {
         NSLog(@"responseDic===%@",responseDic);
         NSDictionary *dic = (NSDictionary *)responseDic;
         if ([dic[@"responseMessage"][@"success"] intValue] == 1)
         {
             NSString *status = [NSString stringWithFormat:@"%@",responseDic[@"model"][@"apprStatus"]];
             status = (status) ? status : @"-1";
             weakSelf.statusString = status;
             [weakSelf.table reloadData];
             NSString *message = @"";
             if ([weakSelf.statusString intValue] == 2)
             {
                 message = responseDic[@"model"][@"apprmemo"];
                 message = (message) ? message : @"审核不通过,请重新提交资料审核...";
             }
             if ([weakSelf.statusString intValue] == 1)
             {
                 message = @"审核中,请耐心等待...";
             }
             if (message.length != 0)
             {
                 [CommonTool addAlertTipWithMessage:message];
             }
             [SVProgressHUD showSuccessWithStatus:LOADING_SUCESS];
         }
         else
         {
             NSString *message = dic[@"responseMessage"][@"message"];
             message = (message) ? message : LOADING_FAILURE;
             [SVProgressHUD showErrorWithStatus:message];
         }
         
     }
    requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"error===%@",error);
         [SVProgressHUD showErrorWithStatus:LOADING_FAILURE];
     }];

}

#pragma mark - tableView代理


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *imageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20.0) placeholderImage:nil];
    imageView.backgroundColor = [UIColor clearColor];
    return imageView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0 && indexPath.section == 0)
    return MINE_CENTER_ICON_HEIGHT;
    return 44.0;
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
    static NSString *homeCellID = @"mineCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:homeCellID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:homeCellID];
        cell.backgroundColor = WHITE_COLOR;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
    float right_width = 30.0;
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            UIImage *defaultImage = [UIImage imageNamed:@"user_default.png"];
            UIImageView *userIconImageView = [CreateViewTool createRoundImageViewWithFrame:CGRectMake(SCREEN_WIDTH - defaultImage.size.width/2 - right_width, (MINE_CENTER_ICON_HEIGHT - defaultImage.size.height/2)/2, defaultImage.size.width/2, defaultImage.size.height/2) placeholderImage:defaultImage borderColor:nil imageUrl:@""];
            ;
            NSString *imageUrl = userDic[@"url"];
            imageUrl = ([imageUrl isKindOfClass:[NSNull class]] || !imageUrl) ? @"" : imageUrl;
            NSLog(@"imageUrl===%@",imageUrl);
            [userIconImageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:defaultImage];
            [cell.contentView addSubview:userIconImageView];
        }
        else
        {
            UILabel *label = [CreateViewTool createLabelWithFrame:CGRectMake(SCREEN_WIDTH - 120 - right_width, 0 , 120, cell.frame.size.height) textString:@"" textColor:MINE_CENTER_LIST_COLOR textFont:MINE_CENTER_LIST_FONT];
            label.textAlignment = NSTextAlignmentRight;
            
            NSString *nickName = userDic[@"nickName"];
            NSString *name = userDic[@"name"];
            name = (name) ? name : @"";
            nickName = (nickName) ? nickName : @"";
            self.userName = (nickName && ![@"" isEqualToString:nickName]) ? nickName : name;
            label.text = self.userName;
            
            if (indexPath.row == 2)
            {
                NSString *sexString = userDic[@"sex"];
                NSLog(@"userDic[@\"sex\"]====%@",userDic[@"sex"]);
                if (![sexString isKindOfClass:[NSNull class]])
                {
                    int sex = [sexString intValue];
                    label.text = (sex == 1) ? @"男" : @"女";
                    if (sex == 2)
                    {
                        label.text = @"女";
                    }
                    else if (sex == 1)
                    {
                        label.text = @"男";
                    }
                    else
                    {
                        label.text = @"未设置";
                    }
                }
                else
                {
                    label.text = @"未设置";
                }
            }
            [cell.contentView addSubview:label];
        }
    }
    
    if (indexPath.section == 1)
    {
        if (indexPath.row == 1)
        {
            UILabel *label = [CreateViewTool createLabelWithFrame:CGRectMake(SCREEN_WIDTH - 120 - right_width, 0 , 120, cell.frame.size.height) textString:@"" textColor:MINE_CENTER_LIST_COLOR textFont:MINE_CENTER_LIST_FONT];
            label.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:label];
            
            NSString *phoneNumber = userDic[@"mobile"];
            phoneNumber = (phoneNumber) ? phoneNumber : @"";
            if (phoneNumber.length == 11)
            {
                phoneNumber = [phoneNumber stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            }
            label.text = phoneNumber;
        }
    }
    
    if (indexPath.section == 2)
    {
        if (indexPath.row == 1)
        {
            NSString *status = @"";
            if (self.statusString)
            {
                if ([self.statusString intValue] == -1)
                {
                    status = @"未升级";
                }
                else if ([self.statusString intValue] == 0)
                {
                    status = @"审核中";
                }
                else if ([self.statusString intValue] == 1)
                {
                    status = @"审核通过";
                }
                else if ([self.statusString intValue] == 2)
                {
                    status = @"审核不通过";
                }
            }
            UILabel *label = [CreateViewTool createLabelWithFrame:CGRectMake(SCREEN_WIDTH - 80 - right_width, 0 , 80, cell.frame.size.height) textString:status textColor:MINE_CENTER_LIST_TIP_COLOR textFont:MINE_CENTER_LIST_TIP_FONT];
            label.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:label];
        }
    }
    if (indexPath.section == 3)
    {

    }
    
    NSArray *array = [self.dataArray objectAtIndex:indexPath.section];
    cell.textLabel.text = [array objectAtIndex:indexPath.row];
    cell.textLabel.font = SYSTEM_LIST_FONT;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int row  = (int)indexPath.row;
    if (indexPath.section == 0)
    {
        if (row == 0)
        {
            //头像
            [self setUserIcon];
            
        }
        else if (row == 1)
        {
            //昵称
            [self addChangeNickNameView];
        }
        else if (row == 2)
        {
            //性别
            [self addChangeSexView];
        }
    }
    else if (indexPath.section == 1)
    {
        if (row == 0)
        {
            //修改密码
            ChangePasswordViewController *changePasswordViewController = [[ChangePasswordViewController alloc] init];
            [self.navigationController pushViewController:changePasswordViewController animated:YES];
        }
        else if (row ==1)
        {
            //修改手机号
            CheckCodeViewController *checkCodeViewController = [[CheckCodeViewController alloc] init];
            checkCodeViewController.pushType = PushTypeChangeMobile;
            [self.navigationController pushViewController:checkCodeViewController animated:YES];
        }
    }
    else if (indexPath.section == 2)
    {
        if (row == 0)
        {
            //举报管理
            InformAgainstViewController *informAgainstViewController = [[InformAgainstViewController alloc] init];
            [self.navigationController pushViewController:informAgainstViewController animated:YES];
        }
        else if (row == 1)
        {
            //升级经纪人
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:ALIPAY_LOGIN_URL]];
            [self upLevelToAgent];
        }
    }
    else if (indexPath.section == 3)
    {
        UIViewController *viewController = nil;
        if ([SmallPigApplication shareInstance].memberType != 0)
        {
            OrderListViewController *orderListViewController = [[OrderListViewController alloc] init];
            viewController = orderListViewController;
        }
        else
        {
             MineOrderListViewController *orderListViewController = [[MineOrderListViewController alloc] init];
            viewController = orderListViewController;
        }
       
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

#pragma mark 修改头像
- (void)setUserIcon
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择",@"拍照",nil];
        actionSheet.tag = 100;
        [actionSheet showInView:self.view];
    }
    else
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择",nil];
        actionSheet.tag = 101;
        [actionSheet showInView:self.view];
    }
    
}

#pragma mark 修改昵称
- (void)addChangeNickNameView
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"修改昵称" message:nil delegate:self cancelButtonTitle:@"修改" otherButtonTitles:@"取消", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
    
    UITextField *textField = [alertView textFieldAtIndex:0];
    textField.text = self.userName;
    textField.placeholder = @"昵称不能为空";
    [textField becomeFirstResponder];
}

#pragma mark 修改性别
- (void)addChangeSexView
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"修改性别" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
    actionSheet.tag = 102;
    [actionSheet showInView:APP_DELEGATE.window];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if ([@"修改" isEqualToString:title])
    {
        UITextField *textField = [alertView textFieldAtIndex:0];
        if ([@"" isEqualToString:textField.text])
        {
            [self addChangeNickNameView];
            return;
        }
        else
        {
            if ([self.userName isEqualToString:textField.text])
            {
                return;
            }
            else
            {
                [self changePersonalRequestWithNickname:textField.text userSex:@"-1"];
            }
        }
    }
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"取消"])
    {
        return;
    }
    else if (actionSheet.tag == 102 && buttonIndex != 2)
    {
        [self changePersonalRequestWithNickname:@"" userSex:[NSString stringWithFormat:@"%d",(int)buttonIndex + 1]];
    }
    else
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.allowsEditing = YES;
        picker.delegate = self;
        if (![title isEqualToString:@"取消"])
        {
            picker.sourceType = (buttonIndex == 0) ? UIImagePickerControllerSourceTypePhotoLibrary : UIImagePickerControllerSourceTypeCamera;
        }
        [self presentViewController:picker animated:YES completion:Nil];
    }
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
     NSLog(@"info===%@",info);
    [picker dismissViewControllerAnimated:YES completion:Nil];
   
    UpLoadPhotoTool *upLoadTool = [[UpLoadPhotoTool alloc] initWithPhotoArray:@[image] upLoadUrl:UPLOAD_ICON_URL upLoadType:3];
    upLoadTool.delegate = self;
}

#pragma mark UpLoadPhotoDelegate
- (void)uploadPhotoSucessed:(UpLoadPhotoTool *)upLoadPhotoTool
{
    [SVProgressHUD showSuccessWithStatus:@"上传成功"];
    NSDictionary *dic = upLoadPhotoTool.responseDic;
    NSString *photoUrl = dic[@"model"][@"avatarPhoto"][@"photoUrl"];
    NSString *photoSize = @"0";
    NSString *photoType = dic[@"model"][@"avatarPhoto"][@"photoType"];
    NSString *iconID = dic[@"model"][@"avatarPhoto"][@"id"];
    NSString *url = [SmallPigTool makePhotoUrlWithPhotoUrl:photoUrl photoSize:photoSize photoType:photoType];
    NSLog(@"url===%@",url);
    NSDictionary *newUserDic = [NSMutableDictionary dictionaryWithDictionary:[SmallPigApplication shareInstance].userInfoDic];
    [newUserDic setValue:url forKey:@"url"];
    [SmallPigApplication shareInstance].userInfoDic = newUserDic;
    [self updatePersonWithIconID:iconID];
    [self viewWillAppear:YES];
}
- (void)uploadPhotoFailed:(UpLoadPhotoTool *)upLoadPhotoTool
{
    [SVProgressHUD showErrorWithStatus:@"上传失败"];
}

- (void)isUploadingPhotoWithProcess:(float)process
{
    [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"已上传%.1f％",process * 100]];
}

#pragma mark 更新个人信息
- (void)updatePersonWithIconID:(NSString *)iconID
{
    iconID = (iconID) ? iconID : @"";
    NSDictionary  *requestDic = @{@"id":userDic[@"id"],@"avatarPhoto.id":iconID};
    RequestTool *request = [[RequestTool alloc] init];
    [request requestWithUrl:UPDATE_ICON_URL requestParamas:requestDic requestType:RequestTypeAsynchronous requestSucess:^
     (AFHTTPRequestOperation *operation, id responseDic)
     {
         NSLog(@"UPDATE_ICON_URL.responseString%@",operation.responseString);
     }
    requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
     }];
}

#pragma mark 修改个人信息请求
- (void)changePersonalRequestWithNickname:(NSString *)nickName userSex:(NSString *)sex
{
    NSDictionary *requestDic;
    if ([sex intValue] == -1)
    {
        requestDic = @{@"nickName":nickName,@"id":userDic[@"id"]};
    }
    else
    {
        requestDic = @{@"sex":sex,@"id":userDic[@"id"]};
    }
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"正在保存..."];
    RequestTool *request = [[RequestTool alloc] init];
    [request requestWithUrl:CHANGE_PERSONAL_URL requestParamas:requestDic requestType:RequestTypeAsynchronous
    requestSucess:^(AFHTTPRequestOperation *operation, id responseDic)
    {
        NSLog(@"changePersonalResponse===%@",responseDic);
        NSDictionary *dic = (NSDictionary *)responseDic;
        if ([dic[@"responseMessage"][@"success"] intValue] == 1)
        {
            [SmallPigApplication shareInstance].userInfoDic = dic[@"model"];
            userDic = [SmallPigApplication shareInstance].userInfoDic;
            [weakSelf.table reloadData];
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
        }
        else
        {
            NSString *message = dic[@"responseMessage"][@"message"];
            message = (message) ? message : @"修改失败";
            [SVProgressHUD showErrorWithStatus:message];
        }

    }
    requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"error===%@",error);
        [SVProgressHUD showErrorWithStatus:@"修改失败"];
    }];
}

#pragma mark 升级经纪人
- (void)upLevelToAgent
{
    if (!self.statusString)
    {
        [self loadData];
    }
    if ([self.statusString intValue] == -1 || [self.statusString intValue] == 2)
    {
        UpLevelToAgentViewController *upLevelToAgentViewController = [[UpLevelToAgentViewController alloc] init];
        [self.navigationController pushViewController:upLevelToAgentViewController animated:YES];
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
