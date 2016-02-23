//
//  JWChoseVillageViewController.h
//  JWParkingLease
//
//  Created by jway on 15/12/17.
//  Copyright © 2015年 jway. All rights reserved.
//

#import <UIKit/UIKit.h>
//定义协议
@protocol getParkingAddressDelegate <NSObject>

@optional
-(void)locateToAddress:(NSString *)address WithLat:(float)Lat AndLon:(float)lon;

-(void)getCarportAddress:(NSDictionary *)addressdic;

@end

@interface JWChoseVillageViewController : UIViewController

@property(weak,nonatomic)id<getParkingAddressDelegate>delegate;

//定义一个标志，用来判断是获取地理位置还是选择地理位置
@property(nonatomic,assign)BOOL isGettingAddress;

@end
