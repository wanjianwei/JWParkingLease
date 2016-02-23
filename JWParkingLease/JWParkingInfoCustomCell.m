//
//  JWParkingInfoCustomCell.m
//  JWParkingLease
//
//  Created by jway on 16/1/12.
//  Copyright © 2016年 jway. All rights reserved.
//

#import "JWParkingInfoCustomCell.h"
#import "CustomButton.h"
#import "UIImageView+WebCache.h"

#define WIDTH self.contentView.bounds.size.width

@interface JWParkingInfoCustomCell ()

//头像
@property(nonatomic,strong) UIImageView * portraitView;

//用户名
@property(nonatomic,strong) UILabel * username;

//发布时间
@property(nonatomic,strong) UILabel * publishTime;

//租让开始
@property(nonatomic,strong) UILabel * leaseBeginTime;

//租让截止
@property(nonatomic,strong) UILabel * leaseEndTime;

//租让类型
@property(nonatomic,strong) UILabel * leaseType;

//车位类型
@property(nonatomic,strong) UILabel * carportType;

//额外说明
@property(nonatomic,strong) UILabel * illustration;

//车位图片
@property(nonatomic,strong) UIImageView * carportImage;

//车位租让价格
@property(nonatomic,strong) UILabel * carportPrice;

//车位图片的张数
@property(nonatomic,strong) UILabel * imageNum;


//评论按钮
@property(nonatomic,strong) CustomButton * commentBtn;
//点赞按钮
@property(nonatomic,strong) CustomButton * praiseBtn;
//分享按钮
@property(nonatomic,strong) CustomButton * shareBtn;

//私信按钮
//@property(nonatomic,strong) UIButton * privateMailBtn;


@end


@implementation JWParkingInfoCustomCell


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



