//
//  JWInputBarView.m
//  JWParkingLease
//
//  Created by jway on 16/1/18.
//  Copyright © 2016年 jway. All rights reserved.
//

#import "JWInputBarView.h"

@implementation JWInputBarView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizesSubviews = YES;
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        //输入框
        _inputView = [[UITextView alloc] initWithFrame:CGRectMake(10, 5, self.bounds.size.width-80, 35)];
        _inputView.layer.cornerRadius = 4.0f;
        _inputView.font = [UIFont systemFontOfSize:17];
        _inputView.layer.masksToBounds  =YES;
        _inputView.returnKeyType = UIReturnKeyDone;
        _inputView.delegate = self;
        
        //设置autoresizeMask
        [_inputView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        
        [self addSubview:_inputView];
        
        /*
        //添加约束
        //左约束
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_inputView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:10]];
        //右约束
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_inputView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:-65]];
        //上约束
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_inputView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:5]];
        //下约束
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_inputView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-5]];
        */
        
        //发送按钮
        self.sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width-65, 5, 55, 35)];
        self.sendBtn.backgroundColor = [UIColor greenColor];
        [_sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        _sendBtn.layer.cornerRadius = 3.0f;
        [_sendBtn addTarget:self action:@selector(sendText) forControlEvents:UIControlEventTouchUpInside];
        
        [_sendBtn setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
        
        [self addSubview:_sendBtn];
        
        /*
        //添加约束
        //左约束
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_sendBtn attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_inputView attribute:NSLayoutAttributeLeading multiplier:1 constant:-10]];
        //右约束
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_sendBtn attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:-10]];
        //上约束
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_sendBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:-5]];
        //下约束
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_sendBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-5]];
        */
        //placeHolder
        self.placeholdText = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 200, 25)];
        _placeholdText.textAlignment = NSTextAlignmentLeft;
        _placeholdText.textColor = [UIColor lightGrayColor];
        _placeholdText.font = [UIFont systemFontOfSize:15];
        _placeholdText.text = @"发表评论:";
        
        [_placeholdText setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
        
        [_inputView addSubview:_placeholdText];
        
        /*
        //添加约束
        //左约束
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_placeholdText attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_inputView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        //右约束
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_placeholdText attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_inputView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        //上约束
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_placeholdText attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_inputView attribute:NSLayoutAttributeTop multiplier:1 constant:-5]];
        //下约束
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_placeholdText attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_inputView attribute:NSLayoutAttributeBottom multiplier:1 constant:-5]];
        */
        //回复内容label
        self.beRepliedText = [[UILabel alloc] initWithFrame:CGRectMake(0, -23, self.bounds.size.width, 23)];
        _beRepliedText.textAlignment = NSTextAlignmentLeft;
        _beRepliedText.font = [UIFont systemFontOfSize:15];
        _beRepliedText.backgroundColor = [UIColor blackColor];
        _beRepliedText.alpha = 0.5;
        _beRepliedText.textColor = [UIColor whiteColor];
        //初始时隐藏
        _beRepliedText.hidden = YES;
        
        [_beRepliedText setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin];
        
        [self addSubview:_beRepliedText];
        
        /*
        //添加约束
        //左约束
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_beRepliedText attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        //右约束
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_beRepliedText attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        //下约束
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_beRepliedText attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        
        //宽度
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_beRepliedText attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0.5 constant:0]];
        */
    }
    return self;
}


//发送评论
-(void)sendText{
    
}


#pragma UITextViewDelegate

-(void)textViewDidBeginEditing:(UITextView *)textView{
    _placeholdText.hidden = YES;
    
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        _placeholdText.hidden = NO;
    }else{
        _placeholdText.hidden = YES;
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}


-(void)textViewDidChange:(UITextView *)textView{
    CGRect rect = [textView.text boundingRectWithSize:CGSizeMake(self.bounds.size.width-80, 100) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
    if ((rect.size.height<120) && (rect.size.height>30)) {
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y-(rect.size.height-_inputView.frame.size.height), self.frame.size.width, self.frame.size.height+rect.size.height-_inputView.frame.size.height)];
    }else if (rect.size.height<30){
        //inputBar恢复到45的高度
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y+self.frame.size.height-45, self.frame.size.width, 45)];
    }
}

@end
