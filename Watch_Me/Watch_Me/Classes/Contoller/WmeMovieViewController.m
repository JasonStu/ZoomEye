
//  WmeMovieViewController.m
//  Watch_Me
//
//  Created by lanou on 15/7/24.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "WmeMovieViewController.h"
#import "WmeMovieTableViewCell.h"
#import "WmeTableModel.h"
#import "WmePlayingViewController.h"
#import "WmeUrL.h"
#import "WmePlayerTableViewController.h"
#import "WmeFMDBTool.h"
#import "UMSocial.h"
#import "Reachability.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#define ShareKey @"5590ae1b67e58ecca200062b"
#define XJHWidth ([[UIScreen mainScreen] bounds].size.width)
#define kImageWidth self.view.bounds.size.width
#define kImageHeight kImageWidth * 0.625
#define XJHHeight ([[UIScreen mainScreen] bounds].size.height)
static CGFloat down = 200;
@interface WmeMovieViewController ()<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate>
{
    WmeMovieTableViewCell *cell;
}
@property (nonatomic, strong) UITableView *MovieTableView;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) NSTimer *ImageZoonOutTimer;
@property (nonatomic, strong) NSTimer *ImageZoonInTimer;


@end

@implementation WmeMovieViewController

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self removeProgressTimer2];
    [self removeProgressTimer];

    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //7.添加定时器
    [self addZoomOutTimer];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //0.重新设置系统自带的右侧手势退出功能
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    //1.设置tableView
    self.MovieTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, XJHWidth, XJHHeight) style:UITableViewStylePlain] ;
    [self.view addSubview:_MovieTableView];
    self.MovieTableView.delegate =self;
    self.MovieTableView.dataSource = self;
    self.MovieTableView.backgroundColor = [UIColor grayColor];
    self.MovieTableView.bounces = YES;
    _MovieTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //2.去除最cell最低端的分割线
    UIView *footViewnil = [[UIView alloc] initWithFrame:CGRectZero];
    [_MovieTableView setTableFooterView:footViewnil];
    
    //3.创建一个ImageView
    self.headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -kImageHeight, kImageWidth, kImageHeight)];
    self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.titleViewUrl]];
    self.headImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchMe:)];
    [_headImageView addGestureRecognizer:tap];
    
    //5.把imageview作为子视图放到tableview的首位
    [self.MovieTableView insertSubview:_headImageView atIndex:0];
    
    //6.设置tableView的内边距，让cell下移动imageView高度的一半
    self.MovieTableView.contentInset = UIEdgeInsetsMake(kImageHeight+50, 0, 0, 0);
    self.MovieTableView.contentOffset =CGPointMake(0, -kImageHeight-50);
    
    UIButton *PlayButton = [[UIButton alloc] initWithFrame:CGRectMake(self.headImageView.center.x-32,self.headImageView.center.y-50, 40, 40)];
    [PlayButton setImage:[UIImage imageNamed:@"bofang2.png"] forState:UIControlStateNormal];
    [self.MovieTableView insertSubview:PlayButton atIndex:1];
    [PlayButton addTarget:self action:@selector(playMovie:) forControlEvents:UIControlEventTouchUpInside];
    
    //设置返回按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, 25, 100, 40);
    [button setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 60);
    [button addTarget:self action:@selector(ClickBack) forControlEvents:UIControlEventTouchUpInside];
