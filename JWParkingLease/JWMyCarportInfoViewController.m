//
//  JWMyCarportInfoViewController.m
//  JWParkingLease
//
//  Created by jway on 16/1/19.
//  Copyright © 2016年 jway. All rights reserved.
//

#import "JWMyCarportInfoViewController.h"
#import "JWParkingInfo.h"
#import "AppDelegate.h"

@interface JWMyCarportInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    //应用程序委托
    AppDelegate * app;
    //价格
    UITextField * price;
    //说明
    UITextView * illustration;
    //修改按钮
    UIButton * modifyBtn;
    
    //当前是否处于修改状态
    BOOL isEditing;
}

//车位信息表
@property(nonatomic,strong) UITableView * carportInfoTable;
//存储车位信息
@property(nonatomic,strong) JWParkingInfo * carportInfo;

@end

@implementation JWMyCarportInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    self.title = @"我的车位";
    _carportInfoTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _carportInfoTable.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _carportInfoTable.delegate = self;
    _carportInfoTable.dataSource = self;
    [self.view addSubview:_carportInfoTable];
    
    app = [[UIApplication sharedApplication] delegate];
    
    //开始时，车位信息不可修改
    isEditing = NO;
    
    _carportInfo = [[JWParkingInfo alloc] initWithDic:@{@"carportId":@"1",@"portrait":@"122",@"username":@"wanjway",@"publishTime":@"1452598829",@"carportImages":@[@"123.png",@"2323.png"],@"leaseType":@"出租",@"carportPrice":@"12元/月",@"carportType":@"地上车位",@"commentNum":@"123",@"praiseNum":@"2324",@"illustration":@"电影《天下无贼》里，“黎叔”领着盗窃团伙乘火车走一路偷一路，在现实生活中，一个由女版“黎叔”带队的聋哑人盗窃团伙，则升级为坐飞机到全国各地行窃。而电影中威逼利诱他人参与团伙、残忍的处罚所谓“不听话”成员等行为，在该团伙中都能找到",@"leaseBeginTime":@"2015年12月23日",@"leaseEndTime":@"2015年12月26日",@"address":@"华中科技大学",@"detailAddress":@"湖北省武汉市洪山区"} WithInfoType:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)modifyCarportInfo{
    if (!isEditing) {
        isEditing = YES;
        [self.carportInfoTable reloadData];
    }else{
        //提交修改给服务器服务器,成功后isEding = NO；
    }
}

#pragma UITableViewDelegate/dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 4;
    }else if (section == 1){
        return 2;
    }else if (section == 2){
        return 2;
    }else{
        return 1;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"carportCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"carportCell"];
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"租让形式";
            cell.detailTextLabel.text = _carportInfo.leaseType;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if (indexPath.row == 1){
            cell.textLabel.text = @"车位类型";
            cell.detailTextLabel.text = _carportInfo.carportType;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if (indexPath.row == 2){
            cell.textLabel.text = @"车位租价";
            if (![cell.contentView.subviews containsObject:price]) {
                price = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, [UIScreen mainScreen].bounds.size.width-100-16, 44)];
                price.textAlignment = NSTextAlignmentRight;
                price.textColor = [UIColor grayColor];
                price.delegate = self;
                if ([_carportInfo.leaseType isEqualToString:@"出售"]) {
                    price.placeholder = @"单位:万";
                }else{
                    price.placeholder = @"单位:元/月";
                }
                [cell.contentView addSubview:price];
            }
            price.text = _carportInfo.carportPrice;
            
        }else{
            cell.textLabel.text = @"车位图片";
            if (_carportInfo.carportImages.count == 0) {
                cell.detailTextLabel.text = @"未上传";
            }else{
                cell.detailTextLabel.text = @"已上传";
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        if (isEditing) {
            cell.userInteractionEnabled = YES;
        }else{
            cell.userInteractionEnabled = NO;
        }
        
        return cell;
    }else if (indexPath.section == 1){
        //地址信息
        if (indexPath.row == 0) {
            cell.textLabel.text = @"详细地址";
            cell.detailTextLabel.text = _carportInfo.detailAddress;
        }else{
            cell.textLabel.text = @"所在市区";
            cell.detailTextLabel.text = _carportInfo.address;
        }
        cell.userInteractionEnabled = NO;
        return cell;
    }else if (indexPath.section == 2){
        //出租时段
        if (indexPath.row == 0) {
            cell.textLabel.text = @"起始时间";
            if ([_carportInfo.leaseType isEqualToString:@"出售"]) {
                cell.detailTextLabel.text = @" - 年 - 月 - 日";
            }else{
                cell.detailTextLabel.text = _carportInfo.leaseBeginTime;
            }
            
        }else{
            cell.textLabel.text = @"截止时间";
            if ([_carportInfo.leaseType isEqualToString:@"出售"]) {
                cell.detailTextLabel.text = @" - 年 - 月 - 日";
            }else{
                cell.detailTextLabel.text = _carportInfo.leaseEndTime;
            }
        }
        if (isEditing) {
            cell.userInteractionEnabled = YES;
        }else{
            cell.userInteractionEnabled = NO;
        }
        
        return cell;
    }else if (indexPath.section == 3){
        if (![cell.contentView.subviews containsObject:illustration]) {
            illustration = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 90)];
            illustration.textAlignment = NSTextAlignmentLeft;
            illustration.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:illustration];
        }
        illustration.text = _carportInfo.illustration;
        
        if (isEditing) {
            cell.userInteractionEnabled = YES;
        }else{
            cell.userInteractionEnabled = NO;
        }
        
        return cell;
    }else{
        
        modifyBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
        [modifyBtn setBackgroundColor:[UIColor redColor]];
        [modifyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [modifyBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        
        if (isEditing) {
            [modifyBtn setTitle:@"保存" forState:UIControlStateNormal];
        }else{
            [modifyBtn setTitle:@"修改" forState:UIControlStateNormal];
        }
        
        [modifyBtn addTarget:self action:@selector(modifyCarportInfo) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:modifyBtn];
        
        return cell;
    }
    
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"车位基本信息(可修改)";
    }else if (section == 1){
        return @"车位详细地址信息(不可修改)";
    }else if (section == 2){
        return @"车位租让时段(可修改)";
    }else if (section == 3){
        return @"附加说明(可修改)";
    }else{
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        return 90;
    }else{
        return 44;
    }
}

@end
