//
//  JWCenterGetParkingViewController.m
//  JWParkingLease
//
//  Created by jway on 15/12/11.
//  Copyright © 2015年 jway. All rights reserved.
//

#import "JWCenterGetParkingViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
@interface JWCenterGetParkingViewController ()

@end

@implementation JWCenterGetParkingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化导航栏
    self.title = @"车位租赁";
    
    
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(openSlide)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
    
    
    UIBarButtonItem * rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"武汉" style:UIBarButtonItemStyleDone target:self action:@selector(chooseCity)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
   // UIBarButtonItem * leftBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"open.png"] style:UIBarButtonItemStyleDone target:self action:@selector(openSlide)];
   // self.navigationItem.leftBarButtonItem = leftBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//重新选择所在城市
-(void)chooseCity{
    
}

-(void)openSlide{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

@end
