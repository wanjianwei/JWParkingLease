//
//  CustomButton.h
//  JWParkingLease
//
//  Created by jway on 16/1/12.
//  Copyright © 2016年 jway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomButton : UIButton

/**
 定义button类型，btnType = 1 表示是图片在上，文字在下，btnType = 2 表示图片在左，文字在右
 */
@property(nonatomic,assign) int btnType;

//定义一个初始化方法
-(id)initWithFrame:(CGRect)frame AndType:(int)btnType;

//初始化方法
-(id)initWithType:(int)Type;

@end
