//
//  JWLeftViewController.m
//  JWParkingLease
//
//  Created by jway on 15/12/11.
//  Copyright © 2015年 jway. All rights reserved.
//

#import "JWLeftViewController.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+MMDrawerController.h"

#import "JWCenterGetParkingViewController.h"
#import "JWCenterLeaseViewController.h"

@interface JWLeftViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView * operationList;

@end

@implementation JWLeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.operationList = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _operationList.delegate = self;
    _operationList.dataSource = self;
    [_operationList setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    _operationList.scrollEnabled = NO;
    _operationList.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    //初始时是先指定在“车位出租”单元格
    [_operationList selectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    [[NSUserDefaults standardUserDefaults] setObject:@"车位租赁" forKey:@"currentOperation"];
    
    
    [self.view addSubview:_operationList];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITableViewDelegate/dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"operationCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"operationCell"];
    }
    //添加操作图标
    UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-20, self.view.frame.size.width-10)];
    image.layer.cornerRadius = CGRectGetWidth(image.bounds)/2;
    image.layer.masksToBounds = YES;
    [cell addSubview:image];
    //添加操作标题
    UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(image.frame)+5, self.view.frame.size.width, 20)];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont boldSystemFontOfSize:17];
    [cell addSubview:lab];
    
    if (indexPath.row == 0) {
        //
        [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://120.25.162.238/parkingLease/portrait/%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"portrait"]]] placeholderImage:[UIImage imageNamed:@"portrait"]];
        lab.text = @"我的";
        
    }else if (indexPath.row == 1){
        image.image = [UIImage imageNamed:@"lease.png"];
        lab.text = @"车位出租";
        
    }else if (indexPath.row == 2){
        image.image = [UIImage imageNamed:@"get.png"];
        lab.text = @"车位租赁";
    }else{
        image.image = [UIImage imageNamed:@"setUp.png"];
        lab.text = @"设置";
        
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.view.frame.size.height/4;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //点击单元格跳转到不同界面
    switch (indexPath.row) {
        case 0:
            
            break;
        case 1:
            if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"currentOperation"] isEqualToString:@"车位租赁"]) {
                //跳转到车位出租界面
                JWCenterGetParkingViewController * getParking = [[JWCenterGetParkingViewController alloc] init];
                UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:getParking];
                [self.mm_drawerController setCenterViewController:navController withCloseAnimation:YES completion:^(BOOL finished) {
                    //将当前操作设置为“车位租赁”
                    if (finished) {
                        [[NSUserDefaults standardUserDefaults] setObject:@"车位租赁" forKey:@"currentOperation"];
                        
                    }
                    
                }];
            }
            break;
        case 2:
            if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"currentOperation"] isEqualToString:@"车位出租"]) {
                //跳转到车位出租界面
                JWCenterLeaseViewController * leaseParking = [[JWCenterLeaseViewController alloc] init];
                UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:leaseParking];
                [self.mm_drawerController setCenterViewController:navController withCloseAnimation:YES completion:^(BOOL finished) {
                    //将当前操作设置为“车位租赁”
                    if (finished) {
                        [[NSUserDefaults standardUserDefaults] setObject:@"车位出租" forKey:@"currentOperation"];
                        
                    }
                    
                }];
            }
            break;
            
        default:
            break;
    }
}

@end
