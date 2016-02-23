//
//  JWScrollImagesView.m
//  JWParkingLease
//
//  Created by jway on 16/1/18.
//  Copyright © 2016年 jway. All rights reserved.
//

#import "JWScrollImagesView.h"
#import "UIImageView+WebCache.h"

#define WIDTH self.bounds.size.width
#define HEIGHT self.bounds.size.height


@implementation JWScrollImagesView

-(id)initWithFrame:(CGRect)frame WithImageArray:(NSArray *)imageArr{
    self = [super initWithFrame:frame];
    if (self) {
        _imageArray = imageArr;
        if (_imageArray.count>1) {
            [self layoutUI];
        }else{
            //只添加一个uiimageVIew，无需滚动
            [self addImageView];
        }
    }
    return self;
}

//当图片只有一张或无图片时
-(void)addImageView{
    
    UIImageView * defaultView = [[UIImageView alloc] initWithFrame:self.bounds];
    if (_imageArray.count == 1) {
        [defaultView sd_setImageWithURL:[NSURL URLWithString:[_imageArray objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"bg_img.png"]];
    }else{
        //无图片时
        defaultView.image = [UIImage imageNamed:@"bg_img.png"];
    }
    [self addSubview:defaultView];
}



- (void)addScrollView {
    _scrV = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrV.contentSize = CGSizeMake(WIDTH * 3, HEIGHT);
    _scrV.contentOffset = CGPointMake(WIDTH, 0.0);
    _scrV.pagingEnabled = YES;
    _scrV.showsHorizontalScrollIndicator = NO;
    _scrV.delegate = self;
    [self addSubview:_scrV];
}

- (void)addImageViewsToScrollView {
    //图片视图；左边
    _imgVLeft = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, WIDTH, HEIGHT)];
    _imgVLeft.contentMode = UIViewContentModeScaleAspectFill;
    [_scrV addSubview:_imgVLeft];
    
    //图片视图；中间
    _imgVCenter = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH, 0.0, WIDTH, HEIGHT)];
    _imgVCenter.contentMode = UIViewContentModeScaleAspectFill;
    [_scrV addSubview:_imgVCenter];
    
    //图片视图；右边
    _imgVRight = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH * 2.0, 0.0, WIDTH, HEIGHT)];
    _imgVRight.contentMode = UIViewContentModeScaleAspectFill;
    [_scrV addSubview:_imgVRight];
}

- (void)addPageControl {
    _pageC = [UIPageControl new];
    CGSize size= [_pageC sizeForNumberOfPages:_imageArray.count]; //根据页数返回 UIPageControl 合适的大小
    _pageC.bounds =CGRectMake(0.0, 0.0, size.width, size.height);
    _pageC.center = CGPointMake(WIDTH / 2.0, HEIGHT - 20.0);
    _pageC.numberOfPages = _imageArray.count;
    _pageC.pageIndicatorTintColor = [UIColor whiteColor];
    _pageC.currentPageIndicatorTintColor = [UIColor brownColor];
    _pageC.userInteractionEnabled = NO; //设置是否允许用户交互；默认值为 YES，当为 YES 时，针对点击控件区域左（当前页索引减一，最小为0）右（当前页索引加一，最大为总数减一），可以编写 UIControlEventValueChanged 的事件处理方法
    [self addSubview:_pageC];
}

- (void)setInfoByCurrentImageIndex:(NSUInteger)currentImageIndex {
    
    [_imgVCenter sd_setImageWithURL:[NSURL URLWithString:[_imageArray objectAtIndex:currentImageIndex]] placeholderImage:[UIImage imageNamed:@"bg_img.png"]];
    
    DLog(@"url = %@",[_imageArray objectAtIndex:0]);
    
    [_imgVRight sd_setImageWithURL:[NSURL URLWithString:[_imageArray objectAtIndex:(unsigned long)((_currentImageIndex + 1) % _imageArray.count)]] placeholderImage:[UIImage imageNamed:@"bg_img.png"]];
    
    [_imgVLeft sd_setImageWithURL:[NSURL URLWithString:[_imageArray objectAtIndex:(unsigned long)((_currentImageIndex - 1 + _imageArray.count) % _imageArray.count)]] placeholderImage:[UIImage imageNamed:@"bg_img.png"]];
    
    _pageC.currentPage = currentImageIndex;
    
}

- (void)setDefaultInfo {
    _currentImageIndex = 0;
    [self setInfoByCurrentImageIndex:_currentImageIndex];
}

- (void)reloadImage {
    CGPoint contentOffset = [_scrV contentOffset];
    if (contentOffset.x > WIDTH) { //向左滑动
        _currentImageIndex = (_currentImageIndex + 1) % _imageArray.count;
    } else if (contentOffset.x < WIDTH) { //向右滑动
        _currentImageIndex = (_currentImageIndex - 1 + _imageArray.count) % _imageArray.count;
    }
    
    [self setInfoByCurrentImageIndex:_currentImageIndex];
}

- (void)layoutUI {
   // self.view.backgroundColor = [UIColor blackColor];
    
    [self addScrollView];
    [self addImageViewsToScrollView];
    [self addPageControl];
    [self setDefaultInfo];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self reloadImage];
    
    _scrV.contentOffset = CGPointMake(WIDTH, 0.0);
    _pageC.currentPage = _currentImageIndex;
    
   
}


@end
