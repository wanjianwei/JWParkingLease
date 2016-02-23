//
//  JWCommentCustomCell.h
//  JWParkingLease
//
//  Created by jway on 16/1/14.
//  Copyright © 2016年 jway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JWCommentInfoFrame.h"
@protocol replyCommentDelegate <NSObject>

-(void)replyUser:(NSString *)username WithContent:(NSString *)content;

@end


@interface JWCommentCustomCell : UITableViewCell
//cell内部各个空间尺寸
@property(nonatomic,strong)JWCommentInfoFrame * commentInfoFrame;

//头像
@property(nonatomic,strong)UIImageView * portraitView;

//用户名称
@property(nonatomic,strong)UILabel * username;
//评论时间
@property(nonatomic,strong)UILabel * commentTime;

//回复按钮
@property(nonatomic,strong)UIButton * replyBtn;

//评论内容
@property(nonatomic,strong)UILabel * content;

//回复内容
@property(nonatomic,strong)UILabel * replyContent;

//定义一个委托代理
@property(nonatomic,strong) id<replyCommentDelegate>delegate;

@end
