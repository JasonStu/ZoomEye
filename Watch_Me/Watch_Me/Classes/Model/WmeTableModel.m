//
//  WmeTableModel.m
//  Watch_Me
//
//  Created by lanou on 15/7/24.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "WmeTableModel.h"

@implementation WmeTableModel
- (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID" : @"id",@"Mdescription":@"description"};
}
@end
