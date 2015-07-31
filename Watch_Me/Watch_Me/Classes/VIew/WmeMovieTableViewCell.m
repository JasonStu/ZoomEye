//
//  WmeMovieTableViewCell.m
//  Watch_Me
//
//  Created by lanou on 15/7/26.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "WmeMovieTableViewCell.h"
#import "Masonry.h"
#import "WmeTableModel.h"
#import "UIImageView+WebCache.h"
#import "WmeChannelModel.h"
#import "Colours.h"
#import "WmeFMDBTool.h"
#import "WmeUrL.h"
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self
#define MovieListWidth ([[UIScreen mainScreen] bounds].size.width)
#define MovieListHeight ([[UIScreen mainScreen] bounds].size.height-20)
@interface WmeMovieTableViewCell ()

@property (nonatomic, strong) UIView *homeView;
@property (nonatomic, strong) UIImageView *nameImage;
@property (nonatomic, strong) UILabel *auterName;
@property (nonatomic, strong) UILabel *enShareLabel;
@property (nonatomic, strong) UILabel *shareLabel;
@property (nonatomic, strong) UILabel *downLabel;

@end
@implementation WmeMovieTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.movieView = [[UIImageView alloc]init];
        [self.contentView addSubview:_movieView];
        self.movieView.contentMode = UIViewContentModeScaleToFill;
        UIVisualEffectView *bgeffect=[[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        bgeffect.frame=CGRectMake(0, 0 , MovieListWidth, MovieListHeight);
        [self.movieView addSubview:bgeffect];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MovieListWidth, MovieListHeight)];
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.5;
        [bgeffect addSubview:view];
        
        self.titleLabel = [[UILabel alloc]init];
        [self.movieView addSubview:_titleLabel];
        self.titleLabel.textColor = [UIColor whiteColor];
//        self.titleLabel.backgroundColor = [UIColor blueColor];
        
        
        
        self.otherLabel = [[UILabel alloc]init];
        [self.movieView addSubview:_otherLabel];
//        self.otherLabel.backgroundColor = [UIColor greenColor];
        self.otherLabel.textColor =[UIColor warningColor];
        
        self.desLabel = [[UILabel alloc]init];
        [self.movieView addSubview:_desLabel];
//        self.desLabel.backgroundColor = [UIColor magentaColor];
        self.desLabel.textColor =[UIColor wheatColor];
        
        self.buttonView = [[UIView alloc]init];
        [self.movieView addSubview:_buttonView];

        
        self.share = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_share];
        [_share setBackgroundImage:[UIImage imageNamed:@"fenxiang"] forState:UIControlStateNormal];

        self.enshrine = [UIButton buttonWithType:UIButtonTypeCustom];;
        [self.contentView addSubview:_enshrine];
        [_enshrine setBackgroundImage:[UIImage imageNamed:@"aixin"] forState:UIControlStateNormal];
        [_enshrine setBackgroundImage:[UIImage imageNamed:@"aixin2"] forState:UIControlStateSelected];
        
        self.download = [UIButton buttonWithType:UIButtonTypeCustom];;
        [self.buttonView addSubview:_download];
        [_download setBackgroundImage:[UIImage imageNamed:@"xiazai"] forState:UIControlStateNormal];
        
        self.homeView = [[UIView alloc]init];
        [self.movieView addSubview:_homeView];
        self.homeView.backgroundColor = [UIColor blackColor];
        self.homeView.alpha = 0.2;
        self.homeView.layer.masksToBounds = YES;
        self.homeView.layer.cornerRadius = 5;
        
        self.nameImage = [[UIImageView alloc]init];
        [self.movieView addSubview:_nameImage];
        self.nameImage.layer.masksToBounds = YES;
        self.nameImage.layer.cornerRadius = 15;
        
        
        self.auterName = [[UILabel alloc]init];
        [self.movieView addSubview:_auterName];

        
        self.auterHome = [UIButton buttonWithType:UIButtonTypeCustom];;
        [self.contentView addSubview:_auterHome];
        [self.auterHome setTitle:@"访问TA的主页" forState:UIControlStateNormal];
        self.auterHome.titleLabel.font =[UIFont systemFontOfSize:13];
        
        self.enShareLabel = [[UILabel alloc]init];
        [self.buttonView addSubview:_enShareLabel];
        _enShareLabel.font = [UIFont systemFontOfSize:14];
        self.enShareLabel.textColor =[UIColor whiteColor];
        
        self.shareLabel = [[UILabel alloc]init];
        [self.buttonView addSubview:_shareLabel];
        _shareLabel.font = [UIFont systemFontOfSize:14];
        self.shareLabel.textColor =[UIColor whiteColor];
        
        self.downLabel = [[UILabel alloc]init];
        [self.buttonView addSubview:_downLabel];
        _downLabel.font = [UIFont systemFontOfSize:14];
        self.downLabel.textColor =[UIColor whiteColor];
        
        
        
       

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    WS(ws);
    [_movieView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.contentView).with.insets(UIEdgeInsetsMake(0,0,0,0));
        make.width.equalTo(@(MovieListWidth));
    }];
    
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.movieView.mas_left).with.offset(10);
        make.top.equalTo(ws.movieView.mas_top).with.offset(10);
        make.width.equalTo(@(MovieListWidth));
        make.height.equalTo(@(20));
    }];
    self.titleLabel.font = [UIFont systemFontOfSize:18];
