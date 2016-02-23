//
//  JWCommentViewController.m
//  JWParkingLease
//
//  Created by jway on 16/1/21.
//  Copyright © 2016年 jway. All rights reserved.
//

#import "JWCommentViewController.h"
#import "AppDelegate.h"
#import "JWCommentCustomCell.h"
//下拉刷新和上拉加载
#import "SDRefresh.h"
//自定义输入框
#import "JWInputBarView.h"


@interface JWCommentViewController ()<UITableViewDataSource,UITableViewDelegate,replyCommentDelegate>{
    AppDelegate * app;
}
//评论列表
@property(nonatomic,strong) UITableView * commentList;
//存储评论
@property(nonatomic,strong) NSMutableArray * commentArray;
//上拉加载
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
//自定义输入框
@property (nonatomic,strong) JWInputBarView * inputBar;

@end

@implementation JWCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    self.title = @"用户评论";
    self.commentList = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _commentList.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _commentList.delegate = self;
    _commentList.dataSource = self;
    [self.view addSubview:_commentList];
    
    //初始化实例变量
    app = [[UIApplication sharedApplication] delegate];
    _commentArray = [[NSMutableArray alloc] init];
    
    //初始化评论输入框
    self.inputBar = [[JWInputBarView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-45, [UIScreen mainScreen].bounds.size.width, 45)];
    [self.view addSubview:_inputBar];
    
    //上拉加载
    [self setupFooter];
    
    //监听键盘出现通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    //构造虚拟数据
    for(int i = 1;i<5;i++){
        //构造评论数据
        NSDictionary * dic = @{@"commentId":@"12",@"portrait":@"12",@"username":@"wanjway",@"commentTime":@"1452779837",@"content":@"我是大都是分开了倦了考试的话在SD卡联合国环境卡尔换个卡机但是在附近噶可能就会感觉是",@"repliedArray":@[@{@"commentRepliedId":@"2",@"repliedContent":@"是打发士大夫阿尔公司的换个色老公速度在韩国",@"repliedTime":@"1452799999"},@{@"commentRepliedId":@"23",@"repliedContent":@"我终于设置成功了",@"repliedTime":@"1452899999"}]};
        JWCommentInfo * commentInfo = [[JWCommentInfo alloc] initWithDic:dic];
        
        JWCommentInfoFrame * commentInfoFrame = [[JWCommentInfoFrame alloc] initWithCommentInfo:commentInfo];
        
        [_commentArray addObject:commentInfoFrame];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

//上拉加载
- (void)setupFooter{
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshView];
    [refreshFooter addToScrollView:self.commentList];
    [refreshFooter addTarget:self refreshAction:@selector(footerRefresh)];
    _refreshFooter = refreshFooter;
}

//再次向服务器请求数据，并重新加载
-(void)footerRefresh{
    /**此处要根据commentType的值来分别加载需求评论或是车位评论
     */
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //构造数据
        for (int i =1; i<5; i++) {
           
        }
        [_refreshFooter endRefreshing];
        
    });
    [self.commentList reloadData];
}

//键盘出现
-(void)keyboardWillShow:(NSNotification *)noti{
    NSDictionary * dic = noti.userInfo;
    NSValue *aValue = [dic objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    
    [UIView animateWithDuration:0.5 animations:^{
        //移动输入框
        CGRect rect = _inputBar.frame;
        rect.origin.y -= height;
        _inputBar.frame = rect;
    }];
}

//键盘消失
-(void)keyboardWillHide:(NSNotification *)noti{
    NSDictionary * dic = noti.userInfo;
    NSValue *aValue = [dic objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    
    [UIView animateWithDuration:0.5 animations:^{
        //移动输入框
        CGRect rect = _inputBar.frame;
        rect.origin.y += height;
        _inputBar.frame = rect;
        if (!_inputBar.beRepliedText.hidden) {
            _inputBar.beRepliedText.hidden = YES;
        }
               
    }];
}

#pragma UITableViewDelegate/DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView.dataSource>0) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self hideOtherSeparateLines:tableView];
    }else{
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return 1;
}

//隐藏多余的分割线
-(void)hideOtherSeparateLines:(UITableView *)tableView{
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _commentArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JWCommentCustomCell * cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];
    if (cell == nil) {
        cell = [[JWCommentCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"commentCell"];
    }
    if (_userType == 1) {
        cell.replyBtn.hidden = YES;
    }
    cell.delegate = self;
    cell.commentInfoFrame = [_commentArray objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [[_commentArray objectAtIndex:indexPath.row] cellHeight];
}

#pragma replyCommentDelegate
-(void)replyUser:(NSString *)username WithContent:(NSString *)content{
    //如果此时inputBar不是第一响应者，说明用户此时没有编写评论（回复与评论只能同时进行一个）
    if (!_inputBar.inputView.isFirstResponder) {
        [_inputBar.inputView becomeFirstResponder];
        _inputBar.beRepliedText.text = [NSString stringWithFormat:@"回复%@:%@",username,content];
        _inputBar.beRepliedText.hidden = NO;
    }
    
}


@end
