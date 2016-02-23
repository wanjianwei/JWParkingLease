//
//  JWCommentInfo.m
//  JWParkingLease
//
//  Created by jway on 16/1/14.
//  Copyright © 2016年 jway. All rights reserved.
//

#import "JWCommentInfo.h"

@implementation JWCommentInfo

-(id)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        NSDictionary * newDic = [self changeFormatWithDic:dic];
        [self setValuesForKeysWithDictionary:newDic];
        //将评论回复拼接成字符串
        if (self.repliedArray.count == 0) {
            //初始化
            self.repliedContent = [NSMutableString stringWithString:@""];
        }else{
            self.repliedContent = [NSMutableString stringWithString:@""];
            [self appendingRepliedComment];
        }
    }
    return self;
}


//更改传入字典形式
-(NSDictionary *)changeFormatWithDic:(NSDictionary *)dic{
    //转换时间
    NSMutableDictionary * changedDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    NSString * commenTime_temp = [changedDic objectForKey:@"commentTime"];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[commenTime_temp integerValue]];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    [changedDic setObject:[dateFormatter stringFromDate:date] forKey:@"commentTime"];
    
    //转换头像地址
    NSString * portraitUrl = [NSString stringWithFormat:@"http://120.25.162.238/parkingLease/portrait/%@",[changedDic objectForKey:@"portrait"]];
    [changedDic setObject:portraitUrl forKey:@"portrait"];
    
    
    return [changedDic copy];
}

//将评论回复内容数组拼接成字符串
-(void)appendingRepliedComment{

    //设置时间格式
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    
    for (NSDictionary * dic in self.repliedArray) {
        NSDate * repliedDate = [NSDate dateWithTimeIntervalSince1970:[[dic objectForKey:@"repliedTime"] integerValue]];
        [self.repliedContent appendString:[NSString stringWithFormat:@"业主回复:%@-%@\n",[dic objectForKey:@"repliedContent"],[dateFormatter stringFromDate:repliedDate]]];
    }
    
}


@end
