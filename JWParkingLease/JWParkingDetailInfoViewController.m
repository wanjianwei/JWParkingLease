//
//  JWParkingDetailInfoViewController.m
//  JWParkingLease
//
//  Created by jway on 16/1/14.
//  Copyright © 2016年 jway. All rights reserved.
//

#import "JWParkingDetailInfoViewController.h"

#import "AppDelegate.h"
#import "JWCommentCustomCell.h"

#import "JWScrollImagesView.h"


#import "JWCommentViewController.h"
#import "CustomButton.h"

@interface JWParkingDetailInfoViewController ()<UITableViewDelegate,UITableViewDataSource>{
    //app程序委托类
    AppDelegate * app;
}

@property(nonatomic,strong)UITableView * tableView;

//定义一个数组，用来存放评论
@property(nonatomic,strong)NSMutableArray * commentArr;
//底部工具栏的背景视图
@property(nonatomic,strong) UIView * toolBgView;


@end

@implementation JWParkingDetailInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem * rightBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    //设置标题
    if (_infoType == 1) {
        self.title = @"需求详情";
    }else{
        self.title = @"车位详情";
    }
    
    //初始化变量
    app = [UIApplication sharedApplication].delegate;
    self.commentArr = [[NSMutableArray alloc] init];
    //初始化表示图
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-45) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    if (_infoType !=1 ) {
        //设置表头
        JWScrollImagesView * headerView = [[JWScrollImagesView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, ([UIScreen mainScreen].bounds.size.height-100)/3.0) WithImageArray:_parkingInfo.carportImages];
        [_tableView setTableHeaderView:headerView];
    }else{
        //设置表头
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
        view.backgroundColor = [UIColor clearColor];
        UILabel * headerView = [[UILabel alloc] initWithFrame:CGRectMake(16, 20, [UIScreen mainScreen].bounds.size.width-32, 20)];
        headerView.textAlignment = NSTextAlignmentLeft;
        headerView.font = [UIFont boldSystemFontOfSize:12];
        headerView.textColor = [UIColor grayColor];
        headerView.backgroundColor = [UIColor clearColor];
        headerView.text = @"求租车位地址及类型";
        [view addSubview:headerView];
        [_tableView setTableHeaderView:view];
        
    }
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_tableView];
    
    
    
    
    //设置一个底部工具栏
    self.toolBgView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-45, [UIScreen mainScreen].bounds.size.width, 45)];
    _toolBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_toolBgView];
    
    //点赞按钮
    CustomButton * praiseBtn = [[CustomButton alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width/6.0, 45) AndType:1];
    [praiseBtn setImage:[UIImage imageNamed:@"myFocus.png"] forState:UIControlStateNormal];
    [praiseBtn setTitle:@"点赞" forState:UIControlStateNormal];
    [praiseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [praiseBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    praiseBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [praiseBtn addTarget:self action:@selector(praise) forControlEvents:UIControlEventTouchUpInside];
    [_toolBgView addSubview:praiseBtn];
    
    //关注按钮
    CustomButton * attentionBtn = [[CustomButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(praiseBtn.frame), 0, [UIScreen mainScreen].bounds.size.width/6.0, 45) AndType:1];
    [attentionBtn setImage:[UIImage imageNamed:@"myFocus.png"] forState:UIControlStateNormal];
    [attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
    [attentionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [attentionBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    attentionBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [attentionBtn addTarget:self action:@selector(attention) forControlEvents:UIControlEventTouchUpInside];
    [_toolBgView addSubview:attentionBtn];
    
    //私信按钮
    UIButton * messageBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(attentionBtn.frame), 0, [UIScreen mainScreen].bounds.size.width/3.0, 45)];
    [messageBtn setBackgroundColor:[UIColor orangeColor]];
    [messageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [messageBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [messageBtn setTitle:@"私信车主" forState:UIControlStateNormal];
    [messageBtn addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    [_toolBgView addSubview:messageBtn];
    
    //立即申请按钮
    UIButton * requestBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(messageBtn.frame), 0, [UIScreen mainScreen].bounds.size.width/3.0, 45)];
    [requestBtn setBackgroundColor:[UIColor redColor]];
    [requestBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [requestBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [requestBtn setTitle:@"立即申请" forState:UIControlStateNormal];
    [requestBtn addTarget:self action:@selector(request_now) forControlEvents:UIControlEventTouchUpInside];
    [_toolBgView addSubview:requestBtn];
    
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//分享操作
-(void)share{
    
}

//展示地图
-(void)showMap{
    
}

//点赞操作
-(void)praise{
    
}

//关注
-(void)attention{
    
}

//私信
-(void)sendMessage{
    
}

//立即申请
-(void)request_now{
    
}



#pragma UITableViewDelegate/dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (tableView.dataSource>0) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self hideOtherSeporateLine:tableView];
    }else{
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return 4;
}

//隐藏其余的cell分割线
-(void)hideOtherSeporateLine:(UITableView *)tableView{
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 3;
    }else if (section == 1){
        return 2;
    }else if (section == 2){
        return 1;
    }else{
        return 1;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if ((indexPath.section == 0) && (indexPath.row == 0)) {
       UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"subtitleCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"subtitleCell"];
        }
        
        cell.textLabel.text = _parkingInfo.detailAddress;
        cell.detailTextLabel.text = _parkingInfo.address;
        cell.detailTextLabel.textColor = [UIColor grayColor];
        
        //button定义
        UIButton * showMapBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 45)];
        [showMapBtn setBackgroundImage:[UIImage imageNamed:@"user_location.png"] forState:UIControlStateNormal];
        [showMapBtn addTarget:self action:@selector(showMap) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView = showMapBtn;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else if (indexPath.section == 3){
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"commentCell"];
        }
        cell.textLabel.text = @"查看评论";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"共%@条",_parkingInfo.commentNum];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }else{
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"commonCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"commonCell"];
        }
        if ((indexPath.section == 0) && (indexPath.row == 1)) {
            //
            UILabel * leaseType = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width/2.0, 44)];
            leaseType.text = _parkingInfo.leaseType;
            leaseType.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:leaseType];
            
            //添加中间的分割符
            UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2.0-10, 0, 20, 44)];
            lab.textAlignment = NSTextAlignmentCenter;
            lab.text = @"|";
            lab.textColor = [UIColor grayColor];
            [cell.contentView addSubview:lab];
            
            UILabel * carportPrice = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2.0, 0, [UIScreen mainScreen].bounds.size.width/2.0, 44)];
            carportPrice.textAlignment = NSTextAlignmentCenter;
            carportPrice.textColor = [UIColor redColor];
            carportPrice.text = _parkingInfo.carportPrice;
            [cell.contentView addSubview:carportPrice];
        }else if ((indexPath.section == 0) && (indexPath.row == 2)){
            cell.textLabel.text = @"车位类型:";
            cell.detailTextLabel.text = _parkingInfo.carportType;
            cell.textLabel.font = [UIFont systemFontOfSize:17];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:17];
        }else if (indexPath.section == 1){
            //租赁时段
            if (indexPath.row == 0) {
                cell.textLabel.text = @"起始时间:";
                cell.textLabel.font = [UIFont systemFontOfSize:17];
                cell.detailTextLabel.text = ([_parkingInfo.leaseBeginTime isEqualToString:@""])?@"- 年 - 月 - 日":_parkingInfo.leaseBeginTime;
                cell.detailTextLabel.font = [UIFont systemFontOfSize:17];
            }else{
                cell.textLabel.text = @"截止时间:";
                cell.textLabel.font = [UIFont systemFontOfSize:17];
                cell.detailTextLabel.text = ([_parkingInfo.leaseEndTime isEqualToString:@""])?@"- 年 - 月 - 日":_parkingInfo.leaseEndTime;
                cell.detailTextLabel.font = [UIFont systemFontOfSize:17];
            }
        }else{
            /**section=3的情况，先计算业主额外说明的字符串的尺寸
             */
            
            CGRect illustrationFrame = [_parkingInfo.illustration boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-32, 600) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19]} context:nil];
            
            UILabel * illustrationLab = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, [UIScreen mainScreen].bounds.size.width-32, illustrationFrame.size.height)];
            
            DLog(@"textheight = %f",illustrationFrame.size.height);
            
            illustrationLab.font = [UIFont systemFontOfSize:17];
            illustrationLab.textAlignment = NSTextAlignmentLeft;
            illustrationLab.text = _parkingInfo.illustration;
            illustrationLab.numberOfLines = 0;
            [cell.contentView addSubview:illustrationLab];
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}


