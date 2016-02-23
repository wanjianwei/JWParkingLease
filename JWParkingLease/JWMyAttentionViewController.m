//
//  JWMyAttentionViewController.m
//  JWParkingLease
//
//  Created by jway on 16/1/20.
//  Copyright © 2016年 jway. All rights reserved.
//

#import "JWMyAttentionViewController.h"
#import "AppDelegate.h"
//下拉刷新和上拉加载
#import "SDRefresh.h"
#import "JWParkingInfoCustomCell.h"
#import "JWParkingDetailInfoViewController.h"
@interface JWMyAttentionViewController ()<UITableViewDataSource,UITableViewDelegate>{
    AppDelegate * app;
}

@property(nonatomic,strong) UITableView * attentionList;

//存储关注的车位
@property(nonatomic,strong) NSMutableArray * carportArray;

//存储关注的需求
@property(nonatomic,strong) NSMutableArray * demandArray;

//分段控制器
@property(nonatomic,strong) UISegmentedControl * typeSeg;
//上拉加载
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;

@end

@implementation JWMyAttentionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    self.title = @"我的关注";
    _attentionList = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _attentionList.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _attentionList.delegate = self;
    _attentionList.dataSource = self;
    [self.view addSubview:_attentionList];
    
    _carportArray = [[NSMutableArray alloc] init];
    _demandArray = [[NSMutableArray alloc] init];
    
    _typeSeg = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"关注的车位",@"关注的需求", nil]];
    _typeSeg.selectedSegmentIndex = 0;
    //添加时间响应
    [_typeSeg addTarget:self action:@selector(changeType) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _typeSeg;
    
    //上拉加载
    [self setupFooter];
    
    //构造虚拟数据,默认加载车位信息
    for (int i =1; i<5; i++) {
        JWParkingInfo * info = [[JWParkingInfo alloc] initWithDic:@{@"carportId":@"1",@"portrait":@"",@"username":@"wanjway",@"publishTime":@"1452598829",@"carportImages":@[@"h1.jpg",@"h2.jpg"],@"leaseType":@"出售",@"carportPrice":@"12元/月",@"carportType":@"地上车位",@"commentNum":@"123",@"praiseNum":@"2324",@"attentionNum":@"222",@"illustration":@"电影《天下无贼》里，“黎叔”领着盗窃团伙乘火车走一路偷一路，在现实生活中，一个由女版“黎叔”带队的聋哑人盗窃团伙，则升级为坐飞机到全国各地行窃。而电影中威逼利诱他人参与团伙、残忍的处罚所谓“不听话”成员等行为，在该团伙中都能找到",@"leaseBeginTime":@"2015年12月23日",@"leaseEndTime":@"2015年12月26日",@"address":@"华中科技大学",@"detailAddress":@"湖北省武汉市洪山区"} WithInfoType:1];
        JWParkingInfoFrame * frame = [[JWParkingInfoFrame alloc] initWithFrameType:1];
        frame.parkingInfo = info;
        
        [_carportArray addObject:frame];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//上拉加载
- (void)setupFooter{
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshView];
    [refreshFooter addToScrollView:self.attentionList];
    [refreshFooter addTarget:self refreshAction:@selector(footerRefresh)];
    _refreshFooter = refreshFooter;
}

//再次向服务器请求数据，并重新加载
-(void)footerRefresh{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (_typeSeg.selectedSegmentIndex == 0) {
            //再次请求关注车位信息
            //请求车位数据
            for (int i =1; i<5; i++) {
                JWParkingInfo * info = [[JWParkingInfo alloc] initWithDic:@{@"carportId":@"1",@"portrait":@"",@"username":@"wanjway",@"publishTime":@"1452598829",@"carportImages":@[@"h1.jpg",@"h2.jpg"],@"leaseType":@"出售",@"carportPrice":@"12元/月",@"carportType":@"地上车位",@"commentNum":@"123",@"praiseNum":@"2324",@"attentionNum":@"432",@"illustration":@"电影《天下无贼》里，“黎叔”领着盗窃团伙乘火车走一路偷一路，在现实生活中，一个由女版“黎叔”带队的聋哑人盗窃团伙，则升级为坐飞机到全国各地行窃。而电影中威逼利诱他人参与团伙、残忍的处罚所谓“不听话”成员等行为，在该团伙中都能找到",@"leaseBeginTime":@"2015年12月23日",@"leaseEndTime":@"2015年12月26日",@"address":@"华中科技大学",@"detailAddress":@"湖北省武汉市洪山区"} WithInfoType:1];
                JWParkingInfoFrame * frame = [[JWParkingInfoFrame alloc] initWithFrameType:1];
                frame.parkingInfo = info;
                [_carportArray addObject:frame];
            }
        }else{
            //再次请求关注需求信息
        }
        
        [_refreshFooter endRefreshing];
        
    });
    [self.attentionList reloadData];
}


