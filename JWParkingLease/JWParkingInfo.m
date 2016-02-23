//
//  JWParkingInfo.m
//  JWParkingLease
//
//  Created by jway on 16/1/12.
//  Copyright © 2016年 jway. All rights reserved.
//

#import "JWParkingInfo.h"

@implementation JWParkingInfo

//写初始化方法
-(id)initWithDic:(NSDictionary *)dic WithInfoType:(int)infoType{
    self = [super init];
    if (self) {
        //设置信息类型
        _infoType = infoType;
        //变换dic的时间格式（比如时间）
        NSDictionary * changedDic = [self changeFormatWithDic:dic];
        [self setValuesForKeysWithDictionary:changedDic];
    }
    return self;
}

//转换dic的时间格式
-(NSDictionary *)changeFormatWithDic:(NSDictionary *)dic{
    
    //转换时间
    NSMutableDictionary * changedDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    NSString * publishTime_temp = [changedDic objectForKey:@"publishTime"];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[publishTime_temp integerValue]];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    [changedDic setObject:[dateFormatter stringFromDate:date] forKey:@"publishTime"];
    
    //转换头像的网络地址
    [changedDic setObject:[NSString stringWithFormat:@"http://120.25.162.238/parkingLease/portrait/%@",[changedDic objectForKey:@"portrait"]] forKey:@"portrait"];
    
    //如果是车位，则有可能会有图片转换carportImage的地址
    if(_infoType == 1){
        NSArray * imageArr = [changedDic objectForKey:@"carportImages"];
        if (imageArr.count != 0) {
            __block BOOL flag = YES;
            NSMutableArray * newArray = [[NSMutableArray alloc] init];
            while (flag) {
                [imageArr enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSString * newUrl = [NSString stringWithFormat:@"http://120.25.162.238/parkingLease/carportImages/%@",obj];
                    [newArray addObject:newUrl];
                    if (idx == imageArr.count-1) {
                        flag = NO;
                    }
                }];
            }
            [changedDic setObject:newArray forKey:@"carportImages"];
        }
    }
    
    return [changedDic copy];
}

@end
