//
//  JWCommentInfoFrame.h
//  JWParkingLease
//
//  Created by jway on 16/1/14.
//  Copyright © 2016年 jway. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JWCommentInfo.h"
#import "UIKit/UIkit.h"

@interface JWCommentInfoFrame : NSObject

//引入数据模型
@property(nonatomic,strong)JWCommentInfo * commentInfo;

/**
 frame计算和设计
 */
//头像尺寸
@property(nonatomic,assign)CGRect portraitViewFrame;
//用户名称尺寸
@property(nonatomic,assign)CGRect usernameFrame;

//发布时间frame
@property(nonatomic,assign)CGRect commentTimeFrame;

//回复按钮frame
@property(nonatomic,assign)CGRect replyBtnFrame;

//评论内容frame
@property(nonatomic,assign)CGRect contentFrame;

//回复内容frame
@property(nonatomic,assign)CGRect replyContentFrame;

//cell的高度
@property(nonatomic,assign)CGFloat cellHeight;

//复写初始化方法
-(id)initWithCommentInfo:(JWCommentInfo *)commentInfo;


@end
