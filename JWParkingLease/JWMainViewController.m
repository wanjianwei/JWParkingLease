//
//  JWMainViewController.m
//  JWParkingLease
//
//  Created by jway on 16/1/4.
//  Copyright © 2016年 jway. All rights reserved.
//

#import "JWMainViewController.h"
#import "IIViewDeckController.h"

//点聚合地图
#import "CCHMapClusterAnnotation.h"
#import "CCHMapClusterController.h"
#import "CCHMapClusterControllerDelegate.h"
#import "CCHCenterOfMassMapClusterer.h"
#import "CCHNearCenterMapClusterer.h"
#import "CCHFadeInOutMapAnimator.h"
#import "ClusterAnnotationView.h"

#import "JWPublishInfoViewController.h"

#import "JWParkingInfoListTableView.h"
#import "JWDemandInfoViewController.h"
#import "JWParkingOrDemandListViewController.h"

#import "AppDelegate.h"


@interface JWMainViewController ()<CCHMapClusterControllerDelegate,MKMapViewDelegate,UISearchBarDelegate>{
    //定义一个CGPoint,用来记录点击屏幕的位置
    CGPoint  touchPoint;
    //应用程序委托类
    AppDelegate * app;
    
}
//定义一个分段控制器
@property(nonatomic,strong)UISegmentedControl * roleChange;

//点聚合控制器
@property (nonatomic) CCHMapClusterController *mapClusterController;
//自定义锚点
@property (nonatomic) id<CCHMapClusterer> mapClusterer;

//车位信息
@property(nonatomic,strong)NSMutableArray * parkingAnnotationArrray;

//需求信息
@property(nonatomic,strong)NSMutableArray * demandAnnotationArray;

//定义一个搜索栏
//@property(nonatomic,strong)UISearchBar * searchBar;


@end

@implementation JWMainViewController

-(id)initWithroleType:(int)roleType{
   self = [super init];
    if (self) {
        self.roleType = roleType;
        // 初始化
        if (self.roleType == 1) {
            _roleChange = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"受租方",@"出租方", nil]];
            self.tabBarItem.title = @"出租";
            self.tabBarItem.image = [UIImage imageNamed:@"change.png"];
            
        }else if (self.roleType == 2){
            _roleChange = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"买方",@"卖方", nil]];
            self.tabBarItem.title = @"出让";
            self.tabBarItem.image = [UIImage imageNamed:@"change.png"];
        }else{
            _roleChange = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"分享人",@"接受人", nil]];
            self.tabBarItem.title = @"共享";
            self.tabBarItem.image = [UIImage imageNamed:@"change.png"];
        }
        
        _roleChange.selectedSegmentIndex = 0;
        //添加事件响应
        [_roleChange addTarget:self action:@selector(changeRole) forControlEvents:UIControlEventValueChanged];
        //初始化可变数组
        _parkingAnnotationArrray = [[NSMutableArray alloc] init];
        _demandAnnotationArray = [[NSMutableArray alloc] init];
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    self.navigationItem.titleView = _roleChange;
    
    /*
    //添加搜索栏
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 40)];
    _searchBar.placeholder = @"请输入小区或商场名称";
    _searchBar.delegate = self;
    [self.view addSubview:_searchBar];
    */
    
    //设置点聚合地图
    [self p_initMapAndCluster];
    
    //初始化应用程序委托类
    app = [UIApplication sharedApplication].delegate;
    
    //如果已经定位成功，则直接去请求数据
    if (app.latitude && app.longitude) {
        [self locationSuccess];
    }
    
    //监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationSuccess) name:@"locationSuccessNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationFail:) name:@"locationFailNotification" object:nil];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//初始化点聚合控制器
