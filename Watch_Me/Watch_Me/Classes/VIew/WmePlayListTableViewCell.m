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
    self.movieTitle.text = [NSString stringWithFormat:@"# %@",listModel.title];
    self.movieDes.text = listModel.channel.title;
    self.moviePlayCount.text = [NSString stringWithFormat:@"☆ %0.2f万",listModel.play_count*0.0001];
    self.movieImageView.layer.masksToBounds = YES;
    self.movieImageView.layer.cornerRadius = 5;
    self.movieTime.text = [self strWithTimeInterval:[listModel.duration intValue]];

    
}
- (NSString *)strWithTimeInterval:(int)interval
{
    int m = interval / 60;
    int s = (int)interval % 60;
    return [NSString stringWithFormat:@"%02d: %02d", m , s];
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
