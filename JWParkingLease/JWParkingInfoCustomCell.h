//
//  JWParkingInfoCustomCell.h
//  JWParkingLease
//
//  Created by jway on 16/1/12.
//  Copyright © 2016年 jway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JWParkingInfoFrame.h"
@interface JWParkingInfoCustomCell : UITableViewCell

//定义数据
@property(nonatomic,strong) JWParkingInfoFrame * parkingInfoFrame;

@property(nonatomic,assign) int cellType;


/**重新定义个初始化方法
 cellType = 1 表示是车位，cellType = 2表示是需求cell
 */
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier AndCellType:(int)cellType;
@end
