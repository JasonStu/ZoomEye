//
//  WmeEnShareTableViewCell.m
//  Watch_Me
//
//  Created by lanou on 15/7/30.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "WmeEnShareTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "WmeTableModel.h"
#import "WmeChannelModel.h"
@implementation WmeEnShareTableViewCell
-(void)setEnShareModel:(WmeTableModel *)enShareModel
{
    _enShareModel = enShareModel;
    [self.enShareImageView sd_setImageWithURL:[NSURL URLWithString:enShareModel.image]];
    self.enShareLabel.text = enShareModel.title;

    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
