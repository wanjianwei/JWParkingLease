//
//  JWParkingDetailInfoViewController.h
//  JWParkingLease
//
//  Created by jway on 16/1/14.
//  Copyright © 2016年 jway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JWParkingInfo.h"
#import "JWCommentCustomCell.h"
@interface JWParkingDetailInfoViewController : UIViewController

//从上一个页面中获取车位数据
@property(nonatomic,strong)JWParkingInfo * parkingInfo;

/**定义一个标志，用来判断是展现车位详情还是需求详情
 其中infoType = 1表示展示需求详情，默认为展示车位详情
 */
@property(nonatomic,assign) int infoType;

@end
