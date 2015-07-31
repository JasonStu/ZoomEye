//
//  WmeMovieViewController.h
//  Watch_Me
//
//  Created by lanou on 15/7/24.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "WmeBaseViewController.h"
@class WmeTableModel;
@interface WmeMovieViewController : WmeBaseViewController
@property (nonatomic, strong) NSString *titleViewUrl;
@property (nonatomic, strong) WmeTableModel *model;
@end
