//
//  MyInfoTableViewController.m
//  JWParkingLease
//
//  Created by jway on 15/12/15.
//  Copyright © 2015年 jway. All rights reserved.
//

#import "MyInfoTableViewController.h"
#import "UIImageView+WebCache.h"
@interface MyInfoTableViewController (){
    UIImageView * portrait;
    UILabel * nickname;
}

@end

@implementation MyInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化
    self.title = @"用户设置";
    
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIImageView * bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, ([UIScreen mainScreen].bounds.size.height-64)/3)];
    bgView.image = [UIImage imageNamed:@"my_profile_bg.png"];
    
    portrait = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-45, ([UIScreen mainScreen].bounds.size.height-64)/6-50, 90, 90)];
    [portrait sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"portrait.png"]];
    portrait.layer.cornerRadius = 45;
    portrait.layer.masksToBounds = YES;
    [bgView addSubview:portrait];
    bgView.userInteractionEnabled = YES;
    //定义一个按钮，覆盖在头像上
    UIButton * tapBtn = [[UIButton alloc] initWithFrame:portrait.frame];
    [tapBtn addTarget:self action:@selector(uploadPortrait) forControlEvents:UIControlEventTouchUpInside];
    [tapBtn setBackgroundColor:[UIColor clearColor]];
    [bgView addSubview:tapBtn];    
    
    
    //设置昵称
    nickname = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(portrait.frame)+15,[UIScreen mainScreen].bounds.size.width, 30)];
    nickname.textAlignment = NSTextAlignmentCenter;
    nickname.font = [UIFont boldSystemFontOfSize:20];
    nickname.text = @"jway_wan";
    [bgView addSubview:nickname];
    [self.tableView setTableHeaderView:bgView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//退出操作
-(void)logout{
    
}

//上传头像
-(void)uploadPortrait{
    DLog(@"123");
    UIAlertController *  alertSheet = [UIAlertController alertControllerWithTitle:@"请图像来源" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"从相册中选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //
    }];
    UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"从相机选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //
    }];
    
    UIAlertAction * action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertSheet addAction:action1];
    [alertSheet addAction:action2];
    [alertSheet addAction:action3];
    [self presentViewController:alertSheet animated:YES completion:nil];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (tableView.dataSource>0) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self p_hideExtraTableCellSeparatorLine:tableView];
    }else{
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return 3;
}

//隐藏多余的单元格分割线
-(void)p_hideExtraTableCellSeparatorLine:(UITableView*)tableView{
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }else if (section == 1){
        return 1;
    }else{
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infoCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"infoCell"];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"姓名";
            cell.detailTextLabel.text = @"万建伟";
        }else if (indexPath.row == 1){
            cell.textLabel.text = @"性别";
            cell.detailTextLabel.text = @"保密";
        }else{
            cell.textLabel.text = @"电话";
            cell.detailTextLabel.text = @"181****7139";
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if ( indexPath.section == 1){
        cell.textLabel.text = @"密码";
        cell.detailTextLabel.text = @"******";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
        [btn setTitle:@"退出" forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor redColor];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

//点击单元格
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DLog(@"23445545");
    
    UIAlertController * alertSheet = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择车位类型" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"个人车位" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //
    }];
    UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"智能停车位" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //
    }];
    
    UIAlertAction * action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertSheet addAction:action1];
    [alertSheet addAction:action2];
    [alertSheet addAction:action3];
    [self presentViewController:alertSheet animated:YES completion:nil];
}
@end
