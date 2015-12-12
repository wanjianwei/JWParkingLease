//
//  JWCenterGetParkingViewController.m
//  JWParkingLease
//
//  Created by jway on 15/12/11.
//  Copyright © 2015年 jway. All rights reserved.
//

#import "JWCenterGetParkingViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "JWSearchResultViewController.h"
#import "JWChoseCityViewController.h"
@interface JWCenterGetParkingViewController ()<UISearchBarDelegate>

//@property(nonatomic,strong)JWSearchResultViewController * searchView;
//@property(nonatomic,strong)UISearchController * searchController;


@property(nonatomic,strong)UISearchBar * searchBar;


@end

@implementation JWCenterGetParkingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //导航栏左边按钮，用于打开左侧导航栏
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(openSlide)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
    
    //导航栏右边按钮，用于跳往“选择城市界面”
    UIBarButtonItem * rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"武汉" style:UIBarButtonItemStyleDone target:self action:@selector(chooseCity)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    
    
    
    //titleView
    self.searchBar = [[UISearchBar alloc] init];
    _searchBar.placeholder = @"请输入小区名称/地址";
    _searchBar.delegate = self;
    self.navigationItem.titleView = _searchBar;
    
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//重新选择所在城市
-(void)chooseCity{
    JWChoseCityViewController * cityView = [[JWChoseCityViewController alloc] init];
    [self.navigationController pushViewController:cityView animated:YES];
}

//打开左侧导航栏
-(void)openSlide{
    
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}



#pragma UISearchBarDelegate

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    //跳转到JWSearchResultViewController
    JWSearchResultViewController * searchResultView = [[JWSearchResultViewController alloc] init];
    [self.navigationController pushViewController:searchResultView animated:YES];
    
    return NO;
    
}

@end