-(void)p_initMapAndCluster{
    
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    _mapClusterController = [[CCHMapClusterController alloc] initWithMapView:self.mapView];
    _mapClusterController.delegate = self;
    _mapClusterController.maxZoomLevelForClustering = 16;
    _mapClusterController.minUniqueLocationsForClustering = 2;
    _mapClusterer = [[CCHCenterOfMassMapClusterer alloc] init];
    _mapClusterController.clusterer = _mapClusterer;
}


//定位成功——判断是否请求数据
-(void)locationSuccess{
    //调整地图显示区域
    CLLocationCoordinate2D center = {app.latitude,app.longitude};
    MKCoordinateSpan span = {0.1,0.1};
    MKCoordinateRegion region = {center,span};
    [self.mapView setRegion:region animated:YES];
    
    
    if (_roleChange.selectedSegmentIndex == 0) {
        
        //如果地图上已经有锚点显示，则删除
        [_mapClusterController removeAnnotations:_parkingAnnotationArrray withCompletionHandler:nil];
        
        //重新初始化可变数组
        _parkingAnnotationArrray = [[NSMutableArray alloc] init];
        
        //向服务器请求数据
        for (NSInteger i = 0; i < 100; i++) {
            double lat =  (arc4random() % 100) * 0.001f;
            double lon =  (arc4random() % 100) * 0.001f;
            CLLocationCoordinate2D  annotationcoor = CLLocationCoordinate2DMake(app.latitude + lat, app.longitude + lon);
            MKPointAnnotation * annotation = [[MKPointAnnotation alloc] init];
            annotation.coordinate = annotationcoor;
            annotation.title = @"wjw";
            [_parkingAnnotationArrray addObject:annotation];
        }
        //添加新的annotation
        [_mapClusterController addAnnotations:_parkingAnnotationArrray withCompletionHandler:nil];
        
        
    }else{
        //如果地图上已经有锚点显示，则删除
        [_mapClusterController removeAnnotations:_demandAnnotationArray withCompletionHandler:nil];
        
        //重新初始化可变数组
        _demandAnnotationArray = [[NSMutableArray alloc] init];
        //请求数据
        for (NSInteger i = 0; i < 100; i++) {
            double lat =  (arc4random() % 100) * 0.001f;
            double lon =  (arc4random() % 100) * 0.001f;
            CLLocationCoordinate2D  annotationcoor = CLLocationCoordinate2DMake(app.latitude + lat, app.longitude + lon);
            MKPointAnnotation * annotation = [[MKPointAnnotation alloc] init];
            annotation.coordinate = annotationcoor;
            annotation.title = @"wjw";
            [_demandAnnotationArray addObject:annotation];
        }
        //添加新的annotation
        [_mapClusterController addAnnotations:_demandAnnotationArray withCompletionHandler:nil];
        
    }
}

