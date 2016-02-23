//
//  JWMyDemandListViewController.m
//  JWParkingLease
//
//  Created by jway on 16/1/20.
//  Copyright © 2016年 jway. All rights reserved.
//

#import "JWMyDemandListViewController.h"
#import "AppDelegate.h"
#import "CustomButton.h"
//下拉刷新和上拉加载
#import "SDRefresh.h"
#import "JWMyDemandInfoDetailTableViewController.h"
#import "JWPublishDemandTableViewController.h"
#import "JWCommentViewController.h"
@interface JWMyDemandListViewController ()<UITableViewDataSource,UITableViewDelegate>{
    AppDelegate * app;
}

@property(nonatomic,strong) UITableView * demandList;

//存储结果
@property(nonatomic,strong) NSMutableArray * demandArray;

//上拉加载
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;

@end

@implementation JWMyDemandListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    self.title = @"我的需求";
    self.demandList = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width-20, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    self.demandList.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _demandList.delegate = self;
    _demandList.dataSource = self;
    [self.view addSubview:_demandList];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    //添加左导航栏按钮
    UIBarButtonItem * rightBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addDemand)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    //初始化变量
    app = [[UIApplication sharedApplication] delegate];
    _demandArray = [[NSMutableArray alloc] init];
    
    //上拉加载
    [self setupFooter];
    //构建虚拟数据
    for (int i = 0; i<5; i++) {
        [_demandArray addObject:@{@"demandId":@"11",@"publishTime":@"2015年12月23日",@"commentNum":@"23",@"praiseNum":@"34",@"attentionNum":@"65"}];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//跳转到添加需求界面
-(void)addDemand{
    JWPublishDemandTableViewController * demandPublishView = [[JWPublishDemandTableViewController alloc] init];
    demandPublishView.hidesBottomBarWhenPushed = YES;
    demandPublishView.title = @"需求添加";
    [self.navigationController pushViewController:demandPublishView animated:YES];
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
            [_demandArray addObject:@{@"demandId":@"21",@"publishTime":@"2015年11月23日",@"commentNum":@"13",@"praiseNum":@"343",@"attentionNum":@"735"}];
        }
        [_refreshFooter endRefreshing];
        
    });
    [self.demandList reloadData];
}


//跳转到评论界面
-(void)gotoCommentView:(id)sender{
    JWCommentViewController * commentView = [[JWCommentViewController alloc] init];
    commentView.hidesBottomBarWhenPushed = YES;
    //传递demandId；
    commentView.infoId = [[_demandArray objectAtIndex:[(UIButton *)sender tag]] objectForKey:@"demandId"];
    //传递评论类型值
    commentView.commentType = 1;
    [self.navigationController pushViewController:commentView animated:YES];
}

//跳转点赞按钮
-(void)gotoPraiseView:(id)sender{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"点赞人数" message:@"查看点赞用户尚未实现" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

//跳转到关注界面
-(void)gotoAttentionView:(id)sender{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"关注人数" message:@"查看关注用户尚未实现" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma UITableViewDelegate/dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (tableView.dataSource>0) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self hideOtherSeparateLines:tableView];
    }else{
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _demandArray.count;
}

-(void)hideOtherSeparateLines:(UITableView *)tableView{
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"demandNormalCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"demandNormalCell"];
    }else{
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"发布日期";
        cell.detailTextLabel.text = [[_demandArray objectAtIndex:indexPath.section] objectForKey:@"publishTime"];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"需求详情";
        cell.detailTextLabel.text = @"";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }else{
        //添加按钮
        CustomButton * commentBtn = [[CustomButton alloc] initWithFrame:CGRectMake(0, 0, ([UIScreen mainScreen].bounds.size.width-20)/3.0, 44) AndType:2];
        [commentBtn setImage:[UIImage imageNamed:@"myNotice.png"] forState:UIControlStateNormal];
        [commentBtn setTitle:[[_demandArray objectAtIndex:indexPath.section] objectForKey:@"commentNum"] forState:UIControlStateNormal];
        //设置button的tag
        commentBtn.tag = indexPath.section;
        
        //添加事件响应
        [commentBtn addTarget:self action:@selector(gotoCommentView:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:commentBtn];
        
        //添加点赞按钮
        CustomButton * praiseNumBtn = [[CustomButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(commentBtn.frame), 0, commentBtn.frame.size.width, 44) AndType:2];
        [praiseNumBtn setImage:[UIImage imageNamed:@"myNotice.png"] forState:UIControlStateNormal];
        [praiseNumBtn setTitle:[[_demandArray objectAtIndex:indexPath.section] objectForKey:@"praiseNum"] forState:UIControlStateNormal];
        praiseNumBtn.tag = indexPath.section;
        [praiseNumBtn addTarget:self action:@selector(gotoPraiseView:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:praiseNumBtn];
        
        //添加关注按钮
        CustomButton * attentionBtn = [[CustomButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(praiseNumBtn.frame), 0, praiseNumBtn.frame.size.width, 44) AndType:2];
        [attentionBtn setImage:[UIImage imageNamed:@"myNotice.png"] forState:UIControlStateNormal];
        [attentionBtn setTitle:[[_demandArray objectAtIndex:indexPath.section] objectForKey:@"attentionNum"] forState:UIControlStateNormal];
        attentionBtn.tag = indexPath.section;
        [attentionBtn addTarget:self action:@selector(gotoAttentionView:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:attentionBtn];
        
        cell.textLabel.text = @"";
        cell.detailTextLabel.text = @"";
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        JWMyDemandInfoDetailTableViewController * myDemandInfoDetailView = [[JWMyDemandInfoDetailTableViewController alloc] init];
        myDemandInfoDetailView.hidesBottomBarWhenPushed = YES;
        myDemandInfoDetailView.demandId = [[_demandArray objectAtIndex:indexPath.section] objectForKey:@"demandId"];
        [self.navigationController pushViewController:myDemandInfoDetailView animated:YES];
    }
}

@end
