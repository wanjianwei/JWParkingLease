//
//  JWParkingInfoFrame.m
//  JWParkingLease
//
//  Created by jway on 16/1/13.
//  Copyright © 2016年 jway. All rights reserved.
//

#import "JWParkingInfoFrame.h"


#define WIDTH [UIScreen mainScreen].bounds.size.width
@implementation JWParkingInfoFrame


//复写初始化方法
-(id)initWithFrameType:(int)frameType{
    self = [super init];
    if (self) {
        _frameType = frameType;
    }
    return self;
}

//复写合成存取方法
-(void)setParkingInfo:(JWParkingInfo *)parkingInfo{
    
    _parkingInfo = parkingInfo;
    
    //在此处设置frame
    _portraitFrame = CGRectMake(16, 10, 50, 50);
    
    _usernameFrame = CGRectMake(CGRectGetMaxX(_portraitFrame)+10, 10, 200, 25);
    
    _publishTimeFrame = CGRectMake(CGRectGetMaxX(_portraitFrame)+10, CGRectGetMaxY(_usernameFrame), 200, 25);
    
 //   _privateMailBtnFrame = CGRectMake([UIScreen mainScreen].bounds.size.width-16-65, 20, 65, 30);
    
    if (_frameType == 1) {
        //车位cellFrame
        _carportImageFrame = CGRectMake(16, CGRectGetMaxY(_portraitFrame)+10, WIDTH-32, (WIDTH-32)/2.0);
        
        _imageNumFrame = CGRectMake(16, CGRectGetHeight(_carportImageFrame)-32, 100, 32);
        
        _carportTypeFrame = CGRectMake(16, CGRectGetMaxY(_carportImageFrame), WIDTH-32, 25);
        
        _leaseTypeFrame = CGRectMake(16, CGRectGetMaxY(_carportTypeFrame), WIDTH-32, 25);
        
        //租让价格
        _carportPriceFrame = CGRectMake(CGRectGetMaxX(_carportImageFrame)-100, CGRectGetMaxY(_carportImageFrame)+10, 100, 30);
        //设置按钮
        _commentBtnFrame = CGRectMake(0, CGRectGetMaxY(_leaseTypeFrame)+5, WIDTH/3.0, 35);
        
        _praiseBtnFrame = CGRectMake(CGRectGetMaxX(_commentBtnFrame), CGRectGetMaxY(_leaseTypeFrame)+5, WIDTH/3.0, 35);
        
        _shareBtnFrame = CGRectMake(CGRectGetMaxX(_praiseBtnFrame), CGRectGetMaxY(_leaseTypeFrame)+5, WIDTH/3.0, 35);
        
        //计算行高
        _cellHeight =160 + _carportImageFrame.size.height;
        
    }else{
        
        //需求cellFrame
        _leaseTypeFrame = CGRectMake(16, CGRectGetMaxY(_portraitFrame)+10, WIDTH-32, 25);
        
        if (![_parkingInfo.leaseType isEqualToString:@"出售"]) {
            _leaseBeginTimeFrame = CGRectMake(16, CGRectGetMaxY(_leaseTypeFrame), WIDTH-32, 25);
            _leaseEndTimeFrame = CGRectMake(16, CGRectGetMaxY(_leaseBeginTimeFrame), WIDTH-32, 25);
            _carportTypeFrame = CGRectMake(16, CGRectGetMaxY(_leaseEndTimeFrame), WIDTH-32, 25);
        }else{
            _leaseBeginTimeFrame = CGRectZero;
            _leaseEndTimeFrame = CGRectZero;
            _carportTypeFrame = CGRectMake(16, CGRectGetMaxY(_leaseTypeFrame), WIDTH-32, 25);
        }
        
        //计算说明框的数据大小
        NSString * illustrationText = [NSString stringWithFormat:@"附加说明:%@",_parkingInfo.illustration];
        
        CGRect szie = [illustrationText boundingRectWithSize:CGSizeMake(WIDTH-32, 45) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
        
        _illustrationFrame = CGRectMake(16, CGRectGetMaxY(_carportTypeFrame), WIDTH-32, szie.size.height);
        
        //设置按钮
        _commentBtnFrame = CGRectMake(0, CGRectGetMaxY(_illustrationFrame)+5, WIDTH/3.0, 35);
        
        _praiseBtnFrame = CGRectMake(CGRectGetMaxX(_commentBtnFrame), CGRectGetMaxY(_illustrationFrame)+5, WIDTH/3.0, 35);
        
        _shareBtnFrame = CGRectMake(CGRectGetMaxX(_praiseBtnFrame), CGRectGetMaxY(_illustrationFrame)+5, WIDTH/3.0, 35);
        
       // _privateMailBtnFrame = CGRectMake([UIScreen mainScreen].bounds.size.width-16-65, 20, 65, 30);
        
        //计算单元格的高度
        if ([_parkingInfo.leaseType isEqualToString:@"出售"]) {
            _cellHeight = 160+szie.size.height;
        }else{
            _cellHeight = 210+szie.size.height;
        }

        
    }
    
}
@end
