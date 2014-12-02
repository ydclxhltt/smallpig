//
//  PeasonalViewController.m
//  SmallPig
//
//  Created by chenlei on 14/11/5.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "PeasonalViewController.h"

@interface PeasonalViewController ()
{
    //个人头像视图
    UIImageView *personIconImageView;
    //个人名称
    UILabel *personNameLabel;
    //列表title数组
    NSArray *titleArray;
}
@end

@implementation PeasonalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //背景颜色
    self.view.backgroundColor = RGB(38.0, 38.0, 38.0);
    
    //初始化视图起始坐标
    startHeight = 65.0;
    
    //头像
    UIImage *personIconDefaultImage = [UIImage imageNamed:@"person_icon_default"];
    float width = personIconDefaultImage.size.width/2;
    float height = personIconDefaultImage.size.height/2;
    personIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake((LEFT_SIDE_WIDTH - width)/2, startHeight, width, height)];
    personIconImageView.image = personIconDefaultImage;
    [self.view addSubview:personIconImageView];
    
    startHeight += height + 10;
    
    //个人名字
    personNameLabel = [CreateViewTool createLabelWithFrame:CGRectMake(0, startHeight, LEFT_SIDE_WIDTH, 20) textColor:WIHTE_COLOR textFont:PERSON_NAME_FONT];
    personNameLabel.textAlignment = NSTextAlignmentCenter;
    personNameLabel.text = @"未登录";
    [self.view addSubview:personNameLabel];
    
     startHeight += personNameLabel.frame.size.height + 10;

    //添加表
    [self addTableViewWithFrame:CGRectMake(20, startHeight, LEFT_SIDE_WIDTH - 20, SCREEN_HEIGHT - startHeight) tableType:UITableViewStyleGrouped tableDelegate:self];
    self.table.separatorColor = RGB(47.0, 47.0, 47.0);
    
    
    titleArray = [[NSArray alloc] initWithObjects:@"个人信息",@"安全中心",@"我的订单",@"我的积分",@"我的收藏",@"设置",nil];
    // Do any additional setup after loading the view.
}

#pragma mark  tableView委托方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.imageView.transform = CGAffineTransformScale(cell.imageView.transform, .5, .5);
        cell.textLabel.textColor = WIHTE_COLOR;
    }
    int index = (int)(indexPath.section*2 + indexPath.row);
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"Sidebar_icon%d",index + 1]];
    cell.textLabel.text = [titleArray objectAtIndex:index];
    cell.textLabel.font = FONT(16.0);
    return cell;
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
