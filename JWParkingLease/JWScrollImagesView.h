//
//  JWScrollImagesView.h
//  JWParkingLease
//
//  Created by jway on 16/1/18.
//  Copyright © 2016年 jway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JWScrollImagesView : UIView<UIScrollViewDelegate>

//添加滚动视图
@property(strong,nonatomic) UIScrollView * scrV;
//分页控制器
@property (strong, nonatomic) UIPageControl *pageC;
@property (strong, nonatomic) UIImageView *imgVLeft;
@property (strong, nonatomic) UIImageView *imgVCenter;
@property (strong, nonatomic) UIImageView *imgVRight;
//当前索引
@property (assign, nonatomic) NSUInteger currentImageIndex;
//图片数组
@property (assign, nonatomic) NSArray * imageArray;

//构造一个初始化方法
-(id)initWithFrame:(CGRect)frame WithImageArray:(NSArray *)imageArr;

@end
