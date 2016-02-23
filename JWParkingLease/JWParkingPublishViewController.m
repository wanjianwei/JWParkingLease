//
//  JWParkingPublishViewController.m
//  JWParkingLease
//
//  Created by jway on 16/1/11.
//  Copyright © 2016年 jway. All rights reserved.
//

#import "JWParkingPublishViewController.h"
#import "JWChoseVillageViewController.h"
@interface JWParkingPublishViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,getParkingAddressDelegate,UITextViewDelegate>{
    //价格输入框
    UITextField * price;
    
    //下一步按钮
    UIButton * btn;
    
    
    //定义一个日期选择器
    UIDatePicker * datePickerView;
    
    //额外说明输入框
    UITextView * illustrationView;
    
    /**
     定义一个标志，来表示车位租让类型,其中“0”表示出租，“1”表示出售，“2”表示共享
     */
    int leaseType;
}

//添加表视图
@property(nonatomic,strong)UITableView * tableView;

//定义一个字典类型数据，用于存储表单信息
@property(nonatomic,strong)NSMutableDictionary * parkingInfo;

//定义一个日期选择器背景view
@property(nonatomic,strong)UIView * bgView;

@end

@implementation JWParkingPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    //构造日期选择器
    [self makeDatePickerView];
    
    leaseType = 0;
    
    self.parkingInfo = [NSMutableDictionary dictionaryWithDictionary:@{@"leaseType":@"出租",@"detailAddress":@"请先获取街区/商场名称",@"address":@"",@"carportType":@"地上车位",@"carportPrice":@"",@"leaseBeginTime":@"",@"leaseEndTime":@"",@"illustration":@""}];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//构造日期选择器
-(void)makeDatePickerView{
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.tableView.bounds.size.height, [UIScreen mainScreen].bounds.size.width, 230)];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bgView];
    
    
    //添加标题
    UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-50, 5, 100, 20)];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont boldSystemFontOfSize:18];
    titleLab.text = @"请选择日期";
    [_bgView addSubview:titleLab];
    
    //添加取消按钮
    UIButton * finishBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-80, 5, 60, 20)];
    [finishBtn setTitle:@"取消" forState:UIControlStateNormal];
    [finishBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [finishBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    //添加事件响应
    [finishBtn addTarget:self action:@selector(finish) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:finishBtn];
    
    //添加完成选择按钮
    UIButton * doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 5, 60, 20)];
    [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    [doneBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [doneBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    //添加事件响应
    [doneBtn addTarget:self action:@selector(chooseDone) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:doneBtn];
    
    
    //日期选择器
    datePickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 30, [UIScreen mainScreen].bounds.size.width, 200)];
    datePickerView.datePickerMode = UIDatePickerModeDate;
    datePickerView.maximumDate = [NSDate dateWithTimeIntervalSinceNow:946080000];
    datePickerView.minimumDate = [NSDate date];
    //添加事件响应
    [_bgView addSubview:datePickerView];
}


//提交出租申请
-(void)handRequest:(id)sender{
    //先判断信息是否填写完整
    if ([self shouldGotoNextPage:_parkingInfo]) {
       
    }else{
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请将信息填写完整" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
}


//取消日期选择
-(void)finish{
    [UIView animateWithDuration:0.5 animations:^{
        //选择器消失
        CGRect frame = _bgView.frame;
        frame.origin.y = [UIScreen mainScreen].bounds.size.height;
        _bgView.frame = frame;
    } completion:nil];
}

//完成日期选择
-(void)chooseDone{
    NSDate * selectDate = [datePickerView date];
    //日期格式转换
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    
    [UIView animateWithDuration:0.5 animations:^{
        //隐藏
        CGRect frame = _bgView.frame;
        frame.origin.y = [UIScreen mainScreen].bounds.size.height;
        _bgView.frame = frame;
        
    } completion:^(BOOL finished) {
        //更新表示图及parkingInfo
        if (datePickerView.tag == 1) {
            [_parkingInfo setObject:[dateFormatter stringFromDate:selectDate] forKey:@"leaseBeginTime"];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:2 inSection:2]] withRowAnimation:UITableViewRowAnimationFade];
        }else{
            [_parkingInfo setObject:[dateFormatter stringFromDate:selectDate] forKey:@"leaseEndTime"];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:3 inSection:2]] withRowAnimation:UITableViewRowAnimationFade];
        }
    }];
}



