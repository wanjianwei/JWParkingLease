//
//  JWInputBarView.h
//  JWParkingLease
//
//  Created by jway on 16/1/18.
//  Copyright © 2016年 jway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JWInputBarView : UIView<UITextViewDelegate>

@property(nonatomic,strong) UITextView * inputView;
//发送按钮
@property(nonatomic,strong) UIButton * sendBtn;

@property(nonatomic,strong) UILabel * placeholdText;
//待回复内容
@property(nonatomic,strong) UILabel * beRepliedText;

@end
