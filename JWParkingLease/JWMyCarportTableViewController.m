//
//  JWMyCarportTableViewController.m
//  JWParkingLease
//
//  Created by jway on 16/1/20.
//  Copyright © 2016年 jway. All rights reserved.
//

#import "JWMyCarportTableViewController.h"
#import "AppDelegate.h"
#import "CustomButton.h"
#import "JWMyCarportInfoTableViewController.h"
#import "JWCommentViewController.h"
#import "MWPhotoBrowser.h"
@interface JWMyCarportTableViewController ()<MWPhotoBrowserDelegate>{
    AppDelegate * app;
}

//存储服务器请求数据
@property(nonatomic,strong) NSDictionary * carportInfo;

//供图片浏览器使用
@property(nonatomic,strong) NSMutableArray * imageArray;

//是否关闭交易
@property(nonatomic,strong) UISegmentedControl * transactionStateSeg;

//车位使用状态切换
@property(nonatomic,strong) UISegmentedControl * carportStateSeg;


@end

@implementation JWMyCarportTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化
    self.title = @"我的车位";
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    app = [[UIApplication sharedApplication] delegate];
    
    //初始化分段控制器
    self.transactionStateSeg = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"否",@"是", nil]];
    [_transactionStateSeg addTarget:self action:@selector(transactionStateChange) forControlEvents:UIControlEventValueChanged];
    
    self.carportStateSeg = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"否",@"是", nil]];
    [_carportStateSeg addTarget:self action:@selector(carportStateChange) forControlEvents:UIControlEventValueChanged];
    
    //构造虚拟数据
    _carportInfo = @{@"carportId":@"43",@"publishTime":@"2016年12月21日",@"commentNum":@"123",@"praiseNum":@"222",@"attentionNum":@"323",@"requestNum":@"123",@"transactionState":@"NO",@"carportState":@"NO",@"carportImages":@[@"h1.jpg",@"h2.jpg",@"h4.jpg"]};
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//跳转到评论界面
-(void)gotoCommentView{
    JWCommentViewController * commentView = [[JWCommentViewController alloc] init];
    commentView.hidesBottomBarWhenPushed = YES;
    //传递demandId；
    commentView.infoId = [_carportInfo objectForKey:@"carportId"];
    //传递评论类型值
    commentView.commentType = 0;
    [self.navigationController pushViewController:commentView animated:YES];
}

//跳转点赞按钮
-(void)gotoPraiseView{
    
}

//跳转到关注界面
-(void)gotoAttentionView{
    
}

//注销车位
-(void)deleteNow{
    
}

//切换交易状态
-(void)transactionStateChange{
    if (_transactionStateSeg.selectedSegmentIndex == 1) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"执行此操作，无论车位是否已出租，都将关闭车位显示，是否继续执行？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //请求服务器
        }];
        
        UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            self.transactionStateSeg.selectedSegmentIndex = 0;
        }];
        [alert addAction:action1];
        [alert addAction:action2];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

