//
//  JWCenterLeaseViewController.m
//  JWParkingLease
//
//  Created by jway on 15/12/11.
//  Copyright © 2015年 jway. All rights reserved.
//

#import "JWCenterLeaseViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"

@interface JWCenterLeaseViewController ()

@end

@implementation JWCenterLeaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航栏设置
    self.title = @"车位出租";

    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(openSlide)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)openSlide{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

@end
