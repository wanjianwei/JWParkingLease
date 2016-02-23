//
//  JWPublishInfoViewController.m
//  JWParkingLease
//
//  Created by jway on 16/1/5.
//  Copyright © 2016年 jway. All rights reserved.
//

#import "JWPublishInfoViewController.h"
#import "JWLoginViewController.h"

#import "JWParkingLeaseViewController.h"
#import "JWPublishDemandTableViewController.h"

@interface JWPublishInfoViewController ()

//登录子视图
@property(nonatomic,strong)JWLoginViewController * loginView;

/**
 发布信息子视图，该视图共有六种模式，分别对应六种内容的发布；
 */
@property(nonatomic,strong)JWParkingLeaseViewController * publishCarportView;


//发布需求子视图
@property(nonatomic,strong)JWPublishDemandTableViewController * publishDemandView;

//定义一个分段控制器
@property(nonatomic,strong)UISegmentedControl * publishType;


@end

@implementation JWPublishInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //初始化发布车位子控制器
    self.publishCarportView = [[JWParkingLeaseViewController alloc] init];
    [self.publishCarportView.view setFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];
    [self addChildViewController:self.publishCarportView];
    
    //初始化发布需求子控制器
    self.publishDemandView = [[JWPublishDemandTableViewController alloc] init];
    [self.publishDemandView.view setFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];
    [self addChildViewController:_publishDemandView];
    
    //初始化分段控制器
    _publishType = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"发布车位",@"发布需求", nil]];
    //默认选中发布车位
    _publishType.selectedSegmentIndex = 0;
    //添加事件响应
    [_publishType addTarget:self action:@selector(changePublishType) forControlEvents:UIControlEventValueChanged];
    
    //尚未登录，显示登录界面
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"loginState"] isEqualToString:@"NO"]) {
        
        //设置标题
        self.title = @"用户登录";
        //初始化登录子控制器
        self.loginView = [[JWLoginViewController alloc] init];
        [self.loginView.view setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _loginView.loginType = 1;
        [self addChildViewController:self.loginView];
        [self.view addSubview:_loginView.view];
       
    }else{
        
        self.navigationItem.titleView = _publishType;
        [self.view addSubview:_publishCarportView.view];
        
    }
    //监听登录成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:@"loginSuccessNotification" object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//改变发布类型信息
-(void)changePublishType{
    if (_publishType.selectedSegmentIndex == 0) {
        [self transitionFromViewController:_publishDemandView toViewController:_publishCarportView duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
            if (finished) {
                [_publishCarportView didMoveToParentViewController:self];
                [_publishDemandView willMoveToParentViewController:nil];
              //  [_publishDemandView removeFromParentViewController];
                
            }
        }];
    }else{
        [self transitionFromViewController:_publishCarportView toViewController:_publishDemandView duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
            if (finished) {
                [_publishDemandView didMoveToParentViewController:self];
                [_publishCarportView willMoveToParentViewController:nil];
              //  [_publishCarportView removeFromParentViewController];
                
            }
        }];
    }
}


-(void)loginSuccess{
    
    [self transitionFromViewController:_loginView toViewController:_publishCarportView duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        if (finished) {
            //改变标题
            self.title = nil;
            self.navigationItem.titleView = _publishType;
            [_publishCarportView didMoveToParentViewController:self];
            [_loginView willMoveToParentViewController:nil];
            [_loginView removeFromParentViewController];
            
        }
    }];
}



@end
