//
//  JWGetRandomViewController.m——获取验证码界面
//  JWParkingLease
//
//  Created by jway on 16/1/6.
//  Copyright © 2016年 jway. All rights reserved.
//

#import "JWGetRandomViewController.h"
#import "AppDelegate.h"
#import "XMNAnimTextFiled.h"
#import "JWRegisterTableViewController.h"
#import "JWResetPasswdTableViewController.h"

@interface JWGetRandomViewController ()<UITextFieldDelegate>{
    AppDelegate * app;
    //计数标志
    int count;
}

//用户手机输入框
@property(nonatomic,strong)XMNAnimTextFiled * telphone;

//短信验证码输入框
@property(nonatomic,strong)XMNAnimTextFiled * randomNum;

//下一步按钮
@property(nonatomic,strong) UIButton * nextStepBtn;

//获取验证码按钮
@property(nonatomic,strong) UIButton * getRandomBtn;

//定义一个定时器
@property(nonatomic,strong) NSTimer * timer;

@end

@implementation JWGetRandomViewController

-(id)init{
    self = [super init];
    if (self) {
        //初始化手机号输入框
        _telphone = [[XMNAnimTextFiled alloc] initWithFrame:CGRectMake(20, 90, [UIScreen mainScreen].bounds.size.width*2/3-20, 40)];
        [_telphone setPlaceHolderText:@"请输入手机号"];
        [_telphone textField].tag = 1;
        _telphone.delegate = self;
        [_telphone textField].keyboardType = UIKeyboardTypeNumberPad;
        
        //获取验证码按钮
        _getRandomBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_telphone.frame)+15, 90, [UIScreen mainScreen].bounds.size.width/3-35, 40)];
        _getRandomBtn.layer.cornerRadius = 4.0f;
        _getRandomBtn.backgroundColor = [UIColor greenColor];
        [_getRandomBtn setTitle:@"验证" forState:UIControlStateNormal];
        [_getRandomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_getRandomBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        _getRandomBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        //添加控制事件
        [_getRandomBtn addTarget:self action:@selector(getRandom) forControlEvents:UIControlEventTouchUpInside];
        
        //验证码输入框
        _randomNum = [[XMNAnimTextFiled alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_telphone.frame)+20, [UIScreen mainScreen].bounds.size.width-40, 40)];
        [_randomNum setPlaceHolderText:@"请输入验证码"];
        [_randomNum textField].tag = 2;
        _randomNum.delegate = self;
        [_randomNum textField].keyboardType = UIKeyboardTypeNumberPad;
        
        
        //初始化下一步按钮
        _nextStepBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_randomNum.frame)+20, [UIScreen mainScreen].bounds.size.width-40, 40)];
        _nextStepBtn.layer.cornerRadius = 5.0f;
        _nextStepBtn.backgroundColor = [UIColor lightGrayColor];
        [_nextStepBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextStepBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nextStepBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        _nextStepBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        //初始时该按钮无响应
        _nextStepBtn.userInteractionEnabled = YES;
        //添加事件
        [_nextStepBtn addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //标题
    self.title = @"手机验证";
    //初始化本地视图
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //加载电话输入框
    [self.view addSubview:_telphone];
    
    //加载获取验证码按钮
    [self.view addSubview:_getRandomBtn];
    
    //加载随机码输入框
    [self.view addSubview:_randomNum];
    //加载下一步按钮
    [self.view addSubview:_nextStepBtn];
    
    //一开始验证码输入框和“下一步”按钮都是不能接受响应事件
    _randomNum.userInteractionEnabled = NO;
    _nextStepBtn.userInteractionEnabled = NO;
    
    //手势处理器，关闭键盘
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handTap)];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
    
    //初始化程序委托代理类
    app = [UIApplication sharedApplication].delegate;
    count = 60;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//获取验证码
