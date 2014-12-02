//
//  HomeViewController.m
//  SmallPig
//
//  Created by clei on 14/11/6.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "HomeViewController.h"
#import "LoginViewController.h"
@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self= [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
        // Custom initialization
        self.title=@"首页";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addPersonItem];
    [self addSearchItem];
    

    
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    UINavigationController  *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
    [self presentViewController:nav animated:YES completion:Nil];
    // Do any additional setup after loading the view.
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
