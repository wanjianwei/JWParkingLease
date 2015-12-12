//
//  JWCenterLeaseViewController.m
//  JWParkingLease
//
//  Created by jway on 15/12/11.
//  Copyright © 2015年 jway. All rights reserved.
//

#import "JWCenterLeaseViewController.h"

@interface JWCenterLeaseViewController ()

@end

@implementation JWCenterLeaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航栏设置
    self.title = @"车位出租";

    UIBarButtonItem * leftBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"open.png"] style:UIBarButtonItemStyleDone target:self action:@selector(openSlide)];
    self.navigationItem.leftBarButtonItem = leftBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)openSlide{
    
}

@end