//定位失败
-(void)locationFail:(NSNotification *)noti{
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:[noti.userInfo objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}



/**
 构造请求参数
 **/

-(NSDictionary *)makeRequestInfo{
    
    NSDictionary * dic;
    if (self.roleType == 1) {
        //出租模式
        if (_roleChange.selectedSegmentIndex == 0) {
            //出租方
            dic = @{@"city":[[NSUserDefaults standardUserDefaults] objectForKey:@"city"],@"leaseType":@"出租",@"demandType":@"0"};
            
        }else{
            //受租方
            dic = @{@"city":[[NSUserDefaults standardUserDefaults] objectForKey:@"city"],@"leaseType":@"出租",@"demandType":@"1"};
        }
        
    }else if (self.roleType == 2){
        //出让模式
        if (_roleChange.selectedSegmentIndex == 0) {
            //买方
            dic = @{@"city":[[NSUserDefaults standardUserDefaults] objectForKey:@"city"],@"leaseType":@"出让",@"demandType":@"0"};
        }else{
            //卖方
            dic = @{@"city":[[NSUserDefaults standardUserDefaults] objectForKey:@"city"],@"leaseType":@"出让",@"demandType":@"1"};
        }
        
    }else{
        //共享模式
        if (_roleChange.selectedSegmentIndex == 0) {
            //分享人
            dic = @{@"city":[[NSUserDefaults standardUserDefaults] objectForKey:@"city"],@"leaseType":@"共享",@"demandType":@"0"};
        }else{
            //接受人
            dic = @{@"city":[[NSUserDefaults standardUserDefaults] objectForKey:@"city"],@"leaseType":@"共享",@"demandType":@"1"};
        }
        
    }
    return dic;
}

//切换角色
-(void)changeRole{
    
    //先把地图上的锚点全部删除
    if (_roleChange.selectedSegmentIndex == 0) {
        
        
        
        if (_parkingAnnotationArrray.count == 0) {
            //请求服务器
        }
    }else{
        
        if (_demandAnnotationArray.count == 0) {
            //先构造请求数据
            //   NSDictionary * dic = [self makeRequestInfo];
            //请求服务器
        }
    }
    
    
    
}


//复写父类的方法
//打开左侧抽屉导航栏
-(void)openDeckerView{
    //该指针只是传递到了centerViewController
    if ([self.tabBarController.viewDeckController isSideOpen:IIViewDeckLeftSide]) {
        //如果左侧按钮已经打开，则关闭
        [self.tabBarController.viewDeckController closeLeftViewAnimated:YES];
    }else{
        [self.tabBarController.viewDeckController openLeftViewAnimated:YES];
    }

}

//父类方法 ——转为用列表显示结果
-(void)changeToListTable{
    NSDictionary * dic = [self makeRequestInfo];
    //判断是跳转到车位列表还是需求列表
    if ([[dic objectForKey:@"demandType"] isEqualToString:@"0"]) {
        //跳转到车位列表
        //再次向服务器请求,传递请求参数
        JWParkingInfoListTableView * listView=  [[JWParkingInfoListTableView alloc] init];
        listView.getDic = dic;
        listView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:listView animated:YES];
    }else{
        //跳转到需求列表
        JWDemandInfoViewController * listView = [[JWDemandInfoViewController alloc] init];
        listView.getDic = dic;
        listView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:listView animated:YES];
    }

}

//跳转到发布界面
-(void)gotoPublishView{
    
    JWPublishInfoViewController * publishInfoView = [[JWPublishInfoViewController alloc] init];
    publishInfoView.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:publishInfoView animated:YES];
    
}

//重新定位
-(void)location_again{
    [app.locationManager startUpdatingLocation];
}

//跳转到搜索界面
-(void)gotoSearchView{
    //跳转到搜索界面
    JWChoseVillageViewController * choseView = [[JWChoseVillageViewController alloc] init];
    choseView.hidesBottomBarWhenPushed = YES;
    choseView.delegate = self;
    [self.navigationController pushViewController:choseView animated:YES];
}

#pragma mapClusterControllerDelegate
- (NSString *)mapClusterController:(CCHMapClusterController *)mapClusterController titleForMapClusterAnnotation:(CCHMapClusterAnnotation *)mapClusterAnnotation{
    NSUInteger numAnnotations = mapClusterAnnotation.annotations.count;
    NSString *unit = @"个车位";
    return [NSString stringWithFormat:@"%tu %@", numAnnotations, unit];
}

- (NSString *)mapClusterController:(CCHMapClusterController *)mapClusterController subtitleForMapClusterAnnotation:(CCHMapClusterAnnotation *)mapClusterAnnotation{
    NSArray *annotations = mapClusterAnnotation.annotations.allObjects;
    NSArray *titles = [annotations valueForKey:@"title"];
    return [titles componentsJoinedByString:@"#"];
}

