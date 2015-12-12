//
//  AppDelegate.m
//  JWParkingLease
//
//  Created by jway on 15/12/11.
//  Copyright © 2015年 jway. All rights reserved.
//

#import "AppDelegate.h"
#import "JWLeftViewController.h"
#import "JWCenterGetParkingViewController.h"
#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"
//#import "MMExampleDrawerVisualStateManager.h"


#import <QuartzCore/QuartzCore.h>

@interface AppDelegate ()

@property (nonatomic,strong) MMDrawerController * drawerController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    JWLeftViewController * leftView = [[JWLeftViewController alloc] init];
    leftView.restorationIdentifier = @"leftView";
    JWCenterGetParkingViewController * centerView = [[JWCenterGetParkingViewController alloc] init];
    UINavigationController * navCenterView = [[UINavigationController alloc] initWithRootViewController:centerView];
    navCenterView.restorationIdentifier = @"navCenterView";
    self.drawerController = [[MMDrawerController alloc] initWithCenterViewController:navCenterView leftDrawerViewController:leftView];
    _drawerController.restorationIdentifier = @"drawerView";
    
    //指定打开或关闭手势
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    //左边侧栏打开方式
    [_drawerController setDrawerVisualStateBlock:[MMDrawerVisualState swingingDoorVisualStateBlock]];
    //侧栏的宽度
    _drawerController.maximumLeftDrawerWidth = [UIScreen mainScreen].bounds.size.width/4;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:self.drawerController];
   // _window.backgroundColor = [UIColor whiteColor];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
- (BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder{
    
    return YES;
}

- (BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder{
   
    return YES;
}

- (UIViewController *)application:(UIApplication *)application viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder{
    
    NSLog(@"arr = %@",identifierComponents);
    
    NSString * key = [identifierComponents lastObject];
    if([key isEqualToString:@"drawerView"]){
        return self.window.rootViewController;
    }else if ([key isEqualToString:@"leftView"]){
        return ((MMDrawerController *)self.window.rootViewController).leftDrawerViewController;
    }else if ([key isEqualToString:@"navCenterView"]){
       return ((MMDrawerController *)self.window.rootViewController).centerViewController;
    }else{
        return nil;
    }
}
*/
@end
