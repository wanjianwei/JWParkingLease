//
//  JWLoginViewController.m
//  JWParkingLease
//
//  Created by jway on 16/1/5.
//  Copyright © 2016年 jway. All rights reserved.
//

#import "JWLoginViewController.h"
#import "AppDelegate.h"
#import "XMNAnimTextFiled.h"
#import "JWGetRandomViewController.h"

#import <CommonCrypto/CommonDigest.h>

@interface JWLoginViewController ()<UITextFieldDelegate>{
     AppDelegate * app;
}

@property (retain, nonatomic)  XMNAnimTextFiled *username;
@property (retain, nonatomic)  XMNAnimTextFiled *password;

//登录按钮
@property(strong,nonatomic) UIButton * loginBtn;

//注册按钮
@property(strong,nonatomic) UIButton * register_now;

//忘记密码
@property(strong,nonatomic) UIButton * forget_pwd;

@end

@implementation JWLoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    self.title = @"用户登录";
    app = [UIApplication sharedApplication].delegate;
    
    //未采用故事版生成的viewcontroller，其view属性默认是nil；
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    //标题栏
    UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 90, [UIScreen mainScreen].bounds.size.width-40, 60)];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.text = @"欢迎来到parkingLease";
    titleLab.textColor = [UIColor redColor];
    titleLab.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:titleLab];
    
    //初始化用户名
    self.username = [[XMNAnimTextFiled alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(titleLab.frame)+26, [UIScreen mainScreen].bounds.size.width-40, 50)];
    [_username setPlaceHolderText:@"请输入用户名"];
    [_username setPlaceHolderIcon:[UIImage imageNamed:@"login_user.png"]];
    //指定协议代理
    _username.delegate = self;
    //设置textField的tag
    [_username textField].tag = 1;
    [self.view addSubview:_username];
    
    
    //初始化密码输入框
    self.password = [[XMNAnimTextFiled alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_username.frame)+30, [UIScreen mainScreen].bounds.size.width-40, 50)];
    [_password setPlaceHolderText:@"请输入密码"];
    [_password setPlaceHolderIcon:[UIImage imageNamed:@"login_pwd.png"]];
    [_password setTipsIcon:[UIImage imageNamed:@"invisible_icon@2x.png"]];
    [_password setInputType:XMNAnimTextFieldInputTypePassword];
    _password.delegate = self;
    [_password textField].tag = 2;;
    [self.view addSubview:_password];
    
    //登录按钮
    self.loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_password.frame)+50, [UIScreen mainScreen].bounds.size.width-40, 45)];
    _loginBtn.backgroundColor = [UIColor greenColor];
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    _loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    _loginBtn.layer.cornerRadius = 5.0f;
    
    //添加事件
    [_loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginBtn];
    
    //注册按钮
    self.register_now = [[UIButton alloc] initWithFrame:CGRectMake(80, CGRectGetHeight(self.view.bounds)-50, 70, 30)];
    [_register_now setTitle:@"注册账户" forState:UIControlStateNormal];
    [_register_now setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [_register_now setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    _register_now.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    //添加事件
    [_register_now addTarget:self action:@selector(gotoRegister) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_register_now];
    
    //分割符号
    UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(_loginBtn.frame)-10, CGRectGetHeight(self.view.bounds)-50, 20, 30)];
    lab.text = @"|";
    lab.font = [UIFont boldSystemFontOfSize:20];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor blackColor];
    [self.view addSubview:lab];
    
    //忘记密码按钮
    self.forget_pwd = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-150, CGRectGetHeight(self.view.bounds)-50, 70, 30)];
    [_forget_pwd setTitle:@"忘记密码" forState:UIControlStateNormal];
    
    [_forget_pwd setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_forget_pwd setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    _forget_pwd.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [_forget_pwd addTarget:self action:@selector(forgetPasswd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_forget_pwd];
    
    //定义 一个手势处理器，用于关闭键盘
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handTap)];
    tap.numberOfTapsRequired = 1;
    
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//关闭键盘
-(void)handTap{
    //关闭键盘，并恢复至未编辑状态
    self.username.state = XMNAnimTextFieldStateNormal;
    self.password.state = XMNAnimTextFieldStateNormal;
}

//登录
- (void)login{
    
    if ([_username.text isEqualToString:@""]) {
        _username.state = XMNAnimTextFieldStateError;
        return;
        
    }else if ([_password.text isEqualToString:@""]){
        _password.state = XMNAnimTextFieldStateError;
        return;
        
    /*}else if ([[NSUserDefaults standardUserDefaults] objectForKey:@"registrationId"] == nil){
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"注册推送失败" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];*/
        
    }else{
        
        //假定登录成功后
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"loginState"];
        
        //设置昵称
        [[NSUserDefaults standardUserDefaults] setObject:@"wanjway" forKey:@"nickname"];
        
        //设置肖像
        [[NSUserDefaults standardUserDefaults] setObject:@"123" forKey:@"portrait"];
        
        if (_loginType == 1) {
            //还是要投递登录成功通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccessNotification" object:nil];
        }else{
            [self.navigationController popViewControllerAnimated:YES];

        }
    }
}

//跳转到获取验证码界面
-(void)gotoRegister{
    
    JWGetRandomViewController * randomView = [[JWGetRandomViewController alloc] init];
    randomView.isRegister = YES;
    randomView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:randomView animated:YES];
    
}

//忘记密码——重置密码界面
- (void)forgetPasswd{
    JWGetRandomViewController * randomView = [[JWGetRandomViewController alloc] init];
    randomView.isRegister = NO;
    randomView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:randomView animated:YES];
}

//MD5算法加密--32位的大写MD5加密
-(NSString *)md5HexDigest:(NSString*)input{
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (int)strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++){
        [ret appendFormat:@"%02X",result[i]];
    }
    return ret;
}


#pragma UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (_username.state == XMNAnimTextFieldStateEditing) {
        _username.state = XMNAnimTextFieldStateNormal;
    }
    if (_password.state == XMNAnimTextFieldStateEditing) {
        _password.state = XMNAnimTextFieldStateNormal;
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.tag == 2) {
        CGFloat height = [UIScreen mainScreen].bounds.size.height - CGRectGetMaxY(_password.frame);
        //view往上移动以避免被键盘遮挡
        if (height<216) {
            [UIView animateWithDuration:0.5 animations:^{
                CGRect frame = self.view.frame;
                frame.origin.y += (height-216);
                self.view.frame = frame;
                
            } completion:nil];
        }
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 2) {
        //如果view发生了上移，则恢复
        if (self.view.frame.origin.y<0) {
            [UIView animateWithDuration:0.5 animations:^{
                
                CGRect frame = self.view.frame;
                frame.origin.y = 0;
                
                self.view.frame = frame;
                
            } completion:nil];
        }
    }
}

@end
