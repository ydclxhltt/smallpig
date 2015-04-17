//
//  UpLevelToAgentViewController.m
//  SmallPig
//
//  Created by 陈磊 on 15/4/17.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "UpLevelToAgentViewController.h"

#define  LIST_HEIGHT    50.0
#define  PIC_HEIGHT     75.0
#define  LABEL_WIDTH    75.0

@interface UpLevelToAgentViewController ()
@property (nonatomic, strong) NSArray *titleArray;
@end

@implementation UpLevelToAgentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"审核资料";
    self.titleArray = @[@"地区:",@"证件类型:",@"证件号码:",@"开户行:",@"账户名:",@"银行卡号:",@"身份证:"];
    [self addBackItem];
    [self setNavBarItemWithTitle:@"提交" navItemType:rightItem selectorName:@"commitbuttonPressed:"];
    [self createUI];
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
}

#pragma mark  提交
- (void)commitbuttonPressed:(UIButton *)sender
{
    
}


#pragma mark - tableView代理

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.titleArray.count - 1)
    {
        return PIC_HEIGHT;
    }
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
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.backgroundColor = WHITE_COLOR;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        label = [CreateViewTool createLabelWithFrame:CGRectMake(10, 0, LABEL_WIDTH, cell.frame.size.height) textString:self.titleArray[indexPath.row] textColor:RGB(0, 0, 0) textFont:FONT(15.0)];
        label.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:label];
    }
    
    CGRect frame = label.frame;
    frame.size.height = (indexPath.row == self.titleArray.count - 1) ? PIC_HEIGHT : LIST_HEIGHT;
    label.frame = frame;
    
    label.text = self.titleArray[indexPath.row];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
