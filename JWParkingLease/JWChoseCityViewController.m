//
//  JWChoseCityViewController.m
//  JWParkingLease
//
//  Created by jway on 15/12/12.
//  Copyright © 2015年 jway. All rights reserved.
//

#import "JWChoseCityViewController.h"

@interface JWChoseCityViewController ()

@property(nonatomic,strong) NSArray * cityArray;

@end

@implementation JWChoseCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   //导航栏初始化
    self.title = @"选择城市";
    _cityArray = @[@"武汉",@"南昌",@"北京",@"上海",@"广州",@"重庆",@"深圳"];
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
    return _cityArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cityCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cityCell"];
    }
    cell.textLabel.text = [_cityArray objectAtIndex:indexPath.row];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //利用代理将结果返回
    [self.navigationController popViewControllerAnimated:YES];
}

@end
