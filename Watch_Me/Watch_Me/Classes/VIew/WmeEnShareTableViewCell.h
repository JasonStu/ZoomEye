//
//  WmeEnShareTableViewCell.h
//  Watch_Me
//
//  Created by lanou on 15/7/30.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WmeTableModel;
@interface WmeEnShareTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *enShareImageView;
@property (strong, nonatomic) IBOutlet UILabel *enShareLabel;
@property (nonatomic, strong) WmeTableModel *enShareModel;
@end
