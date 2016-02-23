//
//  JWParkingLeaseViewController.m
//  JWParkingLease
//
//  Created by jway on 15/12/16.
//  Copyright © 2015年 jway. All rights reserved.
//

#import "JWParkingLeaseViewController.h"
#import "JWChoseVillageViewController.h"
#import "choseTimeViewController.h"
@interface JWParkingLeaseViewController ()<UITextFieldDelegate,getParkingAddressDelegate>{
   
    //价格输入框
    UITextField * price;
    
    //下一步按钮
    UIButton * btn;
    
    
    //定义一个日期选择器
    UIDatePicker * datePickerView;
    
    /**
     定义一个标志，来表示车位租让类型,其中“0”表示出租，“1”表示出售，“2”表示共享
     */
    int leaseType;
    
    
    
}

//定义一个字典类型数据，用于存储表单信息
@property(nonatomic,strong)NSMutableDictionary * parkingInfo;

@end

@implementation JWParkingLeaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
    
    //构造日期选择器
    [self makeDatePickerView];

    leaseType = 0;
    
    self.parkingInfo = [NSMutableDictionary dictionaryWithDictionary:@{@"leaseType":@"出租",@"detailAddress":@"请先获取街区/商场名称",@"address":@"",@"carportType":@"地上车位",@"carportPrice":@"",@"leaseBeginTime":@"",@"leaseEndTime":@""}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//构造日期选择器
-(void)makeDatePickerView{
    
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 230)];
    [self.view addSubview:bgView];
    
    datePickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 216)];
    datePickerView.datePickerMode = UIDatePickerModeDate;
    datePickerView.maximumDate = [NSDate dateWithTimeIntervalSinceNow:946080000];
    datePickerView.minimumDate = [NSDate date];
    //添加事件响应
    [datePickerView addTarget:self action:@selector(chooseDate:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datePickerView];
}


//提交出租申请
-(void)handRequest:(id)sender{
   //先判断信息是否填写完整
    if ([self shouldGotoNextPage:_parkingInfo]) {
        choseTimeViewController * choseView = [[choseTimeViewController alloc] init];
        choseView.parkingInfo = _parkingInfo;
        [self.navigationController pushViewController:choseView animated:YES];
    }else{
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请将信息填写完整" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        
    }

}


//选择时间
-(void)chooseDate:(id)sender{
    
}



//定义一个方法，用于检查_parkingInfo是否有空值
-(BOOL)shouldGotoNextPage:(NSMutableDictionary*)dic{
    /*
    __block BOOL flag = YES;
    while (flag) {
        [dic enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSString * obj, BOOL * _Nonnull stop) {
            if ([obj isEqualToString:@""]) {
                flag = NO;
                * stop = YES;
            }
            
        }];
        break;
    }
    return flag;
    */
    
    if (leaseType == 1) {
        if ([[_parkingInfo objectForKey:@"address"] isEqualToString:@""] || [[_parkingInfo objectForKey:@"carportPrice"] isEqualToString:@""]) {
            return NO;
        }else{
            return YES;
        }
    }else{
        if ([[_parkingInfo objectForKey:@"address"] isEqualToString:@""] || [[_parkingInfo objectForKey:@"carportPrice"] isEqualToString:@""] || [[_parkingInfo objectForKey:@"leaseBeginTime"] isEqualToString:@""] || [[_parkingInfo objectForKey:@"leaseEndTime"] isEqualToString:@""]) {
            return NO;
        }else{
            return YES;
        }
    }
    
}