//定义一个方法，用于检查_parkingInfo是否有空值
-(BOOL)shouldGotoNextPage:(NSMutableDictionary*)dic{
    
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
    return 5;
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
    }else if(section == 3){
        return 1;
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
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }else if (indexPath.row == 2 ){
                cell.textLabel.text = @"起始时间:";
                cell.detailTextLabel.text = [_parkingInfo objectForKey:@"leaseBeginTime"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else{
                cell.textLabel.text = @"截止时间:";
                cell.detailTextLabel.text = [_parkingInfo objectForKey:@"leaseEndTime"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            break;
        }
        case 3:{
            if (![cell.contentView.subviews containsObject:illustrationView]) {
                illustrationView = [[UITextView alloc] initWithFrame:CGRectMake(16, 0, [UIScreen mainScreen].bounds.size.width-32, 90)];
                illustrationView.delegate = self;
                illustrationView.textAlignment = NSTextAlignmentLeft;
                illustrationView.font = [UIFont boldSystemFontOfSize:14];
                illustrationView.returnKeyType = UIReturnKeyDone;
                [cell.contentView addSubview:illustrationView];
            }
            illustrationView.text = [_parkingInfo objectForKey:@"illustration"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        }
        case 4:{
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

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        return 90;
    }else{
        return 44;
    }
}

//section的标题
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"请选择租让类型";
    }else if (section == 1){
        return @"车位地址信息";
    }else if (section == 2){
        return @"车位租让信息";
    }else if (section == 3){
        return @"额外说明";
    }else{
        return nil;
    }
}

//点击单元格
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
            //将价格清空
            [_parkingInfo setObject:@"" forKey:@"carportPrice"];
            
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
            
            
            
            datePickerView.tag = 1;
            [UIView animateWithDuration:0.5 animations:^{
                //选择器出现
                CGRect frame = _bgView.frame;
                frame.origin.y = frame.origin.y-230;
                _bgView.frame = frame;
                
            } completion:nil];
            
        }else if (indexPath.row == 3){
            datePickerView.tag = 2;
            [UIView animateWithDuration:0.5 animations:^{
                //选择器出现
                CGRect frame = _bgView.frame;
                frame.origin.y -=230;
                _bgView.frame = frame;
            } completion:nil];
        }
        
    }
}


#pragma UITextfieldDelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    DLog(@"123");
    
    CGRect rect = [_tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]];
    
    DLog(@"y=%f",self.view.bounds.size.height - CGRectGetMaxY(rect));
    
    
    
    if (self.view.bounds.size.height - CGRectGetMaxY(rect)<246) {
        //tableView要往上移动
        [UIView animateWithDuration:0.5 animations:^{
            CGRect rect_temp = self.tableView.frame;
            rect_temp.origin.y = (self.view.bounds.size.height-CGRectGetMaxY(rect))-216;
            self.tableView.frame = rect_temp;
        }];
    }
    
}

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


#pragma UITtextViewDelegate

-(void)textViewDidBeginEditing:(UITextView *)textView{
    DLog(@"kais");
    
}

//关闭键盘
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    //更新值或是
    DLog(@"jieshu");
}


#pragma getParkingAddressDelegate
-(void)getCarportAddress:(NSDictionary *)addressdic{
    //设置值并更新表视图
    [_parkingInfo setObject:[addressdic objectForKey:@"detailAddress"] forKey:@"detailAddress"];
    [_parkingInfo setObject:[addressdic objectForKey:@"address"] forKey:@"address"];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation: UITableViewRowAnimationFade];
}


@end
