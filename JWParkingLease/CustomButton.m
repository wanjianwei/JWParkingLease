//
//  CustomButton.m
//  JWParkingLease
//
//  Created by jway on 16/1/12.
//  Copyright © 2016年 jway. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton

//初始化方法
-(id)initWithFrame:(CGRect)frame AndType:(int)btnType{
    self = [super initWithFrame:frame];
    if (self) {
        _btnType = btnType;
        if (_btnType == 1) {
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.imageView.contentMode = UIViewContentModeCenter;
           // self.titleLabel.font = [UIFont boldSystemFontOfSize:self.bounds.size.height/6];
        }else{
            self.titleLabel.textAlignment = NSTextAlignmentLeft;
            self.imageView.contentMode = UIViewContentModeScaleToFill;
           // self.titleLabel.font = [UIFont boldSystemFontOfSize:self.bounds.size.width/3/6];
        }
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [self setTintColor:[UIColor orangeColor]];
    }
    return self;
    
}


-(id)initWithType:(int)Type{
    self = [super init];
    if (self) {
        _btnType = Type;
        self.imageView.contentMode = UIViewContentModeCenter;
        if (_btnType == 1) {
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
        }else{
            self.titleLabel.textAlignment = NSTextAlignmentLeft;
        }
    }
    
    return self;
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    if (_btnType == 1) {
        CGFloat W = contentRect.size.width;
        CGFloat H = contentRect.size.height*2/3.0;
        return CGRectMake(0, 0, W, H);
    }else{
        CGFloat W = contentRect.size.width/4.0;
       
        return CGRectMake(W, (contentRect.size.height-25)/2.0, 25, 25);
    }
    
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    if (_btnType == 1) {
        CGFloat W = contentRect.size.width;
        CGFloat H = contentRect.size.height/3.0;
        return CGRectMake(0, H*2, W, H);
    }else{
        CGFloat W = contentRect.size.width;
       // CGFloat H = contentRect.size.height;
        return CGRectMake(W/4.0+30, (contentRect.size.height-25)/2.0, W/2.0, 25);
    }
    
}


@end
