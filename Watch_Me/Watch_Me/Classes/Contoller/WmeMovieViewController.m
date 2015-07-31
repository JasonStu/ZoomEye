
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
    button.frame = CGRectMake(10, 25, 40, 40);
    [button setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(ClickBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
- (void)ClickBack
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)playMovie:(UIButton *)button
{
    NSLog(@"button点击了");
    [self presentInPlayingVc];
    
}
- (void)presentInPlayingVc
{
    WmePlayingViewController *play = [[WmePlayingViewController alloc]init];
    play.url = self.model.url.m3u8;
    play.title = self.model.title;
    play.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController presentViewController:play animated:NO completion:nil];
}
- (void)touchMe:(UITapGestureRecognizer *)tap
{
     NSLog(@"点击了");
    [self presentInPlayingVc];
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
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"????hight %f", [WmeMovieTableViewCell cellHight:self.model.Mdescription]);
    return [WmeMovieTableViewCell cellHight:self.model.Mdescription];
}
- (void)shareMe:(UIButton *)button
{
    [UMSocialSnsService presentSnsIconSheetView:self appKey:ShareKey shareText:@"#爱ZoomEye，爱分享！#" shareImage:[UIImage imageNamed:@"zoomEye"] shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren, UMShareToDouban, UMShareToEmail, UMShareToSms,  nil] delegate:nil];
}
- (void)enshrine:(UIButton *)button
{
    
    BOOL _isSuccess = [WmeFMDBTool addMovie:self.model];
    if (_isSuccess) {
        NSLog(@"成功");
        cell.enshrine.selected = YES;
        
    }else
    {
        NSLog(@"失败");
        NSLog(@"%@",[WmeFMDBTool findAllMovie].url.m3u8);
        if ([[WmeFMDBTool findM3U8:self.model]isEqualToString:self.model.url.m3u8]) {
           
            BOOL isRemove= [WmeFMDBTool removeMovie:self.model];
            if (isRemove) {
                NSLog(@"成功移除数据库");
                 cell.enshrine.selected = NO;
            }else
            {
                NSLog(@"失败移除数据库");
            }
            
        }
    }
    
}
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
- (void)goAuterHome:(UIButton *)button
{
    WmePlayerTableViewController *player = [[WmePlayerTableViewController alloc]init];
    player.listModel = self.model;
    [self.navigationController pushViewController:player animated:YES];
    NSLog(@"点击了主页");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
