//
//  JWDemandInfoViewController.m
//  JWParkingLease
//
//  Created by jway on 16/1/19.
//  Copyright © 2016年 jway. All rights reserved.
//

#import "JWDemandInfoViewController.h"
#import "JWParkingInfoCustomCell.h"
#import "AppDelegate.h"
//下拉刷新和上拉加载
//该界面无需使用上拉加载，数据量不会很多，也方便进行排序

#import "SDRefresh.h"
#import "JSDropDownMenu.h"
#import "JWParkingDetailInfoViewController.h"


@interface JWDemandInfoViewController ()<UITableViewDataSource,UITableViewDelegate,JSDropDownMenuDataSource,JSDropDownMenuDelegate>{
    //应用程序委托协议
    AppDelegate * app;
    //出租类型
    NSArray * leaseType;
    //车位类型
    NSArray * carportType;
    //当前默认选中
    NSInteger _currentData1Index;
    NSInteger _currentData2Index;
}

@property(nonatomic,strong) UITableView * demandList;
//可变数组，用于存储数据结果
@property(nonatomic,strong) NSMutableArray * demandArray;
//上拉加载
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;

//定义一个下拉选择按钮
@property(nonatomic,strong) JSDropDownMenu * choseMenu;

@end

@implementation JWDemandInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    if ([[_getDic objectForKey:@"roleType"] isEqualToString:@"1"]) {
        self.title = @"需求列表-出租";
    }else if ([[_getDic objectForKey:@"roleType"] isEqualToString:@"2"]){
        self.title = @"需求列表-出让";
    }else{
        self.title = @"需求列表-共享";
    }
    self.demandList = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.demandList.dataSource = self;
    self.demandList.delegate = self;
    self.demandList.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_demandList];
    
    //初始化变量
    app = [UIApplication sharedApplication].delegate;
    _demandArray = [[NSMutableArray alloc] init];
    //上拉加载
    [self setupFooter];
    
    _choseMenu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:45];
    _choseMenu.indicatorColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1.0];
    _choseMenu.separatorColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0];
    _choseMenu.textColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
    _choseMenu.dataSource = self;
    _choseMenu.delegate = self;
    [self.view addSubview:_choseMenu];
    
    leaseType = [NSArray arrayWithObjects:@"智能排序",@"按评论数",@"按点赞数",@"按关注数", nil];
    carportType = [NSArray arrayWithObjects:@"不限车位类型",@"地上车位",@"地下车位", nil];
    _currentData1Index = 0;
    _currentData2Index = 0;
    
    
    //构造数据
    for (int i =1; i<5; i++) {
        JWParkingInfo * info = [[JWParkingInfo alloc] initWithDic:@{@"demandId":@"1",@"portrait":@"",@"username":@"wanjway",@"publishTime":@"1452598829",@"leaseType":@"出租",@"carportPrice":@"12元/月",@"carportType":@"地上车位",@"commentNum":@"123",@"praiseNum":@"2324",@"illustration":@"电影《天下无贼》里，“黎叔”领着盗窃团伙乘火车走一路偷一路，在现实生活中，一个由女版“黎叔”带队的聋哑人盗窃团伙，则升级为坐飞机到全国各地行窃。而电影中威逼利诱他人参与团伙、残忍的处罚所谓“不听话”成员等行为，在该团伙中都能找到",@"leaseBeginTime":@"2015年12月23日",@"leaseEndTime":@"2015年12月26日",@"address":@"华中科技大学",@"detailAddress":@"湖北省武汉市洪山区"} WithInfoType:2];
        JWParkingInfoFrame * frame = [[JWParkingInfoFrame alloc] initWithFrameType:2];
        frame.parkingInfo = info;
        [_demandArray addObject:frame];
    }

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//上拉加载
- (void)setupFooter{
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshView];
    [refreshFooter addToScrollView:self.demandList];
    [refreshFooter addTarget:self refreshAction:@selector(footerRefresh)];
    _refreshFooter = refreshFooter;
}

//再次向服务器请求数据，并重新加载
-(void)footerRefresh{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //构造数据
        for (int i =1; i<5; i++) {
            JWParkingInfo * info = [[JWParkingInfo alloc] initWithDic:@{@"demandId":@"1",@"portrait":@"",@"username":@"wanjway",@"publishTime":@"1452598829",@"leaseType":@"出售",@"carportPrice":@"12元/月",@"carportType":@"地上车位",@"commentNum":@"123",@"praiseNum":@"2324",@"illustration":@"电影《天下无贼》里，“黎叔”领着盗窃团伙乘火车走一路偷一路，在现实生活中，一个由女版“黎叔”带队的聋哑人盗窃团伙，则升级为坐飞机到全国各地行窃。而电影中威逼利诱他人参与团伙、残忍的处罚所谓“不听话”成员等行为，在该团伙中都能找到",@"leaseBeginTime":@"2015年06月23日",@"leaseEndTime":@"2015年12月26日",@"address":@"华中科技大学",@"detailAddress":@"湖北省武汉市洪山区"} WithInfoType:2];
            JWParkingInfoFrame * frame = [[JWParkingInfoFrame alloc] initWithFrameType:2];
            frame.parkingInfo = info;
            [_demandArray addObject:frame];
        }
        [_refreshFooter endRefreshing];
        
    });
    [self.demandList reloadData];
}

#pragma UITableViewDelegate/dataSource
#pragma UITableViewDelegate/dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _demandArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JWParkingInfoCustomCell * cell = [tableView dequeueReusableCellWithIdentifier:@"parkingInfoCell"];
    if (cell == nil) {
        cell = [[JWParkingInfoCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"parkingInfoCell" AndCellType:2];
    }
    
    cell.parkingInfoFrame = [_demandArray objectAtIndex:indexPath.section];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [[_demandArray objectAtIndex:indexPath.section] cellHeight];
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 45;
    }
    return 15;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

//点击单元格
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JWParkingDetailInfoViewController * detailInfo = [[JWParkingDetailInfoViewController alloc] init];
    detailInfo.parkingInfo = ((JWParkingInfoFrame*)[_demandArray objectAtIndex:indexPath.section]).parkingInfo;
    
    detailInfo.infoType = 1;
    
    detailInfo.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailInfo animated:YES];
}


#pragma JSDropDownMenuDelegate/JSDropDownMenuDataSource
- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu {
    
    return 2;
}

-(BOOL)displayByCollectionViewInColumn:(NSInteger)column{
    
    return NO;
}

-(BOOL)haveRightTableViewInColumn:(NSInteger)column{
    
    return NO;
}


-(NSInteger)currentLeftSelectedRow:(NSInteger)column{
    
    if (column == 0) {
        return _currentData1Index;
    }else{
        return _currentData2Index;
    }
}

-(CGFloat)widthRatioOfLeftColumn:(NSInteger)column{
    
    return 1;
}


- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{
    
    if (column == 0) {
        return 3;
    }else{
        return 4;
    }
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
    
    if (column == 0) {
        return @"不限车位类型";
    }else{
        return @"智能排序";
    }
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column==0) {
        return [carportType objectAtIndex:indexPath.row];
    } else {
        
        return [leaseType objectAtIndex:indexPath.row];
    }
}

- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column == 0) {
        _currentData1Index = indexPath.row;
        
    } else{
        _currentData2Index = indexPath.row;
    }
}


@end
