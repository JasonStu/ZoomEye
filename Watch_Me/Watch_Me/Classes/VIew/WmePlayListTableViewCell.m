//
//  WmePlayListTableViewCell.m
//  Watch_Me
//
//  Created by lanou on 15/7/29.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "WmePlayListTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "WmeTableModel.h"
#import "WmeChannelModel.h"
@implementation WmePlayListTableViewCell

-(void)setListModel:(WmeTableModel *)listModel
{
    _listModel = listModel;
    [self.movieImageView sd_setImageWithURL:[NSURL URLWithString:self.listModel.image]];
    self.movieTitle.text = listModel.title;
    self.movieDes.text = listModel.channel.title;
    self.moviePlayCount.text = [NSString stringWithFormat:@"☆ %0.2f万",listModel.play_count*0.0001];
    self.movieImageView.layer.masksToBounds = YES;
    self.movieImageView.layer.cornerRadius = 5;
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
