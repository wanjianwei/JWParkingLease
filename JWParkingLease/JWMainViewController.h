//
//  JWMainViewController.h
//  JWParkingLease
//
//  Created by jway on 16/1/4.
//  Copyright © 2016年 jway. All rights reserved.
//

#import "JWBaseViewController.h"
#import "JWChoseVillageViewController.h"

@interface JWMainViewController : JWBaseViewController<getParkingAddressDelegate>

//定义一个标志，用于区分角色，其中1为出租，2为出让，3为分享
@property(nonatomic,assign) int roleType;

//初始化方法
-(id)initWithroleType:(int)roleType;


@end
