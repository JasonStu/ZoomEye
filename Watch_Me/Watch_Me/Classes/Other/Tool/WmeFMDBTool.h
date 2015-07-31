//
//  WmeFMDBTool.h
//  Watch_Me
//
//  Created by lanou on 15/7/29.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WmeTableModel;
@interface WmeFMDBTool : NSObject
+(BOOL)addMovie:(WmeTableModel *)model;
+ (WmeTableModel *)findAllMovie;
+ (NSString *)findM3U8:(WmeTableModel *)model;
+(BOOL)removeMovie:(WmeTableModel *)model;
+ (NSMutableArray *)findAllMovieArray;
@end
