//
//  choseTimeViewController.m
//  JWParkingLease
//
//  Created by jway on 15/12/17.
//  Copyright © 2015年 jway. All rights reserved.
//

#import "choseTimeViewController.h"


@interface choseTimeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>{
    //每个item的尺寸
    CGSize size;
    //定义两个数组
    NSArray * weekArray;
    NSArray * timeArray;
}

//定义一个collectionView
@property(nonatomic,strong)UICollectionView * collectionView;

@end

@implementation choseTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //初始化
    CGFloat with = ([UIScreen mainScreen].bounds.size.width-10-1.5*7)/8.0;
    CGFloat height = ([UIScreen mainScreen].bounds.size.height-140-1.5*25)/25.0;
    
    size = CGSizeMake(with, height);
    
    self.title = @"选择时间段";
    self.automaticallyAdjustsScrollViewInsets = NO;
    //flowLaayout是用来做全局布局的
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
    /*
    flowLayout.minimumInteritemSpacing = 1.5;
    flowLayout.minimumLineSpacing = 1.5f;
    flowLayout.itemSize = size;
    
    */
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 70, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-140) collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.scrollEnabled = NO;
    _collectionView.backgroundColor = [UIColor clearColor];
    
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"timeCell"];
    
    [self.view addSubview:_collectionView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    //初始化数组
    weekArray = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
    timeArray = @[@"00:00",@"01:00",@"02:00",@"03:00",@"04:00",@"05:00",@"06:00",@"07:00",@"08:00",@"09:00",@"10:00",@"11:00",@"12:00",@"13:00",@"14:00",@"15:00",@"16:00",@"17:00",@"18:00",@"19:00",@"20:00",@"21:00",@"22:00",@"23:00"];
    
    //定义一个提交按钮
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(10, [UIScreen mainScreen].bounds.size.height-70+15, [UIScreen mainScreen].bounds.size.width-20, 44)];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(handInfo) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 4.0f;
    [self.view addSubview:btn];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//提交信息
-(void)handInfo{
    
}


#pragma UICollectionViewDataSource/Delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 25;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 8;
}


-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"timeCell" forIndexPath:indexPath];
    
    
    if (indexPath.section == 0) {
        if (indexPath.row != 0) {
            //添加label
            UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
            lab.textAlignment = NSTextAlignmentCenter;
            lab.textColor = [UIColor whiteColor];
            lab.font = [UIFont boldSystemFontOfSize:13];
            lab.text = [weekArray objectAtIndex:indexPath.row-1];
            cell.backgroundColor = [UIColor blueColor];
            [cell.contentView addSubview:lab];
        }else
            cell.backgroundColor = [UIColor clearColor];
        //该部分单元格无法编辑
        cell.userInteractionEnabled = NO;
    }else if (indexPath.row == 0){
        if (indexPath.section != 0) {
            //添加label
            UILabel * lab2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
            lab2.textAlignment = NSTextAlignmentCenter;
            lab2.textColor = [UIColor grayColor];
            lab2.font = [UIFont boldSystemFontOfSize:11];
            lab2.text = [timeArray objectAtIndex:indexPath.section-1];
            [cell.contentView addSubview:lab2];
            cell.backgroundColor = [UIColor clearColor];
            cell.userInteractionEnabled = NO;
        }
        
    }else{
        
        [cell setBackgroundColor:[UIColor lightGrayColor]];
    }
    
    
    return cell;
}


//单元格之间的距离
/*
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 1.5;
}
 */

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 1.5;
}
 
 - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
     return size;
 }
 


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(1.5, 5, 0, 5);
}


//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    if ([cell.backgroundColor isEqual:[UIColor greenColor]]) {
        [cell setBackgroundColor:[UIColor lightGrayColor]];
        //从记录中将该信息删除
        
        
    }else{
        [cell setBackgroundColor:[UIColor greenColor]];
        //将该信息记录下
    }
    
}


@end

