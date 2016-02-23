//
//  JWParkingInfoListTableView.m
//  JWParkingLease
//
//  Created by jway on 16/1/12.
//  Copyright © 2016年 jway. All rights reserved.
//

#import "JWParkingInfoListTableView.h"
#import "JWParkingInfoCustomCell.h"
#import "JWParkingDetailInfoViewController.h"
#import "AppDelegate.h"

//下拉刷新和上拉加载
#import "SDRefresh.h"

//下拉选择按钮
#import "JSDropDownMenu.h"

@interface JWParkingInfoListTableView ()<UITableViewDataSource,UITableViewDelegate,JSDropDownMenuDataSource,JSDropDownMenuDelegate>{
    //定义应用程序委托
    AppDelegate * app;
    //出租类型
    NSArray * leaseType;
    //车位类型
    NSArray * carportType;
    //当前默认选中
    NSInteger _currentData1Index;
    NSInteger _currentData2Index;
}

@property(nonatomic,strong)UITableView * listTable;
//上拉加载
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;

//定义一个可变数组，用来存储数据
@property(nonatomic,strong) NSMutableArray * infoArray;

//定义一个下拉选择按钮
@property(nonatomic,strong) JSDropDownMenu * choseMenu;

@end

@implementation JWParkingInfoListTableView

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化
    if ([[_getDic objectForKey:@"roleType"] isEqualToString:@"1"]) {
        self.title = @"车位列表-出租";
    }else if ([[_getDic objectForKey:@"roleType"] isEqualToString:@"2"]){
        self.title = @"车位列表-出让";
    }else{
        self.title = @"车位列表-共享";
    }
    _infoArray = [[NSMutableArray alloc] init];
    
    self.listTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    self.listTable.dataSource = self;
    self.listTable.delegate = self;
    [self.view addSubview:_listTable];
    self.listTable.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    
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
    
    //初始化
    app = [UIApplication sharedApplication].delegate;
    //上拉加载
    [self setupFooter];
    
    //构造数据
    for (int i =1; i<5; i++) {
        JWParkingInfo * info = [[JWParkingInfo alloc] initWithDic:@{@"carportId":@"1",@"portrait":@"",@"username":@"wanjway",@"publishTime":@"1452598829",@"carportImages":@[@"h1.jpg",@"h2.jpg"],@"leaseType":@"出售",@"carportPrice":@"12元/月",@"carportType":@"地上车位",@"commentNum":@"123",@"praiseNum":@"2324",@"attentionNum":@"212",@"illustration":@"电影《天下无贼》里，“黎叔”领着盗窃团伙乘火车走一路偷一路，在现实生活中，一个由女版“黎叔”带队的聋哑人盗窃团伙，则升级为坐飞机到全国各地行窃。而电影中威逼利诱他人参与团伙、残忍的处罚所谓“不听话”成员等行为，在该团伙中都能找到",@"leaseBeginTime":@"2015年12月23日",@"leaseEndTime":@"2015年12月26日",@"address":@"华中科技大学",@"detailAddress":@"湖北省武汉市洪山区"} WithInfoType:1];
        JWParkingInfoFrame * frame = [[JWParkingInfoFrame alloc] initWithFrameType:1];
        frame.parkingInfo = info;
        [_infoArray addObject:frame];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//上拉加载
- (void)setupFooter{
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshView];
    [refreshFooter addToScrollView:self.listTable];
    [refreshFooter addTarget:self refreshAction:@selector(footerRefresh)];
    _refreshFooter = refreshFooter;
}

//再次向服务器请求数据，并重新加载
-(void)footerRefresh{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (int i =1; i<5; i++) {
            JWParkingInfo * info = [[JWParkingInfo alloc] initWithDic:@{@"carportId":@"1",@"portrait":@"122",@"username":@"wanjway",@"publishTime":@"1452598829",@"carportImages":@[@"123.png",@"2323.png"],@"leaseType":@"出租",@"carportPrice":@"12元/月",@"carportType":@"地上车位",@"commentNum":@"123",@"praiseNum":@"2324",@"attentionNum":@"111",@"illustration":@"电影《天下无贼》里，“黎叔”领着盗窃团伙乘火车走一路偷一路，在现实生活中，一个由女版“黎叔”带队的聋哑人盗窃团伙，则升级为坐飞机到全国各地行窃。而电影中威逼利诱他人参与团伙、残忍的处罚所谓“不听话”成员等行为，在该团伙中都能找到",@"leaseBeginTime":@"2015年12月23日",@"leaseEndTime":@"2015年12月26日",@"address":@"华中科技大学",@"detailAddress":@"湖北省武汉市洪山区"} WithInfoType:1];
            JWParkingInfoFrame * frame = [[JWParkingInfoFrame alloc] initWithFrameType:1];
            frame.parkingInfo = info;
            [_infoArray addObject:frame];
        }
        [_refreshFooter endRefreshing];
    });
    [self.listTable reloadData];
}

#pragma UITableViewDelegate/dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _infoArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JWParkingInfoCustomCell * cell = [tableView dequeueReusableCellWithIdentifier:@"parkingInfoCell"];
    if (cell == nil) {
        cell = [[JWParkingInfoCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"parkingInfoCell" AndCellType:1];
    }
    
    cell.parkingInfoFrame = [_infoArray objectAtIndex:indexPath.section];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [[_infoArray objectAtIndex:indexPath.section] cellHeight];
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
    detailInfo.parkingInfo = ((JWParkingInfoFrame*)[_infoArray objectAtIndex:indexPath.section]).parkingInfo;
    
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
