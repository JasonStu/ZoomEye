//
//  WmePlayListTableViewCell.h
//  Watch_Me
//
//  Created by lanou on 15/7/29.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WmeTableModel;
@interface WmePlayListTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *movieImageView;
@property (strong, nonatomic) IBOutlet UILabel *movieTitle;
@property (strong, nonatomic) IBOutlet UILabel *movieDes;
@property (strong, nonatomic) IBOutlet UILabel *moviePlayCount;
@property (strong, nonatomic) IBOutlet UILabel *movieTime;

@property (nonatomic, strong) WmeTableModel *listModel;
@end
