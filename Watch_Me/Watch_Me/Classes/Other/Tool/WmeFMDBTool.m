//
//  WmeFMDBTool.m
//  Watch_Me
//
//  Created by lanou on 15/7/29.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "WmeFMDBTool.h"
#import "WmeTableModel.h"
#import "WmeUrL.h"
#import "WmeChannelModel.h"
#import "FMDatabase.h"//创建数据库需要添加的头文件
#import "FMResultSet.h"//用来查找多个数据时使用的头文件
#import "FMDatabaseAdditions.h"//使用搜索一条结果时需要加入的头文件
static FMDatabase  *db = nil;
@implementation WmeFMDBTool
+(void)openDB
{
    if (!db)
    {
        NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
        //2、在document路径下创建数据库路径
        NSString *dbPath=[docPath stringByAppendingPathComponent:@"test.sqlite"];//最好加上后缀名
        NSLog(@"dbpath=%@",dbPath);
        //3、创建数据库对象
        db=[FMDatabase databaseWithPath:dbPath];
        //        [db open];
    }
    //4、判断数据库是否打开
    BOOL flag = [db open];
    
    if (!flag)
    {
        NSLog(@"No Open");
        [db open];
    }else
    {
        NSLog(@"Open");
    }
    
    [db executeUpdate:@"create table if not exists testA (description text,image text,title text,play_count integer,id integer,share_count integer,m3u8 text,avatar text,background text,description1 text,title1 text,id1 integer)"];
    
}

+ (void)closeDB
{
    [db close];
}
+(BOOL)addMovie:(WmeTableModel *)model
{
     [WmeFMDBTool openDB];
    if ([self findMovie:model]==NO) {
       
        NSNumber *play_count = [NSNumber numberWithInt:model.play_count];
        NSNumber *id1 = [NSNumber numberWithInt:model.ID];
        NSNumber *share_count = [NSNumber numberWithInt:model.share_count];
        NSNumber *id2 = [NSNumber numberWithInt:model.channel.ID];
        BOOL isSuccess = [db executeUpdate:@"insert into testA(description,image,title,play_count,id,share_count,m3u8,avatar,background,description1,title1,id1) values(?,?,?,?,?,?,?,?,?,?,?,?)",model.Mdescription,model.image,model.title,play_count,id1,share_count,model.url.m3u8,model.channel.avatar,model.channel.background,model.channel.Mdescription,model.channel.title,id2];
        if (isSuccess) {
            NSLog(@"成功");
            return YES;
        }
    }
    [WmeFMDBTool closeDB];

    return NO;
}
+ (BOOL)findMovie:(WmeTableModel *)model
{
    [WmeFMDBTool openDB];
    FMResultSet *rs=[db executeQuery:@"select * from testA"];
    while ([rs next])
    {
        NSString *m3u8= [rs stringForColumn:@"m3u8"];
        if ([model.url.m3u8 isEqualToString:m3u8]) {
            return YES;
        }
    }
    
    [rs close];
    return NO;
}
+ (NSString *)findM3U8:(WmeTableModel *)model
{
    [WmeFMDBTool openDB];
    FMResultSet *rs=[db executeQuery:@"select * from testA"];
    while ([rs next])
    {
        NSString *m3u8= [rs stringForColumn:@"m3u8"];
        if ([model.url.m3u8 isEqualToString:m3u8]) {
            return m3u8;
        }
    }
    
    [rs close];
    return nil;
}
+ (WmeTableModel *)findAllMovie
{
    [WmeFMDBTool openDB];
    
    WmeTableModel *model = [[WmeTableModel alloc]init];
    
    FMResultSet *rs=[db executeQuery:@"select * from testA"];
    while ([rs next])
    {
        NSString *m3u8= [rs stringForColumn:@"m3u8"];
        int play_count= [rs intForColumn:@"play_count"];
        int id1 = [rs intForColumn:@"id"];
        int share_count = [rs intForColumn:@"share_count"];
        int id2 = [rs intForColumn:@"id1"];
        NSString *Mdescription = [rs stringForColumn:@"description"];
        NSString *CMdescription = [rs stringForColumn:@"description1"];
        NSString *image = [rs stringForColumn:@"image"];
        NSString *title = [rs stringForColumn:@"title"];
        NSString *avatar = [rs stringForColumn:@"avatar"];
        NSString *background = [rs stringForColumn:@"background"];
        NSString *title1 = [rs stringForColumn:@"title1"];
        
        model.Mdescription = Mdescription;
        model.image = image;
        model.title = title;
        model.play_count = play_count;
        model.ID = id1;
        model.share_count = share_count;
        model.url.m3u8 = m3u8;
        model.channel.avatar = avatar;
        model.channel.background = background;
        model.channel.Mdescription = CMdescription;
        model.channel.title = title1;
        model.channel.ID = id2;
        
    }

    [WmeFMDBTool closeDB];
    return model;
}
+ (NSMutableArray *)findAllMovieArray
{
    [WmeFMDBTool openDB];
    
    
    NSMutableArray *mArray = [[NSMutableArray alloc]init];
    FMResultSet *rs=[db executeQuery:@"select * from testA"];
    while ([rs next])
    {
        WmeTableModel *model = [[WmeTableModel alloc]init];
        WmeChannelModel  *channel = [[WmeChannelModel alloc]init];
        WmeUrL *url = [[WmeUrL alloc]init];
        NSString *m3u8= [rs stringForColumn:@"m3u8"];
        int play_count= [rs intForColumn:@"play_count"];
        int id1 = [rs intForColumn:@"id"];
        int share_count = [rs intForColumn:@"share_count"];
        int id2 = [rs intForColumn:@"id1"];
        NSString *Mdescription = [rs stringForColumn:@"description"];
        NSString *CMdescription = [rs stringForColumn:@"description1"];
        NSString *image = [rs stringForColumn:@"image"];
        NSString *title = [rs stringForColumn:@"title"];
        NSString *avatar = [rs stringForColumn:@"avatar"];
        NSString *background = [rs stringForColumn:@"background"];
        NSString *title1 = [rs stringForColumn:@"title1"];
        
        model.Mdescription = Mdescription;
        model.image = image;
        model.title = title;
        model.play_count = play_count;
        model.ID = id1;
        model.share_count = share_count;
        url.m3u8 = m3u8;
        
        channel.avatar = avatar;
        channel.background = background;
        channel.Mdescription = CMdescription;
        channel.title = title1;
        channel.ID = id2;
        model.channel = channel;
        model.url = url;
        [mArray addObject:model];
    }
    
    [WmeFMDBTool closeDB];
    return mArray;
}
+(BOOL)removeMovie:(WmeTableModel *)model
{
    [WmeFMDBTool openDB];
    if (model!=nil) {
        [db executeUpdate:@"delete from testA where m3u8=?",model.url.m3u8];
        NSLog(@"WmeFMDBTool成功移除数据库");
        [WmeFMDBTool closeDB];
        return YES;
    }
    [WmeFMDBTool closeDB];
    return NO;
    
    
}
@end
