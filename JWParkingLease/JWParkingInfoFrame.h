//
//  JWParkingInfoFrame.h
//  JWParkingLease
//
//  Created by jway on 16/1/13.
//  Copyright © 2016年 jway. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"
#import "JWParkingInfo.h"

/**
 将自定义单元格数据模型导入，按照数据模型，分配各个子空间的frame。并计算出整体的cell高度
 */



@interface JWParkingInfoFrame : NSObject

//数据模型
@property(nonatomic,strong)JWParkingInfo * parkingInfo;

/**
 frameType = 1表示车位的cellFrame，frameType=2表示需求的cellframe
 */
@property(nonatomic,assign) int frameType;

//定义初始化方法
-(id)initWithFrameType:(int)frameType;


//头像frame
@property(nonatomic,assign) CGRect  portraitFrame;

//用户名称frame
@property(nonatomic,assign) CGRect usernameFrame;

//发布时间
@property(nonatomic,assign) CGRect publishTimeFrame;

//车位图片
@property(nonatomic,assign) CGRect carportImageFrame;

//图片张数
@property(nonatomic,assign) CGRect imageNumFrame;

//租让形式
@property(nonatomic,assign) CGRect leaseTypeFrame;

//租让开始
@property(nonatomic,assign) CGRect leaseBeginTimeFrame;

//租让截止
@property(nonatomic,assign) CGRect leaseEndTimeFrame;

//租让价格
@property(nonatomic,assign) CGRect carportPriceFrame;

//车位类型
@property(nonatomic,assign) CGRect carportTypeFrame;

//说明
@property(nonatomic,assign) CGRect illustrationFrame;

//评论按钮的尺寸
@property(nonatomic,assign) CGRect commentBtnFrame;

//点赞按钮的尺寸
@property(nonatomic,assign) CGRect praiseBtnFrame;

//分享按钮的尺寸
@property(nonatomic,assign) CGRect shareBtnFrame;

//私信按钮的尺寸
//@property(nonatomic,assign) CGRect privateMailBtnFrame;

//cell高度
@property(nonatomic,assign) CGFloat cellHeight;

@end
