//
//  JWCommentInfo.h
//  JWParkingLease
//
//  Created by jway on 16/1/14.
//  Copyright © 2016年 jway. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JWCommentInfo : NSObject

//评论Id
@property(nonatomic,strong)NSString * commentId;
//评论者头像
@property(nonatomic,strong)NSString * portrait;

//评论用户名称
@property(nonatomic,strong)NSString * username;

//评论时间
@property(nonatomic,strong)NSString * commentTime;

//评论内容
@property(nonatomic,strong)NSString * content;

//评论回复数组
@property(nonatomic,strong)NSArray * repliedArray;

/**评论回复拼接成字符串
 评论回复中包括：评论回复Id（commentRepliedId）、回复内容（repliedContent）、回复时间（repliedTime）
 */
@property(nonatomic,strong)NSMutableString * repliedContent;

//公共初始化方法
-(id)initWithDic:(NSDictionary *)dic;


@end