//footer高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 40;
    }else if (section == 1){
        return 40;
    }else{
        return 20;
    }
   
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    view.backgroundColor = [UIColor clearColor];
    UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(16, 20, [UIScreen mainScreen].bounds.size.width-32, 20)];
    lab.textAlignment = NSTextAlignmentLeft;
    lab.font = [UIFont boldSystemFontOfSize:12];
    lab.textColor = [UIColor grayColor];
    lab.backgroundColor = [UIColor clearColor];
    [view addSubview:lab];
    
    //分情况显示
    if (_infoType == 1) {
        if (section == 0) {
            lab.text = @"求租时段";
            return view;
        }else if (section == 1){
            lab.text = @"求租者附加说明";
            return view;
        }else if(section == 2){
            lab.text = @"";
            return view;
        }else{
            return view;
        }
    }else{
        if (section == 0) {
            lab.text = @"租让时段(若为出售，则不限定时段)";
            return view;
        }else if (section == 1){
            lab.text = @"业主附加说明";
            return view;
        }else if(section == 2){
            lab.text = @"";
            return view;
        }else{
            return view;
        }
    }
}

//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 60;
        }else{
            return 44;
        }
    }else if (indexPath.section == 1){
        return 44;
    }else if (indexPath.section == 2){
        
        CGRect illustrationFrame = [_parkingInfo.illustration boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-32, 600) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19]} context:nil];
        return illustrationFrame.size.height;
        
    }else{
        return 44;
    }
}

//点击单元格
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        JWCommentViewController * commentView = [[JWCommentViewController alloc] init];
        commentView.hidesBottomBarWhenPushed = YES;
        commentView.userType = 1;
        commentView.commentType = 0;
        [self.navigationController pushViewController:commentView animated:YES];
    }
}

@end
