//
//  LeftViewController.m
//  JWParkingLease
//
//  Created by jway on 16/1/4.
//  Copyright © 2016年 jway. All rights reserved.
//

#import "LeftViewController.h"
#import "JWMyInfoTableViewController.h"
#import "UIImageView+WebCache.h"
#import "IIViewDeckController.h"
#import "JWSystemSetUpViewController.h"
#import "JWMyCarportTableViewController.h"
#import "JWMyDemandListViewController.h"
#import "JWMyAttentionViewController.h"
#import "JWLoginViewController.h"
@interface LeftViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView * functionList;
//定义一个功能列表
@property(nonatomic,strong)NSArray * functionArray;
//图标列表
@property(nonatomic,strong)NSArray * imageIcons;

//定义头像背景
@property(nonatomic,strong)UIView * bgView;

//头像
@property(nonatomic,strong)UIImageView * portrait;
//昵称
@property(nonatomic,strong)UILabel * nickname;
//当前城市
@property(nonatomic,strong)UILabel * cityLabel;


@end

@implementation LeftViewController

-(id)init{
    self = [super init];
    if (self) {
        //初始化数组
        _functionArray = [NSArray arrayWithObjects:@"我的关注",@"我的车位",@"我的需求",@"我的私信",@"我的设置",nil];
        _imageIcons = [NSArray arrayWithObjects:[UIImage imageNamed:@"myFocus.png"],[UIImage imageNamed:@"myOrder.png"],[UIImage imageNamed:@"demand.png"],[UIImage imageNamed:@"myNotice.png"],[UIImage imageNamed:@"setUp.png"], nil];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化self.view
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_img.png"]];
    
    //头像背景图
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width*0.6, self.view.bounds.size.height/4)];
    self.bgView.backgroundColor = [UIColor clearColor];
    //添加一个手势响应
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handTap)];
    tap.numberOfTapsRequired = 1;
    [self.bgView addGestureRecognizer:tap];
    
    [self.view addSubview:_bgView];
    
    
    //设置头像背景
    self.portrait = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width*0.3-self.view.bounds.size.height/24, self.view.bounds.size.height/12, self.view.bounds.size.height/12, self.view.bounds.size.height/12)];
    _portrait.layer.cornerRadius = self.view.bounds.size.height/24;
    _portrait.layer.masksToBounds = YES;
    //设置未登录图片
    self.portrait.image = [UIImage imageNamed:@"portrait.png"];
    [self.bgView addSubview:self.portrait];
    
    /**
     昵称label，用于显示用户的昵称
     */
    self.nickname = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_portrait.frame)+10, self.bgView.bounds.size.width, 30)];
    _nickname.textAlignment = NSTextAlignmentCenter;
    _nickname.text = @"未登录";
    [self.bgView addSubview:_nickname];
    
    
    //初始化表示图
    self.functionList = [[UITableView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height/4, self.view.bounds.size.width*0.6, self.view.bounds.size.height*3/4-60) style:UITableViewStylePlain];
    _functionList.dataSource = self;
    _functionList.delegate = self;
    _functionList.backgroundColor = [UIColor clearColor];
    _functionList.alwaysBounceHorizontal = NO;
    [self.view addSubview:_functionList];
    
    //系统设置图标
    UIImageView * setUpImg = [[UIImageView alloc] initWithFrame:CGRectMake(16, [UIScreen mainScreen].bounds.size.height-35, 15, 15)];
    setUpImg.image = [UIImage imageNamed:@"setUp.png"];
    [self.view addSubview:setUpImg];
    
    //设置按钮
    UIButton * setUpBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(setUpImg.frame), [UIScreen mainScreen].bounds.size.height-35, 40, 15)];
    [setUpBtn setTitle:@"设置" forState:UIControlStateNormal];
    setUpBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [setUpBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [setUpBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [setUpBtn addTarget:self action:@selector(gotoSetUp) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:setUpBtn];
    //定位图标
    UIImageView * locationView = [[UIImageView alloc] initWithFrame:CGRectMake(self.functionList.bounds.size.width-100, [UIScreen mainScreen].bounds.size.height-35, 15, 15)];
    locationView.image = [UIImage imageNamed:@"user_location.png"];
    [self.view addSubview:locationView];
    //设置当前城市
    _cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(locationView.frame)+10,[UIScreen mainScreen].bounds.size.height-35, 75, 15)];
    _cityLabel.font = [UIFont boldSystemFontOfSize:14];
    
    _cityLabel.textAlignment = NSTextAlignmentLeft;
    _cityLabel.text = @"未知";
    [self.view addSubview:_cityLabel];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    //每次在视图出现的时候就刷新一次界面
    _cityLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"city"];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"loginState"] isEqualToString:@"YES"]) {
        _nickname.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"nickname"];
        [_portrait sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://120.25.162.238/parkingLease/portraitImages/%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"portrait"]]] placeholderImage:[UIImage imageNamed:@"portrait.png"]];
    }else{
        _nickname.text = @"未登录";
        _portrait.image = [UIImage imageNamed:@"portrait.png"];
    }
    
}

