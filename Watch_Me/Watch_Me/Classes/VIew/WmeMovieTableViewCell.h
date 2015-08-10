//
//  WmeMovieTableViewCell.h
//  Watch_Me
//
//  Created by lanou on 15/7/26.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WmeTableModel;
@interface WmeMovieTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *movieView;
@property (nonatomic, strong) WmeTableModel *model;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *otherLabel;
@property (nonatomic, strong) UILabel *desLabel;
@property (nonatomic, strong) UIView *buttonView;
@property (nonatomic, strong) UIButton *auterHome;
@property (nonatomic, strong) UIButton *enshrine;
@property (nonatomic, strong) UIButton *share;
@property (nonatomic, strong) UIButton *download;
@property (nonatomic, strong) UIButton *homeView;
+(CGFloat) cellHight:(NSString *)listModel;

@end