- (void)mapClusterController:(CCHMapClusterController *)mapClusterController willReuseMapClusterAnnotation:(CCHMapClusterAnnotation *)mapClusterAnnotation{
    ClusterAnnotationView *clusterAnnotationView = (ClusterAnnotationView *)[self.mapView viewForAnnotation:mapClusterAnnotation];
    clusterAnnotationView.count = mapClusterAnnotation.annotations.count;
    clusterAnnotationView.uniqueLocation = mapClusterAnnotation.isUniqueLocation;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    MKAnnotationView *annotationView;
    if ([annotation isKindOfClass:CCHMapClusterAnnotation.class]) {
        static NSString *identifier = @"clusterAnnotation";
        ClusterAnnotationView *clusterAnnotationView = (ClusterAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (clusterAnnotationView) {
            clusterAnnotationView.annotation = annotation;
        } else {
            clusterAnnotationView = [[ClusterAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            clusterAnnotationView.canShowCallout = NO;
        }
        
        CCHMapClusterAnnotation *clusterAnnotation = (CCHMapClusterAnnotation *)annotation;
        clusterAnnotationView.count = clusterAnnotation.annotations.count;
        clusterAnnotationView.uniqueLocation = clusterAnnotation.isUniqueLocation;
        annotationView = clusterAnnotationView;
    }
    return annotationView;
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    
    
    if ([view.annotation.title intValue]>10) {
        //继续分开
        MKCoordinateSpan span = {mapView.region.span.latitudeDelta*0.5,mapView.region.span.longitudeDelta*0.5};
        MKCoordinateRegion region = {view.annotation.coordinate,span};
        [self.mapView setRegion:region animated:YES];
    }else{
        
        //先请求数据，成功后在移动
        ClusterAnnotationView * annoView = (ClusterAnnotationView *)view;
        annoView.countLabel.backgroundColor = [UIColor grayColor];
        /*
        if (touchPoint.y>[UIScreen mainScreen].bounds.size.height/3) {
            //mapView上移动,
            [UIView animateWithDuration:0.5 animations:^{
                CGRect frame = self.mapView.frame;
                frame.origin.y = [UIScreen mainScreen].bounds.size.height/3-touchPoint.y;
                self.mapView.frame = frame;
                //同时,底部弹出表视图
                
            }];
        }
         */
        JWParkingOrDemandListViewController * parkingOrDemandView = [[JWParkingOrDemandListViewController alloc] init];
        if (_roleChange.selectedSegmentIndex == 0) {
            parkingOrDemandView.infoId = annoView.annotation.subtitle;
            parkingOrDemandView.typeInfo = @"0";
           // parkingOrDemandView.typeInfo = [NSString stringWithFormat:@"0"];
        }else{
            //跳转到需求列表
            parkingOrDemandView.typeInfo = @"1";
           // parkingOrDemandView.typeInfo = [NSString stringWithFormat:@"1"];
            parkingOrDemandView.infoId = annoView.annotation.subtitle;
        }
        parkingOrDemandView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:parkingOrDemandView animated:YES];
    }
    
}


#pragma UISearchBarDelegate
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    //跳转到搜索界面
    JWChoseVillageViewController * choseView = [[JWChoseVillageViewController alloc] init];
    choseView.hidesBottomBarWhenPushed = YES;
    choseView.delegate = self;
    [self.navigationController pushViewController:choseView animated:YES];
    return NO;
}


/////////////////////////////////////
#pragma getParkingAddressDelegate
-(void)locateToAddress:(NSString *)address WithLat:(float)Lat AndLon:(float)lon{
    //将位置定位到所在地点
    MKCoordinateSpan span = {0.1,0.1};
    CLLocationCoordinate2D center = {Lat,lon};
    MKCoordinateRegion region = {center,span};
    [self.mapView setRegion:region animated:YES];
    
    //更新searchbar的值
  //  _searchBar.text = address;
}


#pragma UIRsponder
//点击屏幕，获取屏幕位置
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch * touch = [touches anyObject];
    touchPoint = [touch locationInView:self.view];
    DLog(@"x= %f,y=%f",touchPoint.x,touchPoint.y);
}

@end
