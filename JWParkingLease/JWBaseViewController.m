//
//  JWBaseViewController.m
//  JWParkingLease
//
//  Created by jway on 16/1/4.
//  Copyright © 2016年 jway. All rights reserved.
//

#import "JWBaseViewController.h"
#import "CustomButton.h"
//地图类
#import <MapKit/MapKit.h>
//定位api
//#import <CoreLocation/CoreLocation.h>

@interface JWBaseViewController ()

@end

@implementation JWBaseViewController


-(id)init{
    self = [super init];
    if (self) {
        //初始化地图视图
        _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //先加载地图视图
    [self.view addSubview:_mapView];
    
    
    
    //定义一个发布按钮，加载在mapView上
    CustomButton * publishBtn = [[CustomButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-65, [UIScreen mainScreen].bounds.size.height-130, 40, 60) AndType:1];
    
    [publishBtn setImage:[UIImage imageNamed:@"publish.png"] forState:UIControlStateNormal];
    
    publishBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    publishBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    
    [publishBtn setTitle:@"发布" forState:UIControlStateNormal];
    //添加事件
    [publishBtn addTarget:self action:@selector(gotoPublishView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:publishBtn];
    
    
    //定义一个定位按钮
    CustomButton * locationBtn = [[CustomButton alloc] initWithFrame:CGRectMake(25, [UIScreen mainScreen].bounds.size.height-130, 40, 60) AndType:1];
    [locationBtn setImage:[UIImage imageNamed:@"location_pressed.png"] forState:UIControlStateNormal];
    locationBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    locationBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    
    [locationBtn setTitle:@"定位" forState:UIControlStateNormal];
    
    //添加事件
    [locationBtn addTarget:self action:@selector(location_again) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:locationBtn];
    
    
    //定义左右导航按钮
    UIBarButtonItem * leftBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"leftNavBtn.png"] style:UIBarButtonItemStyleDone target:self action:@selector(openDeckerView)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    UIBarButtonItem * rightSearchBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(gotoSearchView)];
    
    UIBarButtonItem * rightBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"rightNavBtn.png"] style:UIBarButtonItemStyleDone target:self action:@selector(changeToListTable)];
    //self.navigationItem.rightBarButtonItem = rightBtn;
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:rightBtn,rightSearchBtn, nil] animated:YES];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//打开左侧抽屉导航栏
-(void)openDeckerView{
    //在子类中复写
}

//转为用列表显示结果
-(void)changeToListTable{
    //在子类中复写
}

//跳转到发布界面
-(void)gotoPublishView{
    //在子类中复写
}

//定位到自己所在位置
-(void)location_again{
   //在子类中复写
}

//跳转到搜索界面
-(void)gotoSearchView{
    //在子类中复写
}


@end
