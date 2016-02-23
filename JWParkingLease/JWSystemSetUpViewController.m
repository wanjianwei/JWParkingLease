//
//  JWSystemSetUpViewController.m
//  JWParkingLease
//
//  Created by jway on 16/1/19.
//  Copyright © 2016年 jway. All rights reserved.
//

#import "JWSystemSetUpViewController.h"
#import "AppDelegate.h"
#import "SDImageCache.h"
@interface JWSystemSetUpViewController ()<UITableViewDataSource,UITableViewDelegate>{
    //程序委托类
    AppDelegate * app;
}

@property(nonatomic,strong) UITableView * setUpList;

//定义一个操作列表
@property(nonatomic,strong) NSArray * functionList;

@end

@implementation JWSystemSetUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化
    self.title = @"系统设置";
    self.setUpList = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.setUpList.dataSource = self;
    self.setUpList.delegate = self;
    _setUpList.backgroundColor = [UIColor groupTableViewBackgroundColor];
   // _setUpList.scrollEnabled = NO;
    [self.view addSubview:_setUpList];
    
    _functionList = [NSArray arrayWithObjects:@"检查更新",@"关于我们",@"清空缓存", nil];
    app = [[UIApplication sharedApplication] delegate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//退出
-(void)logout{
    //退出操作
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"loginState"];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma UITableViewDelegate/DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (tableView.dataSource>0) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self hideOtherSeporateLine:tableView];
    }else{
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return 2;
}

//隐藏其余的cell分割线
-(void)hideOtherSeporateLine:(UITableView *)tableView{
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else{
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"setUpCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"setUpCell"];
    }else{
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = [_functionList objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //计算缓存大小
        if (indexPath.row == 2) {
            NSInteger imageSize = [[SDImageCache sharedImageCache] getSize];
            //化为M
            CGFloat imageSize_m = imageSize/1024.0/1024.0;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fM",imageSize_m];
        }
        
    }else{
        UIButton * backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
        backBtn.backgroundColor = [UIColor greenColor];
        [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [backBtn setTitle:@"退出" forState:UIControlStateNormal];
        [backBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [backBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:backBtn];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //检查更新
            
        }else if (indexPath.row == 1){
            //关于我们
            
        }else{
            //清空缓存
            [[SDImageCache sharedImageCache] clearMemory];
            [[SDImageCache sharedImageCache] clearDisk];
            [self.setUpList reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:2 inSection:0], nil] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 44;
    }
    return 20;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

@end
