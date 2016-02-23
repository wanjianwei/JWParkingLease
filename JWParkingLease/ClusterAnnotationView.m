//
//  ClusterAnnotationView.m
//  CCHMapClusterController Example iOS
//
//  Created by Hoefele, Claus(choefele) on 09.01.14.
//  Copyright (c) 2014 Claus Höfele. All rights reserved.
//

// Based on https://github.com/thoughtbot/TBAnnotationClustering/blob/master/TBAnnotationClustering/TBClusterAnnotationView.m by Theodore Calmes

#import "ClusterAnnotationView.h"

@interface ClusterAnnotationView ()



@end

@implementation ClusterAnnotationView

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        //[self setUpLabel];
        //[self setCount:1];
        _countLabel = [[UILabel alloc] init];
        _countLabel.textColor = [UIColor whiteColor];
        _countLabel.font = [UIFont systemFontOfSize:10];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.layer.cornerRadius = 3.0f;
        _countLabel.layer.masksToBounds = YES;
        [self addSubview:_countLabel];
        self.alpha = 0.85;
    }
    return self;
}


- (void)setCount:(NSUInteger)count
{
    _count = count;
    
    if (count < 10 && count>=1) {
        [self setBounds:CGRectMake(0, 0, 25, 22)];
        _countLabel.frame = CGRectMake(0, 0, 25, 22);
        _countLabel.backgroundColor = [UIColor redColor];
    } else if (count >= 10 && count <100 ) {
        [self setBounds:CGRectMake(0, 0, 35, 22)];
        _countLabel.frame = CGRectMake(0, 0, 35, 22);
        _countLabel.backgroundColor = [UIColor purpleColor];
    } else if (count >=100 && count < 1000) {
        [self setBounds:CGRectMake(0, 0, 50, 22)];
        _countLabel.frame = CGRectMake(0, 0, 50, 22);
        _countLabel.backgroundColor = [UIColor blueColor];
    } else {
        [self setBounds:CGRectMake(0, 0, 55, 22)];
        _countLabel.frame = CGRectMake(0, 0, 55, 22);
       _countLabel.backgroundColor = [UIColor greenColor];
    }
    _countLabel.text = [NSString stringWithFormat:@"%ld套", (unsigned long)count];
}



- (void)setUniqueLocation:(BOOL)uniqueLocation
{
    _uniqueLocation = uniqueLocation;
    [self setNeedsLayout];
}


@end
