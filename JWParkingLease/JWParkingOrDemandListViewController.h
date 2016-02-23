//
//  JWParkingOrDemandListViewController.h
//  JWParkingLease
//
//  Created by jway on 16/1/20.
//  Copyright © 2016年 jway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JWParkingOrDemandListViewController : UIViewController

/**
 定义一个标志，用来判断是车位信息还是需求信息
 infoType = 1为需求信息，默认为车位信息
 */
@property(nonatomic,strong) NSString * typeInfo;

/**
 存储传递过来的carportId或demandId字符串
 */
@property(nonatomic,strong) NSString * infoId;

@end
