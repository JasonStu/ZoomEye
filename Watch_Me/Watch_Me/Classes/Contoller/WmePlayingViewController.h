//
//  WmePlayingViewController.h
//  Watch_Me
//
//  Created by lanou on 15/7/27.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "WmeBaseViewController.h"

@interface WmePlayingViewController : WmeBaseViewController
@property (weak, nonatomic) IBOutlet UILabel *StaryTime;
@property (weak, nonatomic) IBOutlet UISlider *Progress;
@property (weak, nonatomic) IBOutlet UILabel *Alltime;
@property (weak, nonatomic) IBOutlet UIButton *ComeBack;
@property (weak, nonatomic) IBOutlet UILabel *MovieTime;
@property (weak, nonatomic) IBOutlet UIButton *PlayOrPause;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *title;
- (IBAction)TouchComeBack:(id)sender;
- (IBAction)TouchPlayOrPause:(id)sender;
@end