//    self.titleLabel.font = [UIFont fontWithName:@"SourceHanSansSC-Normal" size:18];
    
    [_otherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.contentView.mas_left).with.offset(10);
        make.top.equalTo(ws.titleLabel.mas_top).with.offset(25);
        make.width.equalTo(@(MovieListWidth));
        make.height.equalTo(@(20));
    }];
    self.otherLabel.font = [UIFont systemFontOfSize:12];

    [_desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.contentView.mas_left).with.offset(10);
        make.right.equalTo(ws.contentView.mas_right).with.offset(-10);
        make.top.equalTo(ws.otherLabel.mas_top).with.offset(25);
        make.width.equalTo(@(MovieListWidth));
    }];
    self.desLabel.font = [UIFont systemFontOfSize:13];
    self.desLabel.numberOfLines = 0;
    
    [_buttonView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.contentView.mas_left).with.offset(10);
        make.right.equalTo(ws.contentView.mas_right).with.offset(-10);
        make.bottom.equalTo(ws.desLabel.mas_bottom).with.offset(50);
        make.width.equalTo(@(MovieListWidth));
        make.height.equalTo (@(40));
    }];
    
    [_enshrine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.buttonView.mas_left).with.offset(10);
        make.top.equalTo(ws.buttonView.mas_top).with.offset(10);
        make.width.equalTo(@(20));
        make.height.equalTo (@(20));
    }];
    
    [_share mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.buttonView.mas_left).with.offset(110);
        make.top.equalTo(ws.buttonView.mas_top).with.offset(10);
        make.width.equalTo(@(20));
        make.height.equalTo (@(20));
    }];
    
    [_download mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.buttonView.mas_left).with.offset(220);
        make.top.equalTo(ws.buttonView.mas_top).with.offset(10);
        make.width.equalTo(@(20));
        make.height.equalTo (@(20));
    }];
    
    
    [_homeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.contentView.mas_left).with.offset(10);
        make.right.equalTo(ws.contentView.mas_right).with.offset(-10);
        make.bottom.equalTo(ws.buttonView.mas_bottom).with.offset(50);
        make.width.equalTo(@(MovieListWidth));
        make.height.equalTo (@(40));
    }];
    
    [_nameImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.homeView.mas_left).with.offset(10);
        make.top.equalTo(ws.homeView.mas_top).with.offset(5);
        make.width.equalTo(@(30));
        make.height.equalTo (@(30));
    }];
    
    [_auterName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.homeView.mas_left).with.offset(45);
        make.top.equalTo(ws.homeView.mas_top).with.offset(5);
        make.width.equalTo(@(100));
        make.height.equalTo (@(30));
    }];
    self.auterName.font = [UIFont systemFontOfSize:14];
    
    [_auterHome mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ws.homeView.mas_right).with.offset(-5);
        make.top.equalTo(ws.homeView.mas_top).with.offset(5);
        make.width.equalTo(@(100));
        make.height.equalTo (@(30));
    }];
    
    [_enShareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.enshrine.mas_left).with.offset(30);
        make.top.equalTo(ws.buttonView.mas_top).with.offset(15);
        make.width.equalTo(@(50));
        make.height.equalTo (@(20));
    }];
    
    [_shareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.share.mas_left).with.offset(30);
        make.top.equalTo(ws.buttonView.mas_top).with.offset(15);
        make.width.equalTo(@(50));
        make.height.equalTo (@(20));
    }];
    
    [_downLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.download.mas_left).with.offset(30);
        make.top.equalTo(ws.buttonView.mas_top).with.offset(15);
        make.width.equalTo(@(50));
        make.height.equalTo (@(20));
    }];
    
}

+(CGFloat) cellHight:(NSString *)listModel
{
    CGRect rect = [listModel boundingRectWithSize:CGSizeMake(MovieListWidth, 100000000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil];
    
    return rect.size.height+70+40+50;
    
}
-(void)setModel:(WmeTableModel *)model
{
    _model = model;
    self.titleLabel.text = model.title;
    
//    self.otherLabel.text = [NSString stringWithFormat:@"#播放:%d / #分享:%d",model.play_count,model.share_count];
    self.otherLabel.text = [NSString stringWithFormat:@"#播放:%d",model.play_count];

    self.desLabel.text = model.Mdescription;
    [self.nameImage sd_setImageWithURL:[NSURL URLWithString:model.channel.avatar]];
    self.auterName.text = model.channel.title;
    [self.movieView sd_setImageWithURL:[NSURL URLWithString:model.image]];
    if ([[WmeFMDBTool findM3U8:model] isEqualToString:model.url.m3u8]) {
        self.enshrine.selected = YES;
    }
    self.enShareLabel.text = [NSString stringWithFormat:@"%d",model.share_count];
    self.shareLabel.text = [NSString stringWithFormat:@"%d",model.origin_play_count];
    self.downLabel.text = [NSString stringWithFormat:@"%d",model.local_play_count];
    [self layoutSubviews];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