#pragma UITableViewDelegate/dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 2;
    }else if (section == 2){
        if (leaseType == 1) {
            return 2;
        }else {
            return 4;
        }
    }else{
        return 1;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    /**
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"sheetCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"sheetCell"];
    }
    */
    
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    
    
    switch (indexPath.section) {
        case 0:{
            cell.textLabel.text = @"租让形式";
            cell.detailTextLabel.text = [_parkingInfo objectForKey:@"leaseType"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        case 1:{
            if (indexPath.row == 0) {
                cell.textLabel.text = @"详细地址:";
                cell.detailTextLabel.text = [_parkingInfo objectForKey:@"detailAddress"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }else{
                cell.textLabel.text = @"所在市区:";
                cell.textLabel.textColor = [UIColor lightGrayColor];
                cell.detailTextLabel.text = [_parkingInfo objectForKey:@"address"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            break;
        }
        case 2:{
           
            if (indexPath.row == 0) {
                cell.textLabel.text = @"类型";
                cell.detailTextLabel.text = [_parkingInfo objectForKey:@"carportType"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }else if(indexPath.row == 1){
                cell.textLabel.text = @"租价";
                if (![cell.contentView.subviews containsObject:price]) {
                    [price removeFromSuperview];
                    price = [[UITextField alloc] initWithFrame:CGRectMake(80, 0, [UIScreen mainScreen].bounds.size.width-96, 44)];
                    if (leaseType == 1) {
                        price.placeholder = @"单位:万";
                    }else{
                        price.placeholder = @"单位:元/月";
                    }
                    price.textColor = [UIColor lightGrayColor];
                    price.delegate = self;
                    price.textAlignment = NSTextAlignmentRight;
                    price.returnKeyType = UIReturnKeyDone;
                        
                    [cell.contentView addSubview:price];
                }
                price.text = [_parkingInfo objectForKey:@"carportPrice"];
                    
            }else if (indexPath.row == 2 ){
                cell.textLabel.text = @"起始时间:";
                cell.detailTextLabel.text = [_parkingInfo objectForKey:@"leaseBeginTime"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }else{
                cell.textLabel.text = @"截止时间:";
                cell.detailTextLabel.text = [_parkingInfo objectForKey:@"leaseEndTime"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            break;
        }
        
        case 3:{
            if (![cell.contentView.subviews containsObject:btn]) {
                btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
                btn.backgroundColor = [UIColor redColor];
                [btn setTitle:@"下一步" forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
                [cell.contentView addSubview:btn];
                
                //添加事件响应
                [btn addTarget:self action:@selector(handRequest:) forControlEvents:UIControlEventTouchUpInside];
            }
            break;
        }
        default:
            break;
    }
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"请选择租让类型";
    }else if (section == 1){
        return @"车位地址信息";
    }else if (section == 2){
        return @"车位租让信息";
    }else{
        return nil;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        UIAlertController * alertSheet = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择租让类型" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"出租" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //更新值和表示图
            leaseType = 0;
            [_parkingInfo setObject:@"出租" forKey:@"leaseType"];
            
            //更新section
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
            
            //更新row
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            
            
        }];
        UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"出售" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //更新值和表视图
            leaseType = 1;
            [_parkingInfo setObject:@"出售" forKey:@"leaseType"];
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
            
            //更新row
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            
            
        }];
        
        UIAlertAction * action3 = [UIAlertAction actionWithTitle:@"共享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //更新值和表视图
            leaseType = 2;
            [_parkingInfo setObject:@"共享" forKey:@"leaseType"];
        
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
            
            //更新row
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }];
        
        UIAlertAction * action4 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alertSheet addAction:action1];
        [alertSheet addAction:action2];
        [alertSheet addAction:action3];
        [alertSheet addAction:action4];
        [self presentViewController:alertSheet animated:YES completion:nil];
        
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            //跳转到填写小区界面
            JWChoseVillageViewController * choseValliageView = [[JWChoseVillageViewController alloc] init];
            choseValliageView.delegate = self;
            choseValliageView.isGettingAddress = YES;
            choseValliageView.view.backgroundColor = [UIColor whiteColor];
            [self.navigationController pushViewController:choseValliageView animated:YES];
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            UIAlertController * alertSheet = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择车位类型" preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"地下车位" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //更新值和表示图
                [_parkingInfo setObject:@"地下车位" forKey:@"carportType"];
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:UITableViewRowAnimationFade];
            }];
            UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"地上车位" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //更新值和表视图
                [_parkingInfo setObject:@"地上车位" forKey:@"carportType"];
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:UITableViewRowAnimationFade];
            }];
            
            UIAlertAction * action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            
            [alertSheet addAction:action1];
            [alertSheet addAction:action2];
            [alertSheet addAction:action3];
            [self presentViewController:alertSheet animated:YES completion:nil];
        }else if (indexPath.row == 2){
            DLog(@"23");
            
            
            
        }else if (indexPath.row == 3){
            DLog(@"233");
        }
        
    }
}


#pragma UITextfieldDelegate

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (leaseType == 1) {
        textField.text = [NSString stringWithFormat:@"%.1f万",[textField.text floatValue]];
        //记录期望价格
        [_parkingInfo setObject:textField.text forKey:@"carportPrice"];
        
    }else{
        textField.text = [NSString stringWithFormat:@"%.1f元/月",[textField.text floatValue]];
        //记录期望价格
        [_parkingInfo setObject:textField.text forKey:@"carportPrice"];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [price resignFirstResponder];
    return YES;
}

#pragma getParkingAddressDelegate
-(void)getCarportAddress:(NSDictionary *)addressdic{
    //设置值并更新表视图
    [_parkingInfo setObject:[addressdic objectForKey:@"detailAddress"] forKey:@"detailAddress"];
    [_parkingInfo setObject:[addressdic objectForKey:@"address"] forKey:@"address"];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation: UITableViewRowAnimationFade];
}

@end