//复习初始化方法
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier AndCellType:(int)cellType{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //存储类型值
        _cellType = cellType;
        
        if (cellType == 1) {
            //车位cell，需要加上车位图片
            self.carportImage = [[UIImageView alloc] init];
            _carportImage.contentMode = UIViewContentModeScaleToFill;
            [self.contentView addSubview:_carportImage];
            
            //车位图片的张数
            self.imageNum = [[UILabel alloc] init];
            _imageNum.textAlignment = NSTextAlignmentLeft;
            _imageNum.textColor = [UIColor whiteColor];
            _imageNum.font = [UIFont boldSystemFontOfSize:15];
            [_carportImage addSubview:_imageNum];
            
            //车位租让价格
            self.carportPrice = [[UILabel alloc] init];
            _carportPrice.textAlignment = NSTextAlignmentCenter;
            _carportPrice.font = [UIFont systemFontOfSize:19];
            _carportPrice.textColor = [UIColor redColor];
            [self.contentView addSubview:_carportPrice];
        }else{
            
            //出租起始
            self.leaseBeginTime = [[UILabel alloc] init];
            _leaseBeginTime.textAlignment = NSTextAlignmentLeft;
            _leaseBeginTime.font = [UIFont systemFontOfSize:17];
            [self.contentView addSubview:_leaseBeginTime];
            
            //出租截止时间
            self.leaseEndTime = [[UILabel alloc] init];
            _leaseEndTime.textAlignment = NSTextAlignmentLeft;
            _leaseEndTime.font = [UIFont systemFontOfSize:17];
            [self.contentView addSubview:_leaseEndTime];
            
            
            //额外说明
            self.illustration = [[UILabel alloc] init];
            _illustration.textAlignment = NSTextAlignmentLeft;
            _illustration.font = [UIFont systemFontOfSize:17];
            _illustration.numberOfLines = 0;
            [self.contentView addSubview:_illustration];
            
        }
        
        //添加单元格控件,并设置相关属性
        self.portraitView = [[UIImageView alloc] init];
        _portraitView.layer.cornerRadius = 25;
        _portraitView.layer.masksToBounds = YES;
        [self.contentView addSubview:_portraitView];
        //添加用户名
        self.username = [[UILabel alloc] init];
        _username.textColor = [UIColor orangeColor];
        _username.textAlignment = NSTextAlignmentLeft;
        _username.font = [UIFont boldSystemFontOfSize:17];
        [self addSubview:_username];
        
        //添加发表日期
        self.publishTime = [[UILabel alloc] init];
        _publishTime.textAlignment = NSTextAlignmentLeft;
        _publishTime.textColor = [UIColor grayColor];
        _publishTime.font = [UIFont boldSystemFontOfSize:15];
        [self.contentView addSubview:_publishTime];
        
        //租让形式
        self.leaseType = [[UILabel alloc] init];
        _leaseType.textAlignment = NSTextAlignmentLeft;
        _leaseType.font = [UIFont systemFontOfSize:17];
        [self.contentView addSubview:_leaseType];
        
        //车位类型
        self.carportType = [[UILabel alloc] init];
        _carportType.textAlignment = NSTextAlignmentLeft;
        _carportType.font = [UIFont systemFontOfSize:17];
        [self.contentView addSubview:_carportType];
        
       
        //评论按钮
        self.commentBtn = [[CustomButton alloc] initWithType:2];
        _commentBtn.layer.borderWidth = 0.5f;
        _commentBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [_commentBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _commentBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        //添加事件响应
        [_commentBtn addTarget:self action:@selector(checkComment) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_commentBtn];
        
        //点赞按钮
        self.praiseBtn = [[CustomButton alloc] initWithType:2];
        _praiseBtn.layer.borderWidth = 0.5f;
        _praiseBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _praiseBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [_praiseBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        //添加事件响应
        [_praiseBtn addTarget:self action:@selector(praise) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_praiseBtn];
        
        //分享按钮
        self.shareBtn = [[CustomButton alloc] initWithType:2];
        _shareBtn.layer.borderWidth = 0.5f;
        _shareBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [_shareBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _shareBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        //添加事件响应
        [_shareBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_shareBtn];
       
        /*
        //私信按钮
        _privateMailBtn = [[UIButton alloc] init];
        _privateMailBtn.layer.cornerRadius = 5.0f;
        _privateMailBtn.layer.borderColor = [UIColor blackColor].CGColor;
        _privateMailBtn.layer.borderWidth = 1.0f;
        [_privateMailBtn setTitle:@"私信" forState:UIControlStateNormal];
        [_privateMailBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_privateMailBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
       
        //增加事件响应
        [_privateMailBtn addTarget:self action:@selector(sendPrivateMail) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_privateMailBtn];
         */
    }
    return self;
}


//复写设置方法
-(void)setParkingInfoFrame:(JWParkingInfoFrame *)parkingInfoFrame{
    
    _parkingInfoFrame = parkingInfoFrame;
    //设置frame
    [self setCellFrame];
    //设置值
    [self fillCell];
    
}

//设置frame
-(void)setCellFrame{
    //用户信息
    _portraitView.frame = _parkingInfoFrame.portraitFrame;
    _username.frame = _parkingInfoFrame.usernameFrame;
    _publishTime.frame = _parkingInfoFrame.publishTimeFrame;
    //车位信息
    if (_cellType == 1) {
        _carportImage.frame = _parkingInfoFrame.carportImageFrame;
        _imageNum.frame = _parkingInfoFrame.imageNumFrame;
        _leaseType.frame = _parkingInfoFrame.leaseTypeFrame;
        _carportType.frame = _parkingInfoFrame.carportTypeFrame;
        _carportPrice.frame = _parkingInfoFrame.carportPriceFrame;
        
    }else{
        _leaseType.frame = _parkingInfoFrame.leaseTypeFrame;
        _leaseBeginTime.frame = _parkingInfoFrame.leaseBeginTimeFrame;
        _leaseEndTime.frame = _parkingInfoFrame.leaseEndTimeFrame;
        _carportType.frame = _parkingInfoFrame.carportTypeFrame;
        _illustration.frame = _parkingInfoFrame.illustrationFrame;
    }
    //操作栏
    _commentBtn.frame = _parkingInfoFrame.commentBtnFrame;
    _praiseBtn.frame = _parkingInfoFrame.praiseBtnFrame;
    _shareBtn.frame = _parkingInfoFrame.shareBtnFrame;
  //  _privateMailBtn.frame = _parkingInfoFrame.privateMailBtnFrame;
}


//填充值
-(void)fillCell{
    JWParkingInfo * parkingInfo = _parkingInfoFrame.parkingInfo;
    //头像
    [_portraitView sd_setImageWithURL:[NSURL URLWithString:parkingInfo.portrait] placeholderImage:[UIImage imageNamed:@"portrait"]];
    
    _username.text = parkingInfo.username;
    _publishTime.text = parkingInfo.publishTime;
    
    if (_cellType == 1) {
        
        if (parkingInfo.carportImages.count == 0) {
            _carportImage.image = [UIImage imageNamed:@"bg_img.png"];
        }else{
            [_carportImage sd_setImageWithURL:[NSURL URLWithString:[parkingInfo.carportImages objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"bg_img.png"]];
        }
        _imageNum.text = [NSString stringWithFormat:@"共%lu张",(unsigned long)parkingInfo.carportImages.count];
        _leaseType.text = [NSString stringWithFormat:@"租让形式:%@",parkingInfo.leaseType];
        
        _carportType.text = [NSString stringWithFormat:@"车位类型:%@",parkingInfo.carportType];
        _carportPrice.text = parkingInfo.carportPrice;
        
    }else{
        _leaseType.text = [NSString stringWithFormat:@"租让形式:%@ (%@)",parkingInfo.leaseType,parkingInfo.carportPrice];
        _leaseBeginTime.text = [NSString stringWithFormat:@"租赁开始:%@",parkingInfo.leaseBeginTime];
        
        _leaseEndTime.text = [NSString stringWithFormat:@"租赁截止:%@",parkingInfo.leaseEndTime];
        
        _carportType.text = [NSString stringWithFormat:@"车位类型:%@",parkingInfo.carportType];
        
        if ([parkingInfo.illustration isEqualToString:@""]) {
            _illustration.text = @"附加说明:略";
        }else{
            _illustration.text = [NSString stringWithFormat:@"附加说明:%@",parkingInfo.illustration];
        }
    }
    
    //设置按钮的title
    [_commentBtn setTitle:parkingInfo.commentNum forState:UIControlStateNormal];
    [_commentBtn setImage:[UIImage imageNamed:@"myFocus.png"] forState:UIControlStateNormal];
    
    [_praiseBtn setTitle:parkingInfo.praiseNum forState:UIControlStateNormal];
    [_praiseBtn setImage:[UIImage imageNamed:@"myFocus.png"] forState:UIControlStateNormal];
    
    [_shareBtn setTitle:parkingInfo.attentionNum forState:UIControlStateNormal];
    [_shareBtn setImage:[UIImage imageNamed:@"myFocus.png"] forState:UIControlStateNormal];
}

//查看评论
-(void)checkComment{
    
}

//点赞
-(void)praise{
    
}

//分享
-(void)share{
    
}

//发送私信
-(void)sendPrivateMail{
    
}

@end
