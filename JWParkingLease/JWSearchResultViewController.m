//
//  JWSearchResultViewController.m
//  JWParkingLease
//
//  Created by jway on 15/12/12.
//  Copyright © 2015年 jway. All rights reserved.
//

#import "JWSearchResultViewController.h"
#import "UIViewController+MMDrawerController.h"

@interface JWSearchResultViewController ()<UISearchResultsUpdating>

//定义一个搜索控制器
@property(nonatomic,strong)UISearchController * searchController;
//定义一个属性用来接收搜索结果
@property(nonatomic,strong)NSArray * resultArray;

@end

@implementation JWSearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.searchResultsUpdater = self;
    _searchController.dimsBackgroundDuringPresentation = false;
    _searchController.hidesNavigationBarDuringPresentation = false;
    _searchController.searchBar.placeholder = @"请输入小区名称/地址";
    _searchController.searchBar.text = @"";
    
    //设置titleView
    self.navigationItem.titleView = _searchController.searchBar;
    
    [self.searchController.searchBar becomeFirstResponder];
    
}


-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:YES];
    //一定要注意，viewController退出时，一定要把searchController全部dealloc，否则会警告
    self.searchController = nil;
    self.resultArray = nil;
    self.navigationItem.titleView = nil;
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
    
    return 1;
}

//隐藏多余的单元格分割线
-(void)p_hideExtraTableCellSeparatorLine:(UITableView*)tableView{
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _resultArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"resultCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"resultCell"];
    }
    cell.textLabel.text = [[_resultArray objectAtIndex:indexPath.row] objectForKey:@"placeName"];
    
    // Configure the cell...
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //返回
    DLog(@"fanhui");
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma UISearchResultsUpdating
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    _resultArray = @[@{@"placeName":@"南昌"},@{@"placeName":@"武汉"},@{@"placeName":@"北京"}];
   
    [self.tableView reloadData];
}

@end