//    button.backgroundColor = [UIColor redColor];
    [self.view addSubview:button];
}
#pragma -mark 返回按钮
- (void)ClickBack
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma -mark 网络监测
- (void)WanOR3G
{

    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        MBProgressHUD *mbHub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        // 当网络状态发生改变的时候调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WIFI");
                [self presentInPlayingVc];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                mbHub.margin = 12.0f;
                mbHub.dimBackground = YES;
                mbHub.mode = MBProgressHUDModeText;
                mbHub.labelText = @"当前网络为蜂窝数据!";
                [self performSelector:@selector(presentInPlayingVc) withObject:nil afterDelay:1.5];
                [mbHub hide:YES afterDelay:1];
                NSLog(@"自带网络");
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络");
                break;
                
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络");
                break;
            default:
                break;
        }
    }];
    // 开始监控
    [mgr startMonitoring];

}
#pragma -mark 播放按钮
- (void)playMovie:(UIButton *)button
{
    NSLog(@"button点击了");
    [self WanOR3G];
    
}
#pragma -mark 推进播放页面
- (void)presentInPlayingVc
{
    WmePlayingViewController *play = [[WmePlayingViewController alloc]init];
    play.url = self.model.url.m3u8;
    play.title = self.model.title;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    play.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController presentViewController:play animated:NO completion:nil];
}
#pragma -mark top点击方法
- (void)touchMe:(UITapGestureRecognizer *)tap
{
     NSLog(@"点击了");
//    [self presentInPlayingVc];
    [self WanOR3G];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * cellId = @"Cell";
    cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[WmeMovieTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.backgroundColor = [UIColor grayColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.model = self.model;
    [cell.auterHome addTarget:self action:@selector(goAuterHome:) forControlEvents:UIControlEventTouchUpInside];
    [cell.enshrine addTarget:self action:@selector(enshrine:) forControlEvents:UIControlEventTouchUpInside];
    [cell.share addTarget:self action:@selector(shareMe:) forControlEvents:UIControlEventTouchUpInside];
    [cell.homeView addTarget:self action:@selector(goAuterHome:) forControlEvents:UIControlEventTouchUpInside];
    [cell.download addTarget:self action:@selector(dowload:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return [WmeMovieTableViewCell cellHight:self.model.Mdescription];
}
#pragma -mark 分享按钮
- (void)shareMe:(UIButton *)button
{
    [UMSocialSnsService presentSnsIconSheetView:self appKey:ShareKey shareText:@"#爱ZoomEye，爱分享！#" shareImage:[UIImage imageNamed:@"zoomEye"] shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren, UMShareToDouban, UMShareToEmail, UMShareToSms,  nil] delegate:nil];
}
#pragma -mark 收藏按钮
- (void)enshrine:(UIButton *)button
{
    MBProgressHUD *mbHub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mbHub.margin = 12.0f;
    mbHub.mode = MBProgressHUDModeText;
    BOOL _isSuccess = [WmeFMDBTool addMovie:self.model];
    if (_isSuccess) {
        NSLog(@"成功");
        mbHub.labelText = @"已加入收藏!";
         cell.enshrine.selected = YES;
        [mbHub hide:YES afterDelay:0.5];
    }else
    {
        if ([[WmeFMDBTool findM3U8:self.model]isEqualToString:self.model.url.m3u8]) {
           
            BOOL isRemove= [WmeFMDBTool removeMovie:self.model];
            if (isRemove) {
                NSLog(@"成功移除数据库");
                mbHub.labelText = @"收藏以移除!";
                 cell.enshrine.selected = NO;
                [mbHub hide:YES afterDelay:0.5];
                
            }else
            {
                NSLog(@"失败移除数据库");
            }
            
        }
    }
    
}
#pragma -mark 下载按钮方法
- (void)dowload:(UIButton *)button
{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"此功能暂未开放" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertC animated:YES completion:nil];
//    __weak typeof(alertC) weakAlert = alertC;
    [alertC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
//        [self goAuterHome:nil];
    }]];
    
}
#pragma -mark top自动放大缩小的动画
- (void)changeImageScale
{
 
    if (down == 330) {
        [self removeProgressTimer];
        [self addZoomInTimer];
    }else
    {
        [self zoomOut];
    }
}
- (void)changeImageScale2
{
    if (down == 200) {
        [self removeProgressTimer2];
        [self addZoomOutTimer];
    }else
    {
        [self zoomIn];
    }
     
}
- (void)zoomOut
{
    down +=2;
//    NSLog(@"放大中%f",down);
    CGFloat scale = 1 + down / kImageHeight;
    self.headImageView.frame = CGRectMake(- down / kImageHeight * kImageWidth / 2, - kImageHeight * scale, kImageWidth * scale, kImageHeight * scale);
}
- (void)zoomIn
{
    down -=2;
//    NSLog(@"缩小中%f",down);
    CGFloat scale = 1 + down / kImageHeight;
    self.headImageView.frame = CGRectMake(- down / kImageHeight * kImageWidth / 2, - kImageHeight * scale, kImageWidth * scale, kImageHeight * scale);
}
- (void)addZoomOutTimer
{
    // 2.创建定时器
    self.ImageZoonOutTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(changeImageScale) userInfo:nil repeats:YES];
    // 3.将定时器添加到事件循环
    [[NSRunLoop mainRunLoop] addTimer:self.ImageZoonOutTimer forMode:NSRunLoopCommonModes];
}
- (void)addZoomInTimer
{
    // 2.创建定时器
    self.ImageZoonInTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(changeImageScale2) userInfo:nil repeats:YES];
    // 3.将定时器添加到事件循环
    [[NSRunLoop mainRunLoop] addTimer:self.ImageZoonInTimer forMode:NSRunLoopCommonModes];
}
- (void)removeProgressTimer2;
{
    [self.ImageZoonInTimer invalidate];
    self.ImageZoonInTimer = nil;
}
- (void)removeProgressTimer;
{
    [self.ImageZoonOutTimer invalidate];
    self.ImageZoonOutTimer = nil;
}
#pragma -mark 进入发布者主页
- (void)goAuterHome:(UIButton *)button
{
    WmePlayerTableViewController *player = [[WmePlayerTableViewController alloc]init];
    player.listModel = self.model;
    [self.navigationController pushViewController:player animated:YES];
}


@end