-(void)getRandom{
    
    _telphone.state = XMNAnimTextFieldStateNormal;
    //验证输入电话是否合法
    if (![[NSPredicate predicateWithFormat:@"SELF MATCHES %@",[NSString stringWithFormat:@"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,1，5-9]))\\d{8}$"]] evaluateWithObject:self.telphone.text]) {
        _telphone.state = XMNAnimTextFieldStateError;
        
    }else{
        
        //设置getRandomBtn的属性
        _getRandomBtn.backgroundColor = [UIColor grayColor];
        _getRandomBtn.userInteractionEnabled = NO;
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(count) userInfo:nil repeats:YES];
        
        
        //采用多线程
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [app.manager POST:@"" parameters:@{@"telphone":_telphone.text} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                //获取验证码成功
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"验证码已发送" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //button恢复状态
                    _getRandomBtn.backgroundColor = [UIColor greenColor];
                    _getRandomBtn.userInteractionEnabled = YES;
                    _getRandomBtn.titleLabel.text = @"验证";
                    
                    //定时器停止
                    [_timer invalidate];
                    _timer = nil;
                    
                    //恢复响应状态
                    _randomNum.userInteractionEnabled = YES;
                    _nextStepBtn.userInteractionEnabled = YES;
                    _nextStepBtn.backgroundColor = [UIColor greenColor];
                    
                    count = 60;
                }];
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:nil];
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                //错误提示
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //button恢复状态
                    _getRandomBtn.backgroundColor = [UIColor greenColor];
                    _getRandomBtn.userInteractionEnabled = YES;
                    _getRandomBtn.titleLabel.text = @"验证";
                    count = 60;
                    //定时器停止
                    [_timer invalidate];
                    _timer = nil;
                    
                }];
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:nil];
            }];

        });
    }
}


//计时
-(void)count{
    count -=1;
    if (count == 0) {
        //计时结束
        _getRandomBtn.backgroundColor = [UIColor greenColor];
        _getRandomBtn.userInteractionEnabled = YES;
        _getRandomBtn.titleLabel.text = @"重新验证";
        count = 60;
        //移除timer
        [_timer invalidate];
        _timer = nil;
    }else{
        _getRandomBtn.titleLabel.text = [NSString stringWithFormat:@"(%d秒)",count];
    }
}

//下一步
-(void)nextStep{
    _telphone.state = XMNAnimTextFieldStateNormal;
    _randomNum.state = XMNAnimTextFieldStateNormal;
    
    if ([_randomNum.text isEqualToString:@""]) {
        _randomNum.state = XMNAnimTextFieldStateError;
    }else if ([_telphone.text isEqualToString:@""]){
        _telphone.state = XMNAnimTextFieldStateError;
    }else{
        //跳转下一个页面
        if (_isRegister) {
            JWRegisterTableViewController * registerView = [[JWRegisterTableViewController alloc] init];
            registerView.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:registerView animated:YES];
        }else{
            JWResetPasswdTableViewController * resetPwdView = [[JWResetPasswdTableViewController alloc] init];
            resetPwdView.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:resetPwdView animated:YES];
        }
    }
}

//关闭键盘
-(void)handTap{
    if (_telphone.state == XMNAnimTextFieldStateEditing) {
        _telphone.state = XMNAnimTextFieldStateNormal;
    }
    
    if (_randomNum.state == XMNAnimTextFieldStateEditing) {
        _randomNum.state = XMNAnimTextFieldStateNormal;
    }
    
}

#pragma UITextFieldDelegate
//限制验证码输入框的输入字数
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.tag == 2) {
        if (textField.text.length<4) {
            return YES;
        }else{
            //已经填写了4位验证码,计时器停止计时
            if (_timer.isValid) {
                //已按要求填写验证码，恢复button状态
                _getRandomBtn.backgroundColor = [UIColor greenColor];
                _getRandomBtn.userInteractionEnabled = YES;
                [_getRandomBtn setTitle:@"验证" forState:UIControlStateNormal];
                //
                [_timer invalidate];
                _timer = nil;
            }
            
            return NO;
        }
    }else{
        if (textField.text.length<11) {
            return YES;
        }else{
            return NO;
        }
        
    }
}

@end
