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
@property (weak, nonatomic) IBOutlet UIImageView *movieImageView;
@property (weak, nonatomic) IBOutlet UILabel *movieTitle;
@property (weak, nonatomic) IBOutlet UILabel *movieDes;
@property (weak, nonatomic) IBOutlet UILabel *moviePlayCount;
@property (nonatomic, strong) WmeTableModel *listModel;
@end
