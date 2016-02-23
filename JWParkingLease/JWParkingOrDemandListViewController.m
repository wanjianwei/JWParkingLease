//
//  JWParkingOrDemandListViewController.m
//  JWParkingLease
//
//  Created by jway on 16/1/20.
//  Copyright © 2016年 jway. All rights reserved.
//

#import "JWParkingOrDemandListViewController.h"
#import "AppDelegate.h"
#import "JWParkingInfoCustomCell.h"
#import "JWParkingDetailInfoViewController.h"
@interface JWParkingOrDemandListViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    AppDelegate * app;
}

@property(nonatomic,strong) UITableView * listView;
//定义一个数组，用于存储车位或需求信息
@property(nonatomic,strong) NSMutableArray * infoArray;

@end

@implementation JWParkingOrDemandListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化
    if ([_typeInfo isEqualToString:@"1"]) {
        self.title = @"需求列表";
    }else{
        self.title = @"车位列表";
    }
    
    self.listView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.listView.backgroundColor = [UIColor clearColor];
    _listView.delegate = self;
    _listView.dataSource = self;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_listView];
    
    app = [[UIApplication sharedApplication] delegate];
    _infoArray = [[NSMutableArray alloc] init];
    
    NSArray * idArray = [_infoId componentsSeparatedByString:@"#"];

    //构造虚拟数据
    if ([_typeInfo isEqualToString:@"1"]) {
        //需求数据
        for (int i =0; i<idArray.count; i++) {
            JWParkingInfo * info = [[JWParkingInfo alloc] initWithDic:@{@"demandId":@"1",@"portrait":@"",@"username":@"wanjway",@"publishTime":@"1452598829",@"leaseType":@"出租",@"carportPrice":@"12元/月",@"carportType":@"地上车位",@"commentNum":@"123",@"praiseNum":@"2324",@"illustration":@"电影《天下无贼》里，“黎叔”领着盗窃团伙乘火车走一路偷一路，在现实生活中，一个由女版“黎叔”带队的聋哑人盗窃团伙，则升级为坐飞机到全国各地行窃。而电影中威逼利诱他人参与团伙、残忍的处罚所谓“不听话”成员等行为，在该团伙中都能找到",@"leaseBeginTime":@"2015年12月23日",@"leaseEndTime":@"2015年12月26日",@"address":@"华中科技大学",@"detailAddress":@"湖北省武汉市洪山区"} WithInfoType:2];
            JWParkingInfoFrame * frame = [[JWParkingInfoFrame alloc] initWithFrameType:2];
            frame.parkingInfo = info;
            [_infoArray addObject:frame];
        }
    }else{
        //请求车位数据
        for (int i =0; i<idArray.count; i++) {
            JWParkingInfo * info = [[JWParkingInfo alloc] initWithDic:@{@"carportId":@"1",@"portrait":@"",@"username":@"wanjway",@"publishTime":@"1452598829",@"carportImages":@[@"h1.jpg",@"h2.jpg"],@"leaseType":@"出售",@"carportPrice":@"12元/月",@"carportType":@"地上车位",@"commentNum":@"123",@"praiseNum":@"2324",@"illustration":@"电影《天下无贼》里，“黎叔”领着盗窃团伙乘火车走一路偷一路，在现实生活中，一个由女版“黎叔”带队的聋哑人盗窃团伙，则升级为坐飞机到全国各地行窃。而电影中威逼利诱他人参与团伙、残忍的处罚所谓“不听话”成员等行为，在该团伙中都能找到",@"leaseBeginTime":@"2015年12月23日",@"leaseEndTime":@"2015年12月26日",@"address":@"华中科技大学",@"detailAddress":@"湖北省武汉市洪山区"} WithInfoType:1];
            JWParkingInfoFrame * frame = [[JWParkingInfoFrame alloc] initWithFrameType:1];
            frame.parkingInfo = info;
            
            [_infoArray addObject:frame];
        }
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITableViewDelegate/DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _infoArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JWParkingInfoCustomCell * cell;
    if ([_typeInfo isEqualToString:@"1"]) {
        //需求信息
        cell = [tableView dequeueReusableCellWithIdentifier:@"demandCell"];
        if (cell == nil) {
            cell = [[JWParkingInfoCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"demandCell" AndCellType:2];
        }

    }else{
        //车位信息
        cell = [tableView dequeueReusableCellWithIdentifier:@"carportCell"];
        if (cell == nil) {
            cell = [[JWParkingInfoCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"carportCell" AndCellType:1];
        }
    }
    
    cell.parkingInfoFrame = [_infoArray objectAtIndex:indexPath.section];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [[_infoArray objectAtIndex:indexPath.section] cellHeight];
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JWParkingDetailInfoViewController * detailInfoView = [[JWParkingDetailInfoViewController alloc] init];
    detailInfoView.infoType = [_typeInfo intValue];
    detailInfoView.parkingInfo = [[_infoArray objectAtIndex:indexPath.section] parkingInfo];
    [self.navigationController pushViewController:detailInfoView animated:YES];
    
}

@end
