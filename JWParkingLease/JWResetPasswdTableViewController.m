//
//  JWResetPasswdTableViewController.m
//  JWParkingLease
//
//  Created by jway on 16/1/6.
//  Copyright © 2016年 jway. All rights reserved.
//

#import "JWResetPasswdTableViewController.h"
#import "AppDelegate.h"

@interface JWResetPasswdTableViewController ()<UITextFieldDelegate>{
    UITextField * password;
    UITextField * password_again;
    
    //确定按钮
    UIButton * confirmBtn;
    
    //定义一个字典，用于存储用户所填写的信息
    NSMutableDictionary * userInfo;
    //应用程序委托类
    AppDelegate * app;
    //设定三个标志
    BOOL showNotice_1;
    BOOL showNotice_2;
}

@end

@implementation JWResetPasswdTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化标题
    self.title = @"重置密码";
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    userInfo = [NSMutableDictionary dictionaryWithDictionary:@{@"password":@"",@"password_again":@""}];
    
    //初始化
    app = [UIApplication sharedApplication].delegate;
    
    showNotice_1 = NO;
    showNotice_2 = NO;
}

//提交信息
-(void)handUp{
    [password resignFirstResponder];
    [password_again resignFirstResponder];
    
    //如果信息填写都完成，才可以提交
    if ([self isFinishFillInfo]) {
        //
    }else{
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请将上述信息填写完整" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    
}

//定义一个方法，用来判断信息是否填写完整
-(BOOL)isFinishFillInfo{
    
    __block BOOL flag = YES;
    
    while (flag) {
        [userInfo enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSString * obj, BOOL * _Nonnull stop) {
            if ([obj isEqualToString:@""]) {
                *stop = YES;
                flag = NO;
            }
            
        }];
        break;
    }
    return flag;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RegisterCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"RegisterCell"];
    }
    
    if (indexPath.section == 0){
        cell.textLabel.text = @"登录密码:";
        if (![cell.contentView.subviews containsObject:password]) {
            
            [password removeFromSuperview];
            
            password = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, self.tableView.frame.size.width-100, 44)];
            password.borderStyle = UITextBorderStyleNone;
            //username.placeholder = @"";
            password.font = [UIFont boldSystemFontOfSize:17];
            password.textAlignment = NSTextAlignmentLeft;
            password.tag = 1;
            password.delegate = self;
            [cell.contentView addSubview:password];
            
        }
        password.text = [userInfo objectForKey:@"password"];
        
    }else if (indexPath.section == 1){
        cell.textLabel.text = @"密码确认:";
        if (![cell.contentView.subviews containsObject:password_again]) {
            
            [password_again removeFromSuperview];
            
            password_again = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, self.tableView.frame.size.width-100, 44)];
            password_again.borderStyle = UITextBorderStyleNone;
            //username.placeholder = @"";
            password_again.font = [UIFont boldSystemFontOfSize:17];
            password_again.textAlignment = NSTextAlignmentLeft;
            password_again.tag = 2;
            password_again.delegate = self;
            [cell.contentView addSubview:password_again];
            
        }
        password_again.text = [userInfo objectForKey:@"password_again"];
        
    }else{
        if (![cell.subviews containsObject:confirmBtn]) {
            confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
            confirmBtn.backgroundColor = [UIColor greenColor];
            [confirmBtn setTitle:@"提交" forState:UIControlStateNormal];
            [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [confirmBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
            //添加控制事件
            [confirmBtn addTarget:self action:@selector(handUp) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:confirmBtn];
        }
    }
    
    return cell;
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return  @"请输入由数字、字母、下划线组成的6~24位字符";
    }else if (section == 1){
        return @"请再次输入密码";
    }else{
        return nil;
    }
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, self.tableView.frame.size.width-32, 30)];
    lab.textAlignment = NSTextAlignmentLeft;
    lab.font = [UIFont boldSystemFontOfSize:12];
    lab.textColor = [UIColor redColor];
    
     if (section == 0){
        if (showNotice_1) {
            lab.text = @" *输入密码不符合要求";
            return lab;
        }else{
            return nil;
        }
    }else if (section == 1){
        if (showNotice_2) {
            lab.text =  @" *密码输入与之前不一致";
            return lab;
        }else{
            return nil;
        }
    }else{
        return nil;
    }
}


#pragma UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 1){
        if ([[NSPredicate predicateWithFormat:@"SELF MATCHES %@",[NSString stringWithFormat:@"^[A-Z0-9a-z_]{6,24}+$"]] evaluateWithObject:password.text]){
            showNotice_1 = NO;
            [userInfo setObject:textField.text forKey:@"password"];
        }else{
            showNotice_1 = YES;
            [userInfo setObject:@"" forKey:@"password"];
        }
    }else if (textField.tag == 2){
        if ([textField.text isEqualToString:[userInfo objectForKey:@"password"]]) {
            showNotice_2 = NO;
            [userInfo setObject:textField.text forKey:@"password_again"];
        }else{
            showNotice_2 = YES;
            [userInfo setObject:@"" forKey:@"password_again"];
        }
    }
    //刷新该section
    [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:textField.tag-1] withRowAnimation:UITableViewRowAnimationFade];
    
    
}

@end
