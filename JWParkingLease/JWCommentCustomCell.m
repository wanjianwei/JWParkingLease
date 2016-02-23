//
//  JWCommentCustomCell.m
//  JWParkingLease
//
//  Created by jway on 16/1/14.
//  Copyright © 2016年 jway. All rights reserved.
//

#import "JWCommentCustomCell.h"
#import "UIImageView+WebCache.h"

@implementation JWCommentCustomCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //添加头像
        self.portraitView = [[UIImageView alloc] init];
        _portraitView.layer.cornerRadius = 25;
        _portraitView.layer.masksToBounds = YES;
        [self.contentView addSubview:_portraitView];
        //添加用户名
        self.username = [[UILabel alloc] init];
        _username.textAlignment = NSTextAlignmentLeft;
        _username.textColor = [UIColor orangeColor];
        [self.contentView addSubview:_username];
        
        //添加发布时间
        self.commentTime = [[UILabel alloc] init];
        _commentTime.textAlignment = NSTextAlignmentLeft;
        _commentTime.textColor = [UIColor grayColor];
        _commentTime.font = [UIFont boldSystemFontOfSize:14];
        [self.contentView addSubview:_commentTime];
        
        //回复按钮
        self.replyBtn = [[UIButton alloc] init];
        [self.replyBtn setBackgroundImage:[UIImage imageNamed:@"reply1.png"] forState:UIControlStateNormal];
        [self.replyBtn addTarget:self action:@selector(reply) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_replyBtn];
        
        //评论内容
        self.content = [[UILabel alloc] init];
        self.content.numberOfLines = 0;
        self.content.textAlignment = NSTextAlignmentLeft;
        self.content.font = [UIFont systemFontOfSize:17];
        self.content.textColor = [UIColor grayColor];
        [self.contentView addSubview:_content];
        
        //回复内容
        self.replyContent = [[UILabel alloc] init];
        self.replyContent.numberOfLines = 0;
        self.replyContent.textAlignment = NSTextAlignmentLeft;
        self.replyContent.font = [UIFont systemFontOfSize:14];
        self.replyContent.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.replyContent.textColor = [UIColor grayColor];
        [self.contentView addSubview:_replyContent];
    }
    return self;
}

//复写设置方法
-(void)setCommentInfoFrame:(JWCommentInfoFrame *)commentInfoFrame{
    
    _commentInfoFrame = commentInfoFrame;
    
    //设置frame
    [self setCellFrame];
    
    //填充数据
    [self fillData];
    
}


//回复--采用代理的方式
-(void)reply{
    [self.delegate replyUser:_username.text WithContent:_content.text];
}

//设置frame
-(void)setCellFrame{
    
    _portraitView.frame = _commentInfoFrame.portraitViewFrame;
    _username.frame = _commentInfoFrame.usernameFrame;
    _commentTime.frame = _commentInfoFrame.commentTimeFrame;
    
    _replyBtn.frame = _commentInfoFrame.replyBtnFrame;
    
    _content.frame = _commentInfoFrame.contentFrame;
    _replyContent.frame = _commentInfoFrame.replyContentFrame;
    
}

//填充数据
-(void)fillData{
    
    JWCommentInfo * newCommentInfo = _commentInfoFrame.commentInfo;
    
    [_portraitView sd_setImageWithURL:[NSURL URLWithString:newCommentInfo.portrait] placeholderImage:[UIImage imageNamed:@"portrait.png"]];
    _username.text = newCommentInfo.username;
    
    _commentTime.text = newCommentInfo.commentTime;
    
    _content.text = newCommentInfo.content;
    
    if (![newCommentInfo.repliedContent isEqualToString:@""]) {
        
        _replyContent.text =newCommentInfo.repliedContent;
    }
    
    
}

@end
