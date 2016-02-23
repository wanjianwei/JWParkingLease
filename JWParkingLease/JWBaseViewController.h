//
//  JWBaseViewController.h
//  JWParkingLease
//
//  Created by jway on 16/1/4.
//  Copyright © 2016年 jway. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MKMapView;

@interface JWBaseViewController : UIViewController

//定义一个地图点聚合相关的控件和类
@property(nonatomic,strong) MKMapView * mapView;

//定义几个public方法
//打开左侧抽屉导航栏
-(void)openDeckerView;
//转为用列表显示结果
-(void)changeToListTable;
//跳转到发布界面
-(void)gotoPublishView;
//定位到自己当前所在位置
-(void)location_again;

@end
