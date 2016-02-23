//
//  AppDelegate.m
//  JWParkingLease
//
//  Created by jway on 15/12/11.
//  Copyright © 2015年 jway. All rights reserved.
//

#import "AppDelegate.h"


#import <QuartzCore/QuartzCore.h>

#import "IIViewDeckController.h"

#import "LeftViewController.h"
#import "JWMainViewController.h"

@interface AppDelegate ()<CLLocationManagerDelegate>
    

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
        
    //初始化并设置网络请求管理器
    self.manager=[AFHTTPSessionManager manager];
    self.manager.responseSerializer=[AFJSONResponseSerializer serializer];
    //manager加上这个就会在success中回调
     self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //设置请求时间
    self.manager.requestSerializer.timeoutInterval = 15.0;
    
    
    //初始化全局定位控制器
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    _locationManager.distanceFilter = 5000;
    [_locationManager requestWhenInUseAuthorization];
    _locationManager.delegate = self;
    
    
    //初始化leftViewController
    LeftViewController * leftView = [[LeftViewController alloc] init];
    //初始化3个main视图
    JWMainViewController * mainView1 = [[JWMainViewController alloc] initWithroleType:1];
    UINavigationController * navMainView1 = [[UINavigationController alloc] initWithRootViewController:mainView1];
    
    JWMainViewController * mainView2 = [[JWMainViewController alloc] initWithroleType:2];
    UINavigationController * navMainView2 = [[UINavigationController alloc] initWithRootViewController:mainView2];
    
    JWMainViewController * mainView3 = [[JWMainViewController alloc] initWithroleType:3];
    UINavigationController * navMainView3 = [[UINavigationController alloc] initWithRootViewController:mainView3];
    
    UITabBarController * tabbarView = [[UITabBarController alloc] init];
    tabbarView.viewControllers = [NSArray arrayWithObjects:navMainView1,navMainView2,navMainView3, nil];
    
    
    IIViewDeckController * deckController = [[IIViewDeckController alloc] initWithCenterViewController:tabbarView leftViewController:leftView];
    
    [deckController setLeftSize:[UIScreen mainScreen].bounds.size.width*0.4];
    
    //设置左侧视图打开方式——只能允许点击按钮打开
    deckController.panningMode = IIViewDeckNoPanning;

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:deckController];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    //设置登录状态为未登录
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"loginState"];
    
    //开启定位
    [_locationManager startUpdatingLocation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
- (BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder{
    
    return YES;
}

- (BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder{
   
    return YES;
}

- (UIViewController *)application:(UIApplication *)application viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder{
    
    NSLog(@"arr = %@",identifierComponents);
    
    NSString * key = [identifierComponents lastObject];
    if([key isEqualToString:@"drawerView"]){
        return self.window.rootViewController;
    }else if ([key isEqualToString:@"leftView"]){
        return ((MMDrawerController *)self.window.rootViewController).leftDrawerViewController;
    }else if ([key isEqualToString:@"navCenterView"]){
       return ((MMDrawerController *)self.window.rootViewController).centerViewController;
    }else{
        return nil;
    }
}
*/
#pragma CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    CLLocation * currentLocation = [locations lastObject];
    //地理信息反编码
    CLGeocoder * geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        //取出地理反编码信息
        if (placemarks.count>0) {
            CLPlacemark * placemark = [placemarks firstObject];
            NSString * city = [placemark.addressDictionary objectForKey:@"City"];
            //更新城市或其他信息
            if (![city isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"city"]]) {
                [[NSUserDefaults standardUserDefaults] setObject:city forKey:@"city"];
            }
            //存储当前经纬度
            self.latitude = currentLocation.coordinate.latitude;
            self.longitude = currentLocation.coordinate.longitude;
            
            //投递推送成功通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"locationSuccessNotification" object:nil];
            
        }
    }];
   //关闭定位
    [_locationManager stopUpdatingLocation];
    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    //将定位位置设置为“未知”
    [[NSUserDefaults standardUserDefaults] setObject:@"未知" forKey:@"city"];
    
    //投递定位失败通知——不关闭定位
    [[NSNotificationCenter defaultCenter] postNotificationName:@"locationFailNotification" object:nil userInfo:@{@"message":error.localizedDescription}];
    
    
}


@end
