//
//  JWCommentViewController.h
//  JWParkingLease
//
//  Created by jway on 16/1/21.
//  Copyright © 2016年 jway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JWCommentViewController : UIViewController

/**评论类型，当commentType = 1时表示需求，默认为对车位的评论
 */
@property(nonatomic,assign) int commentType;

/**
 查看评论的用户身份，如果是租赁者查看，则为1；默认为发布者查看
 */
@property(nonatomic,assign) int userType;

/**用来接受传递过来的id（需求id或是车位id）
 */
@property(nonatomic,strong) NSString * infoId;

@end