-(void)handTap{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"loginState"] isEqualToString:@"YES"]) {
        //跳转到我的设置界面
        //我的信息
        JWMyInfoTableViewController * infoView = [[JWMyInfoTableViewController alloc] init];
        infoView.hidesBottomBarWhenPushed = YES;
        
        [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
            [((UITabBarController *)self.viewDeckController.centerController).selectedViewController pushViewController:infoView animated:YES];
        }];
    }else{
        JWLoginViewController * loginView = [[JWLoginViewController alloc] init];
        loginView.hidesBottomBarWhenPushed = YES;
        [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
            [((UITabBarController *)self.viewDeckController.centerController).selectedViewController pushViewController:loginView animated:YES];
        }];
    }
}

//跳转到系统设置界面，无需登录
-(void)gotoSetUp{
    JWSystemSetUpViewController * setUpView = [[JWSystemSetUpViewController alloc] init];
    setUpView.hidesBottomBarWhenPushed = YES;
    [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
        [((UITabBarController *)self.viewDeckController.centerController).selectedViewController pushViewController:setUpView animated:YES];
    }];
}

#pragma UITableViewDelegate/dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (tableView.dataSource>0) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self p_hideExtraTableCellSeparatorLine:tableView];
    }else{
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    
    return 1;
}

//隐藏多余的单元格分割线
-(void)p_hideExtraTableCellSeparatorLine:(UITableView*)tableView{
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"functionCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"functionCell"];
    }
    cell.imageView.image = [_imageIcons objectAtIndex:indexPath.row];
    cell.textLabel.text = [_functionArray objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor grayColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //跳转到对应界面中
    if (indexPath.row == 0) {
        //我的关注
        JWMyAttentionViewController * attentionView = [[JWMyAttentionViewController alloc] init];
        attentionView.hidesBottomBarWhenPushed = YES;
        [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
            [((UITabBarController *)self.viewDeckController.centerController).selectedViewController pushViewController:attentionView animated:YES];
        }];

    }else if (indexPath.row == 1){
        //我的车位
        JWMyCarportTableViewController * myCarportInfoView = [[JWMyCarportTableViewController alloc] init];
        myCarportInfoView.hidesBottomBarWhenPushed = YES;
        [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
            [((UITabBarController *)self.viewDeckController.centerController).selectedViewController pushViewController:myCarportInfoView animated:YES];
        }];
        
    }else if (indexPath.row == 2){
        //我的需求
        JWMyDemandListViewController * demandListView = [[JWMyDemandListViewController alloc] init];
        demandListView.hidesBottomBarWhenPushed = YES;
        [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
            [((UITabBarController *)self.viewDeckController.centerController).selectedViewController pushViewController:demandListView animated:YES];
        }];
        
    }else if(indexPath.row == 3){
        //我的私信
        
    }else{
        //我的信息
        JWMyInfoTableViewController * infoView = [[JWMyInfoTableViewController alloc] init];
        infoView.hidesBottomBarWhenPushed = YES;
        
        [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
            [((UITabBarController *)self.viewDeckController.centerController).selectedViewController pushViewController:infoView animated:YES];
        }];
    }
    
    [self.functionList reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section],nil] withRowAnimation:UITableViewRowAnimationFade];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

@end
