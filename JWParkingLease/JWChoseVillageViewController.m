//
//  JWChoseVillageViewController.m
//  JWParkingLease
//
//  Created by jway on 15/12/17.
//  Copyright © 2015年 jway. All rights reserved.
//

#import "JWChoseVillageViewController.h"
//关键字搜索
#import <AMapSearchKit/AMapSearchKit.h>
@interface JWChoseVillageViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating,AMapSearchDelegate,UISearchControllerDelegate>

@property(nonatomic,strong)UISearchController * searchController;
//存储搜索结果
@property(nonatomic,strong)NSArray * resultArray;
//搜索api
@property (nonatomic,strong) AMapSearchAPI * searchAPI;

//结果显示表示图
@property(nonatomic,strong)UITableView * resultView;


@end

@implementation JWChoseVillageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    self.resultView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    _resultView.delegate = self;
    _resultView.dataSource = self;
    _resultView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_resultView];
    
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.searchResultsUpdater = self;
    _searchController.hidesNavigationBarDuringPresentation = NO;
     _searchController.dimsBackgroundDuringPresentation = false;
    _searchController.searchBar.placeholder = @"请输入小区/商场名称";
   // _searchController.delegate = self;
    //设置titleView
    self.navigationItem.titleView = _searchController.searchBar;
    //初始化搜索api
    //配置用户key
    [AMapSearchServices sharedServices].apiKey = @"aacb1abaafafb7bfce85a21f800bf837";
    //初始化检索对象
    _searchAPI = [[AMapSearchAPI alloc] init];
    _searchAPI.delegate = self;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
   // _searchController.active = YES;
   // [_searchController.searchBar becomeFirstResponder];
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    _searchController.active = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (tableView.dataSource>0) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self p_hideExtraTableCellSeparatorLine:tableView];
    }else{
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    
    if (_searchController.active) {
        return 1;
    }else{
        return 0;
    }
    
}

//隐藏多余的单元格分割线
-(void)p_hideExtraTableCellSeparatorLine:(UITableView*)tableView{
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_searchController.active) {
        return _resultArray.count;
    }else{
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifier = @"resultCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.imageView.image = [UIImage imageNamed:@"search_pin.png"];
    cell.textLabel.text = [[_resultArray objectAtIndex:indexPath.row] name];
    cell.detailTextLabel.text  = [[_resultArray objectAtIndex:indexPath.row] district];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    _searchController.active = NO;
    [self.navigationController popViewControllerAnimated:YES];
    if (_isGettingAddress) {
        //获取经纬度
        AMapGeoPoint * point = [(AMapTip *)[_resultArray objectAtIndex:indexPath.row] location];
        //是获取位置
        NSDictionary * adddressDic = @{@"detailAddress":[[_resultArray objectAtIndex:indexPath.row] name],@"address":[[_resultArray objectAtIndex:indexPath.row] district],@"latitude":[NSString stringWithFormat:@"%f",point.latitude],@"longitude":[NSString stringWithFormat:@"%f",point.longitude]};
        [self.delegate getCarportAddress:adddressDic];
    }else{
        //调用协议方法
        AMapGeoPoint * point = [(AMapTip *)[_resultArray objectAtIndex:indexPath.row] location];
        //协议委托
        [self.delegate locateToAddress:[[_resultArray objectAtIndex:indexPath.row] name] WithLat:point.latitude AndLon:point.longitude];
    }
    
}


#pragma UISearchResultsUpdating
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    //构造AMapInputTipsSearchRequest对象，设置请求参数
    AMapInputTipsSearchRequest *tipsRequest = [[AMapInputTipsSearchRequest alloc] init];
    tipsRequest.keywords = searchController.searchBar.text;
    tipsRequest.city = [[NSUserDefaults standardUserDefaults] objectForKey:@"city"];
    //发起输入提示搜索
    [_searchAPI AMapInputTipsSearch:tipsRequest];
    
}


#pragma AmapSearchDelegate
-(void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response{
    //将数据传入数组，并重载表视图
    _resultArray = [NSArray arrayWithArray:response.tips];
    [_resultView reloadData];
}

/*
#pragma UISearchControllerDelegate
-(void)didPresentSearchController:(UISearchController *)searchController{
    [self.view addSubview:_resultView];
    //self.navigationItem.backBarButtonItem = nil;
}

-(void)didDismissSearchController:(UISearchController *)searchController{
    [_resultView removeFromSuperview];
    
}
 */
@end
