//
//  JWMyDemandInfoDetailTableViewController.m
//  JWParkingLease
//
//  Created by jway on 16/1/20.
//  Copyright © 2016年 jway. All rights reserved.
//

#import "JWMyDemandInfoDetailTableViewController.h"
#import "JWParkingInfo.h"
#import "AppDelegate.h"
@interface JWMyDemandInfoDetailTableViewController (){
    AppDelegate * app;
}

//存储数据
@property(nonatomic,strong) JWParkingInfo * demandInfo;

@end

@implementation JWMyDemandInfoDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    self.title = @"需求详情";
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    app = [[UIApplication sharedApplication] delegate];
    
    //构造虚拟数据
    _demandInfo = [[JWParkingInfo alloc] initWithDic:@{@"demandId":@"1",@"portrait":@"122",@"username":@"wanjway",@"publishTime":@"1452598829",@"leaseType":@"出租",@"carportPrice":@"12元/月",@"carportType":@"地上车位",@"commentNum":@"123",@"praiseNum":@"2324",@"illustration":@"电影《天下无贼》里，“黎叔”领着盗窃团伙乘火车走一路偷一路，在现实生活中，一个由女版“黎叔”带队的聋哑人盗窃团伙，则升级为坐飞机到全国各地行窃。而电影中威逼利诱他人参与团伙、残忍的处罚所谓“不听话”成员等行为，在该团伙中都能找到",@"leaseBeginTime":@"2015年12月23日",@"leaseEndTime":@"2015年12月26日",@"address":@"华中科技大学",@"detailAddress":@"湖北省武汉市洪山区"} WithInfoType:2];
    
}

//删除该条信息
-(void)deleteNow{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }else if (section == 1){
        return 2;
    }else if (section == 2){
        return 2;
    }else{
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"demandCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"demandCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = [UIColor grayColor];
    }else{
        //将cell中添加的子视图全部删除
        while ([cell.contentView.subviews lastObject] != nil){
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"求租形式";
            cell.detailTextLabel.text = _demandInfo.leaseType;
        }else if (indexPath.row == 1){
            cell.textLabel.text = @"车位类型";
            cell.detailTextLabel.text = _demandInfo.carportType;
        }else{
            cell.textLabel.text  =@"接受租价";
            cell.detailTextLabel.text = _demandInfo.carportPrice;
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            cell.textLabel.text = @"详细地址";
            cell.detailTextLabel.text = _demandInfo.detailAddress;
        }else{
            cell.textLabel.text = @"所在市区";
            cell.detailTextLabel.text = _demandInfo.address;
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            cell.textLabel.text = @"起始时间";
            cell.detailTextLabel.text = [_demandInfo.leaseBeginTime isEqualToString:@""]?@"- 年 - 月 - 日":_demandInfo.leaseBeginTime;
        }else{
            cell.textLabel.text = @"截止时间";
            cell.detailTextLabel.text = [_demandInfo.leaseEndTime isEqualToString:@""]?@"- 年 - 月 - 日":_demandInfo.leaseEndTime;
        }
    }else if (indexPath.section == 3){
        
        NSString * illustrationtext = _demandInfo.illustration;
        CGRect rect = [illustrationtext boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-32, 600) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
        UILabel * illustrationLab = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, [UIScreen mainScreen].bounds.size.width-32, rect.size.height)];
        illustrationLab.numberOfLines = 0;
        illustrationLab.font = [UIFont systemFontOfSize:15];
        illustrationLab.textAlignment = NSTextAlignmentLeft;
        illustrationLab.text = _demandInfo.illustration;
        illustrationLab.textColor = [UIColor grayColor];
        [cell.contentView addSubview:illustrationLab];
        
    }else{
        UIButton * deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
        deleteBtn.backgroundColor = [UIColor redColor];
        [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [deleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        //绑定事件
        [deleteBtn addTarget:self action:@selector(deleteNow) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:deleteBtn];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        CGRect rect = [_demandInfo.illustration boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-32, 600) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
        return rect.size.height;
    }else{
        return 44;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"求租车位的基本信息";
    }else if (section == 1){
        return @"求租车位的地理位置";
    }else if (section == 2){
        return @"求租时段";
    }else if (section == 3){
        return @"补充说明";
    }else{
        return nil;
    }
}

@end
