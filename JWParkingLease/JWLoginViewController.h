//
//  JWLoginViewController.h
//  JWParkingLease
//
//  Created by jway on 16/1/5.
//  Copyright © 2016年 jway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JWLoginViewController : UIViewController

/**
 登录界面的弹出方式，如果是loginType = 1，则表示是采用childViewController的方式弹出登录界面，默认是
 通过navifationController push
 */
@property(nonatomic,assign) int loginType;

@end
