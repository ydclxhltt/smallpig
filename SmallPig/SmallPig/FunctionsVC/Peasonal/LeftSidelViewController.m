//
//  PeasonalViewController.m
//  SmallPig
//
//  Created by chenlei on 14/11/5.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "LeftSidelViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"

@interface LeftSidelViewController ()
{
    //个人头像视图
    UIImageView *personIconImageView;
    //个人名称
    UILabel *personNameLabel;
}
//列表title数组
@property(nonatomic, retain)NSArray *titleArray;
@end

@implementation LeftSidelViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //背景颜色
    self.view.backgroundColor = LEFT_SIDE_BG_COLOR;
    
    //初始化视图起始坐标
    startHeight = 65.0;
    
    //头像
    UIImage *personIconDefaultImage = [UIImage imageNamed:@"person_icon_default"];
    float width = personIconDefaultImage.size.width/2;
    float height = personIconDefaultImage.size.height/2;
    personIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake((LEFT_SIDE_WIDTH - width)/2, startHeight, width, height)];
    personIconImageView.userInteractionEnabled = YES;
    personIconImageView.image = personIconDefaultImage;
    [self.view addSubview:personIconImageView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(isNeedLogin)];
    //点击的次数
    tapGesture.numberOfTapsRequired = 1; // 单击
    //点击的手指数
    tapGesture.numberOfTouchesRequired = 1;
    [personIconImageView addGestureRecognizer:tapGesture];
    
    
    startHeight += height + 10;
    
    //个人名字
    personNameLabel = [CreateViewTool createLabelWithFrame:CGRectMake(0, startHeight, LEFT_SIDE_WIDTH, 20) textColor:WHITE_COLOR textFont:PERSON_NAME_FONT];
    personNameLabel.textAlignment = NSTextAlignmentCenter;
    personNameLabel.text = @"未登录";
    [self.view addSubview:personNameLabel];
    
     startHeight += personNameLabel.frame.size.height + 10;

    //添加表
    [self addTableViewWithFrame:CGRectMake(20, startHeight, LEFT_SIDE_WIDTH - 20, SCREEN_HEIGHT - startHeight) tableType:UITableViewStyleGrouped tableDelegate:self];
    self.table.separatorColor = LIFT_SIDE_SEPLINE_COLOR;
    
    
    self.titleArray = @[@[@"房源信息",@"个人中心",@"我的收藏",@"设置"],@[@"经纪人平台"]];
    // Do any additional setup after loading the view.
}


- (void)isNeedLogin
{
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    UINavigationController  *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
    [self presentViewController:nav animated:YES completion:Nil];
}

#pragma mark  tableView委托方法

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return LEFT_SIDE_LIST_HEIGHT;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.titleArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.titleArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"PersonCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundView = nil;
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.imageView.transform = CGAffineTransformScale(cell.imageView.transform, .5, .5);
        cell.textLabel.textColor = WHITE_COLOR;
    }
    int index = 0;
    if (indexPath.section == 0)
    {
        index = indexPath.row;
    }
    else if(indexPath.section == 1)
    {
        index = [[self.titleArray objectAtIndex:0] count] + indexPath.row;
    }
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"menu_icon%d",index + 1]];
    cell.textLabel.text = [[self.titleArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.font = FONT(16.0);
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UINavigationController *nav = (UINavigationController *)app.sideViewController.rootViewController;
    if (indexPath.row == 0)
    {
        if (indexPath.section == 0)
            [nav popToRootViewControllerAnimated:YES];
        else if (indexPath.section == 1)
            [self pushToViewControllerWithIndex:4];
    }
    else
    {
        [self pushToViewControllerWithIndex:indexPath.row];
    }
}

#pragma mark 跳转相关界面
//跳转相关界面
- (void)pushToViewControllerWithIndex:(int)index
{
    
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
