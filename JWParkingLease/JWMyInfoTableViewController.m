//
//  JWMyInfoTableViewController.m
//  JWParkingLease
//
//  Created by jway on 16/1/21.
//  Copyright © 2016年 jway. All rights reserved.
//

#import "JWMyInfoTableViewController.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
@interface JWMyInfoTableViewController (){
    AppDelegate * app;
    
}

//存储用户信息
@property(nonatomic,strong) NSDictionary * userInfo;


@end

@implementation JWMyInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    self.title = @"个人信息";
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    app = [[UIApplication sharedApplication] delegate];
    
   
    
    //构造虚拟数据
    _userInfo = @{@"username":@"wanjway",@"password":@"12345",@"telphone":@"18183445834",@"portrait":@"123.png",@"registerTime":@"2014/12/23",@"gender":@"男",@"profession":@"学生",@"age":@"23",@"mailbox":@"12334@qq.com"};
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 5;
    }else{
        return 4;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infoCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"infoCell"];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"头像";
            UIImageView * portraitView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
            [portraitView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://120.25.162.238/parkingLease/portrait/%@",[_userInfo objectForKey:@"portrait"]]] placeholderImage:[UIImage imageNamed:@"portrait.png"]];
            portraitView.layer.cornerRadius = 25;
            portraitView.layer.masksToBounds = YES;
            cell.accessoryView = portraitView;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if (indexPath.row == 1){
            cell.textLabel.text = @"用户名称";
            cell.detailTextLabel.text = [_userInfo objectForKey:@"username"];
           // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else if (indexPath.row == 2){
            cell.textLabel.text = @"注册手机";
            cell.detailTextLabel.text = [_userInfo objectForKey:@"telphone"];
            //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else if(indexPath.row == 3){
            cell.textLabel.text = @"修改密码";
            cell.detailTextLabel.text = [_userInfo objectForKey:@"password"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.textLabel.text = @"注册时间";
            cell.detailTextLabel.text = [_userInfo objectForKey:@"registerTime"];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }else{
        if (indexPath.row == 0) {
            cell.textLabel.text = @"年龄";
            cell.detailTextLabel.text = [_userInfo objectForKey:@"age"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if (indexPath.row == 1){
            cell.textLabel.text = @"性别";
            cell.detailTextLabel.text = [_userInfo objectForKey:@"gender"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if (indexPath.row == 2){
            cell.textLabel.text = @"职业";
            cell.detailTextLabel.text = [_userInfo objectForKey:@"profession"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.textLabel.text = @"邮箱";
            cell.detailTextLabel.text = [_userInfo objectForKey:@"mailbox"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }else{
        return @"我的详细信息";
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 80;
    }else{
        return 50;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"头像上传" message:@"请选择图片来源" preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"打开相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //
            }];
            UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"打开相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            }];
            UIAlertAction * action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:action1];
            [alert addAction:action2];
            [alert addAction:action3];
            [self presentViewController:alert animated:YES completion:nil];
        }else if (indexPath.row == 3){
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"修改登录密码" message:@"请按要求填写" preferredStyle:UIAlertControllerStyleAlert];
          
            [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder = @"请输入原有密码";
            }];
            
            [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder = @"请输入新密码";
            }];
            
            UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //发送给服务器
            }];
            
            UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:action1];
            [alert addAction:action2];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }
    }else{
        //我的基本信息修改或填写
        
       
   }
}

@end
