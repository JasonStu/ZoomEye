//
//  WmeChannelModel.m
//  Watch_Me
//
//  Created by lanou on 15/7/24.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "WmeChannelModel.h"

@implementation WmeChannelModel
- (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID" : @"id",@"Mdescription":@"description"};
}
@end
