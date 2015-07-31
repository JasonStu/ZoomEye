//
//  WmeTableModel.h
//  Watch_Me
//
//  Created by lanou on 15/7/24.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WmeChannelModel;
@class WmeUrL;
@interface WmeTableModel : NSObject
@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *Mdescription;
@property (nonatomic, copy) NSString *duration;
@property (nonatomic, assign) int ID;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, assign) int local_play_count;
@property (nonatomic, assign) int origin_play_count;
@property (nonatomic, copy) NSString *origin_url;
@property (nonatomic, assign) int play_count;
@property (nonatomic, assign) int share_count;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) int weight;
@property (nonatomic, strong) WmeChannelModel *channel;
@property (nonatomic, strong) WmeUrL *url;
@end