//切换
-(void)changeType{
    if (_typeSeg.selectedSegmentIndex == 0) {
        if (_carportArray.count == 0) {
            //请求车位数据
            for (int i =1; i<5; i++) {
                JWParkingInfo * info = [[JWParkingInfo alloc] initWithDic:@{@"carportId":@"1",@"portrait":@"",@"username":@"wanjway",@"publishTime":@"1452598829",@"carportImages":@[@"h1.jpg",@"h2.jpg"],@"leaseType":@"出售",@"carportPrice":@"12元/月",@"carportType":@"地上车位",@"commentNum":@"123",@"praiseNum":@"2324",@"attentionNum":@"343",@"illustration":@"电影《天下无贼》里，“黎叔”领着盗窃团伙乘火车走一路偷一路，在现实生活中，一个由女版“黎叔”带队的聋哑人盗窃团伙，则升级为坐飞机到全国各地行窃。而电影中威逼利诱他人参与团伙、残忍的处罚所谓“不听话”成员等行为，在该团伙中都能找到",@"leaseBeginTime":@"2015年12月23日",@"leaseEndTime":@"2015年12月26日",@"address":@"华中科技大学",@"detailAddress":@"湖北省武汉市洪山区"} WithInfoType:1];
                JWParkingInfoFrame * frame = [[JWParkingInfoFrame alloc] initWithFrameType:1];
                frame.parkingInfo = info;
                
                [_carportArray addObject:frame];
            }
        }
        //重新加载表视图
        [self.attentionList reloadData];
        
    }else{
        if (_demandArray.count == 0) {
            //请求需求数据
            //构造数据
            for (int i =1; i<5; i++) {
                JWParkingInfo * info = [[JWParkingInfo alloc] initWithDic:@{@"demandId":@"1",@"portrait":@"",@"username":@"wanjway",@"publishTime":@"1452598829",@"leaseType":@"出租",@"carportPrice":@"12元/月",@"carportType":@"地上车位",@"commentNum":@"123",@"praiseNum":@"2324",@"attentionNum":@"434",@"illustration":@"电影《天下无贼》里，“黎叔”领着盗窃团伙乘火车走一路偷一路，在现实生活中，一个由女版“黎叔”带队的聋哑人盗窃团伙，则升级为坐飞机到全国各地行窃。而电影中威逼利诱他人参与团伙、残忍的处罚所谓“不听话”成员等行为，在该团伙中都能找到",@"leaseBeginTime":@"2015年12月23日",@"leaseEndTime":@"2015年12月26日",@"address":@"华中科技大学",@"detailAddress":@"湖北省武汉市洪山区"} WithInfoType:2];
                JWParkingInfoFrame * frame = [[JWParkingInfoFrame alloc] initWithFrameType:2];
                frame.parkingInfo = info;
                [_demandArray addObject:frame];
            }
            //重新加载表示图
            [self.attentionList reloadData];
        }
    }
}
    
#pragma UITableViewDelegate/DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (tableView.dataSource>0) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self hideOtherSeparateLines:tableView];
    }else{
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    if (_typeSeg.selectedSegmentIndex == 0) {
        return _carportArray.count;
    }else{
        return _demandArray.count;
    }
    
}

-(void)hideOtherSeparateLines:(UITableView *)tableView{
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JWParkingInfoCustomCell * cell;
    if (_typeSeg.selectedSegmentIndex == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"carportCell"];
        if (cell == nil) {
            cell = [[JWParkingInfoCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"carportCell" AndCellType:1];
        }
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"demandCell"];
        if (cell == nil) {
            cell = [[JWParkingInfoCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"demandCell" AndCellType:2];
        }
    }
    
    if (_typeSeg.selectedSegmentIndex == 0) {
        cell.parkingInfoFrame = [_carportArray objectAtIndex:indexPath.section];
    }else{
        cell.parkingInfoFrame = [_demandArray objectAtIndex:indexPath.section];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_typeSeg.selectedSegmentIndex == 0) {
        return [[_carportArray objectAtIndex:indexPath.section] cellHeight];
    }else{
        return [[_demandArray objectAtIndex:indexPath.section] cellHeight];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_typeSeg.selectedSegmentIndex == 1) {
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"请选择操作" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"取消关注" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //
        }];
        
        UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"查看详情" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //跳转到车位详情
            JWParkingDetailInfoViewController * detailView = [[JWParkingDetailInfoViewController alloc] init];
            detailView.hidesBottomBarWhenPushed = YES;
            detailView.infoType = 1;
            detailView.parkingInfo = [[_demandArray objectAtIndex:indexPath.section] parkingInfo];
            [self.navigationController pushViewController:detailView animated:YES];
        }];
        
        UIAlertAction * action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action1];
        [alert addAction:action2];
        [alert addAction:action3];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"请选择操作" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"取消关注" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //
        }];
        
        UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"查看详情" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //跳转到需求详情
            JWParkingDetailInfoViewController * detailView = [[JWParkingDetailInfoViewController alloc] init];
            detailView.hidesBottomBarWhenPushed = YES;
            detailView.infoType = 0;
            detailView.parkingInfo = [[_carportArray objectAtIndex:indexPath.section] parkingInfo];
            [self.navigationController pushViewController:detailView animated:YES];
        }];
        UIAlertAction * action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action1];
        [alert addAction:action2];
        [alert addAction:action3];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end
