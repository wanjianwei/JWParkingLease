//
//  JWParkingInfo.h
//  JWParkingLease
//
//  Created by jway on 16/1/12.
//  Copyright © 2016年 jway. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 parkingInfoCell的objbect
 */

@interface JWParkingInfo : NSObject

//车位id
@property(nonatomic,strong) NSString * carportId;

//需求Id
@property(nonatomic,strong) NSString * demandId;

//头像
@property(nonatomic,strong)NSString * portrait;

//用户名称
@property(nonatomic,strong) NSString * username;

//发表时间
@property(nonatomic,strong) NSString * publishTime;

//车位图片
@property(nonatomic,strong) NSArray * carportImages;

//租让形式
@property(nonatomic,strong) NSString * leaseType;

//租让/出售价格
@property(nonatomic,strong) NSString * carportPrice;

//车位类型
@property(nonatomic,strong) NSString * carportType;

//评论数
@property(nonatomic,strong) NSString * commentNum;

//点赞数
@property(nonatomic,strong) NSString * praiseNum;

//关注数
@property(nonatomic,strong) NSString * attentionNum;

//租让开始时间
@property(nonatomic,strong) NSString * leaseBeginTime;

//租让截止时间
@property(nonatomic,strong) NSString * leaseEndTime;

//详细地址
@property(nonatomic,strong) NSString * detailAddress;

//所在市区
@property(nonatomic,strong) NSString * address;

//额外说明
@property(nonatomic,strong) NSString * illustration;

/**
 增加一个类型，用来判断是需求还是车位信息,1表示是车位，2表示是需求信息
 */
@property(nonatomic,assign) int infoType;

//定义初始化方法
-(id)initWithDic:(NSDictionary *)dic WithInfoType:(int)infoType;



@end
