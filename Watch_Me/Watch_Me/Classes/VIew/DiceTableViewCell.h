//
//  DiceTableViewCell.h
//  Dice
//
//  Created by Damien Laughton on 30/10/2014.
//  Copyright (c) 2014 Damien Laughton. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum DiceTableViewCellScrollDirection : NSInteger {
    ScrollDirectionNone = 0,
    ScrollDirectionRight,
    ScrollDirectionLeft,
    ScrollDirectionUp,
    ScrollDirectionDown,
    ScrollDirectionCrazy,
} DiceTableViewCellScrollDirection;

#define DiceTableViewCellDirectionNotification @"DiceTableViewCellDirectionNotification"
#define DiceTableViewMaximumOffset 20.0f
#define DiceTableViewOffsetFactor 0.3f

@interface DiceTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageViewBackground;
@property (weak, nonatomic) IBOutlet UILabel *imageTitle;
@property (weak, nonatomic) IBOutlet UIImageView *auterName;
@property (weak, nonatomic) IBOutlet UILabel *auter;
@property (weak, nonatomic) IBOutlet UILabel *play_count;

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
