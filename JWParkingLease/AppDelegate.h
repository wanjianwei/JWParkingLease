//
//  AppDelegate.h
//  JWParkingLease
//
//  Created by jway on 15/12/11.
//  Copyright © 2015年 jway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetWorking.h"
//定位api
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//网络请求管理器
@property(strong,nonatomic)AFHTTPSessionManager * manager;

//定位管理器
@property(nonatomic,strong)CLLocationManager * locationManager;

/**
 存储当前经纬度
 */
@property(nonatomic,assign) double longitude;

@property(nonatomic,assign) double latitude;

@end