//切换车位占用状态
-(void)carportStateChange{
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    }else if (section == 1){
        return 3;
    }else{
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"carportCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"carportCell"];
    }else{
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"发布日期";
            cell.detailTextLabel.text = [_carportInfo objectForKey:@"publishTime"];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else if (indexPath.row == 1){
            cell.textLabel.text = @"车位详情";
            cell.detailTextLabel.text = @"";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if (indexPath.row == 2){
            cell.textLabel.text = @"车位图片";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"共%lu张",[[_carportInfo objectForKey:@"carportImages"] count]];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            //添加按钮
            CustomButton * commentBtn = [[CustomButton alloc] initWithFrame:CGRectMake(0, 0, ([UIScreen mainScreen].bounds.size.width-20)/3.0, 44) AndType:2];
            [commentBtn setImage:[UIImage imageNamed:@"myNotice.png"] forState:UIControlStateNormal];
            [commentBtn setTitle:[_carportInfo objectForKey:@"commentNum"] forState:UIControlStateNormal];
            //添加事件响应
            [commentBtn addTarget:self action:@selector(gotoCommentView) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:commentBtn];
            
            //添加点赞按钮
            CustomButton * praiseNumBtn = [[CustomButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(commentBtn.frame), 0, commentBtn.frame.size.width, 44) AndType:2];
            [praiseNumBtn setImage:[UIImage imageNamed:@"myNotice.png"] forState:UIControlStateNormal];
            [praiseNumBtn setTitle:[_carportInfo objectForKey:@"praiseNum"] forState:UIControlStateNormal];
           
            [praiseNumBtn addTarget:self action:@selector(gotoPraiseView) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:praiseNumBtn];
            
            //添加关注按钮
            CustomButton * attentionBtn = [[CustomButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(praiseNumBtn.frame), 0, praiseNumBtn.frame.size.width, 44) AndType:2];
            [attentionBtn setImage:[UIImage imageNamed:@"myNotice.png"] forState:UIControlStateNormal];
            [attentionBtn setTitle:[_carportInfo objectForKey:@"attentionNum"] forState:UIControlStateNormal];
           
            [attentionBtn addTarget:self action:@selector(gotoAttentionView) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:attentionBtn];
            cell.textLabel.text = @"";
            cell.detailTextLabel.text = @"";
            cell.accessoryType = UITableViewCellAccessoryNone;
        }

    }else if (indexPath.section == 1){
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"已申请人数";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"共%@人",[_carportInfo objectForKey:@"requestNum"]];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if(indexPath.row == 1){
            cell.textLabel.text = @"当前是否占用";
            cell.detailTextLabel.text = @"";
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.accessoryView = self.carportStateSeg;
            if ([[_carportInfo objectForKey:@"carportState"] isEqualToString:@"NO"]) {
                _carportStateSeg.selectedSegmentIndex = 0;
            }else{
                _carportStateSeg.selectedSegmentIndex = 1;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else{
            cell.textLabel.text = @"是否关闭交易";
            cell.detailTextLabel.text = @"";
            cell.accessoryView = self.transactionStateSeg;
            if ([[_carportInfo objectForKey:@"transactionState"] isEqualToString:@"NO"]) {
                _transactionStateSeg.selectedSegmentIndex = 0;
            }else{
                _transactionStateSeg.selectedSegmentIndex = 1;
            }
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
    }else{
        UIButton * deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
        [deleteBtn setTitle:@"注销车位" forState:UIControlStateNormal];
        [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [deleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        deleteBtn.backgroundColor = [UIColor redColor];
        [deleteBtn addTarget:self action:@selector(deleteNow) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:deleteBtn];
        
        cell.textLabel.text = @"";
        cell.detailTextLabel.text = @"";
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"车位基本信息";
    }else if (section == 1){
        return @"车位管理操作";
    }else{
        return nil;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ((indexPath.section == 0) && (indexPath.row == 1)) {
        JWMyCarportInfoTableViewController * carportInfoView = [[JWMyCarportInfoTableViewController alloc] init];
        carportInfoView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:carportInfoView animated:YES];
    }else if ((indexPath.section == 0) && (indexPath.row == 2)){
        NSArray * array = [_carportInfo objectForKey:@"carportImages"];
        if (array.count == 0) {
            //无图片，跳转到图片上传界面
        }else{
            _imageArray = [[NSMutableArray alloc] init];
            //图片预览界面
            for (NSString * urlStr in array) {
                MWPhoto * photo = [MWPhoto photoWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://120.25.162.238/parkingLease/carportImages/%@",urlStr]]];
                [_imageArray addObject:photo];
            }
            MWPhotoBrowser * browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
            browser.displayActionButton = YES;
            browser.displaySelectionButtons = NO;
            browser.displayNavArrows = YES;
            browser.alwaysShowControls = NO;
            browser.zoomPhotosToFill = YES;
            browser.enableGrid = YES;
            browser.startOnGrid = NO;
            browser.enableSwipeToDismiss = NO;
            browser.autoPlayOnAppear = NO;
            [browser setCurrentPhotoIndex:0];
            [self.navigationController pushViewController:browser animated:YES];
        }
    }
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _imageArray.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _imageArray.count)
        return [_imageArray objectAtIndex:index];
    return nil;
}


@end
