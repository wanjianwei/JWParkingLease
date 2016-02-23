//
//  JWCommentInfoFrame.m
//  JWParkingLease
//
//  Created by jway on 16/1/14.
//  Copyright © 2016年 jway. All rights reserved.
//

#import "JWCommentInfoFrame.h"
#define WIDTH [UIScreen mainScreen].bounds.size.width

@implementation JWCommentInfoFrame

/*
//复写设置方法
-(void)setCommentInfo:(JWCommentInfo *)commentInfo{
    
    self.commentInfo = commentInfo;
    
    _portraitViewFrame = CGRectMake(16, 10, 50, 50);
    
    _usernameFrame = CGRectMake(CGRectGetMaxX(_portraitViewFrame)+10, 10, WIDTH-152, 25);
    
    _commentTimeFrame = CGRectMake(CGRectGetMaxX(_portraitViewFrame)+10, CGRectGetMaxY(_usernameFrame), WIDTH-152, 25);
    
    //回复按钮的frame
    _replyBtnFrame = CGRectMake(WIDTH-32-60, 35, 50, 30);
    
    //计算评论内容的高度
    CGRect size = [self.commentInfo.content boundingRectWithSize:CGSizeMake(WIDTH-32, 500) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17]} context:nil];
    _contentFrame = CGRectMake(16, CGRectGetMaxY(_portraitViewFrame)+10, WIDTH-32, size.size.height);
    
    //计算回复内容的高度
    CGRect replySize;
    if ([self.commentInfo.repliedContent isEqualToString:@""]) {
        //如果无回复，则frame为0
        replySize = CGRectZero;
        _replyBtnFrame = replySize;
    }else{
        
        CGRect repliedSize = [self.commentInfo.repliedContent boundingRectWithSize:CGSizeMake(WIDTH-32, 600) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]}  context:nil];
        
        _replyContentFrame = CGRectMake(16, CGRectGetMaxY(_contentFrame)+10, WIDTH-32, repliedSize.size.height);
        
    }
    
    //计算整个cell的高度
    _cellHeight = 80+size.size.height+replySize.size.height;
    
}
*/

//复写初始化方法
-(id)initWithCommentInfo:(JWCommentInfo *)commentInfo{
    self = [super init];
    if (self) {
        self.commentInfo = commentInfo;
        
        _portraitViewFrame = CGRectMake(16, 10, 50, 50);
        
        _usernameFrame = CGRectMake(CGRectGetMaxX(_portraitViewFrame)+10, 10, WIDTH-152, 25);
        
        _commentTimeFrame = CGRectMake(CGRectGetMaxX(_portraitViewFrame)+10, CGRectGetMaxY(_usernameFrame), WIDTH-152, 25);
        
        //回复按钮的frame
        _replyBtnFrame = CGRectMake(WIDTH-66, 15, 40, 40);
        
        //计算评论内容的高度
        CGRect size = [_commentInfo.content boundingRectWithSize:CGSizeMake(WIDTH-32, 500) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
        _contentFrame = CGRectMake(16, CGRectGetMaxY(_portraitViewFrame)+10, WIDTH-32, size.size.height);
        
        //计算回复内容的高度
        CGRect replySize;
        if ([self.commentInfo.repliedContent isEqualToString:@""]) {
            //如果无回复，则frame为0
            replySize = CGRectZero;
            _replyBtnFrame = replySize;
        }else{
            
            replySize = [self.commentInfo.repliedContent boundingRectWithSize:CGSizeMake(WIDTH-32, 600) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}  context:nil];
            
            _replyContentFrame = CGRectMake(16, CGRectGetMaxY(_contentFrame)+10, WIDTH-32, replySize.size.height);
            
        }
        //计算整个cell的高度
        _cellHeight = 80+size.size.height+replySize.size.height+25;
        
        
    }
    return self;
}

@end
