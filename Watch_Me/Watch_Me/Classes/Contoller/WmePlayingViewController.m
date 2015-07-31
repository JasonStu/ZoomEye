//
//
//  Watch_Me
//
//  Created by lanou on 15/7/27.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "WmePlayingViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIView+Extension.h"
#import "MBProgressHUD.h"
static double moveTime = 0;

@interface WmePlayingViewController ()<MBProgressHUDDelegate>
{
    BOOL _Hidden;
    CMTime _time;
}
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tap;
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UIView *bottonView;
@property (weak, nonatomic) IBOutlet UIView *TopView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *ActivityIndicatorView;
@property (weak, nonatomic) IBOutlet UIView *bottomBackgroundColorView;
@property (weak, nonatomic) IBOutlet UIView *topBackgroundColorView;
@property (nonatomic,strong) AVPlayer *player;//播放器对象
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *PanController;
@property (nonatomic, strong) NSTimer *watchTouch;
@property (nonatomic,strong) AVPlayer *av;
@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation WmePlayingViewController



-(void)viewWillDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self removeObserverFromPlayerItem:self.player.currentItem];
    [self removeNotification];
    [self removeTimer];
    [self.player removeTimeObserver:self.av];
    self.player = nil;
}
- (void)viewDidAppear:(BOOL)animated
{
     [self recycleOrShow:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self.player play];
    _Hidden = NO;
    [self addNotification];

    
   
    
    // Do any additional setup after loading the view from its nib.
}

-(void)setupUI{
    //创建播放器层
    AVPlayerLayer *playerLayer=[AVPlayerLayer playerLayerWithPlayer:self.player];
    playerLayer.backgroundColor = [UIColor blackColor].CGColor;
    playerLayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    playerLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;//视频填充模式
    [self.container.layer addSublayer:playerLayer];
    [self.Progress setThumbImage:[UIImage imageNamed:@"point"] forState:UIControlStateNormal];
    [self.Progress setThumbImage:[UIImage imageNamed:@"point"] forState:UIControlStateHighlighted];
    self.MovieTime.text = self.title;
    self.Alltime.text = @"00:00";
    self.StaryTime.text= @"00:00";
    
    
    
}


/**z
 *  初始化播放器
 *
 *  @return 播放器对象
 */
-(AVPlayer *)player{
    if (!_player) {
        AVPlayerItem *playerItem=[self getPlayItem];
        _player=[AVPlayer playerWithPlayerItem:playerItem];
       
        [self addProgressObserver];
        [self addObserverToPlayerItem:playerItem];
        [self.ActivityIndicatorView startAnimating];
    }
    return _player;
}
/**
 *  根据视频索引取得AVPlayerItem对象
 *
 *  @param videoIndex 视频顺序索引
 *
 *  @return AVPlayerItem对象
 */
-(AVPlayerItem *)getPlayItem{
//    NSLog(@"%@",self.url);
//    if (self.url!=nil) {
//       
//
//    }else
//    {
//        NSLog(@"播放失败%s%d",__FUNCTION__,__LINE__);
//    }
//    return nil;
    
    
    NSString *urlStr=self.url;
    urlStr =[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url=[NSURL URLWithString:urlStr];
    AVPlayerItem *playerItem=[AVPlayerItem playerItemWithURL:url];
    return playerItem;
  }

#pragma mark - 通知
/**
 *  添加播放器通知
 */
-(void)addNotification{
    //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerERROR:) name:AVPlayerItemFailedToPlayToEndTimeNotification object:self.player.currentItem];
}

-(void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - 监控
/**
 *  给播放器添加进度更新
 */
-(void)addProgressObserver{
    AVPlayerItem *playerItem=self.player.currentItem;
    UISlider *slider=self.Progress;
    //这里设置每秒执行一次
    __weak WmePlayingViewController * vc = self;
    self.av = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float current=CMTimeGetSeconds(time);
        float total=CMTimeGetSeconds([playerItem duration]);
        moveTime = current;
        NSLog(@"当前已经播放%.2fs.",current);
        vc.StaryTime.text = [vc strWithTimeInterval:(int)current];
        if (current) {
            [slider setValue:current/total animated:YES];
        }
    }];
    
}
/**
 *  给AVPlayerItem添加监控
 *
 *  @param playerItem AVPlayerItem对象
 */
-(void)addObserverToPlayerItem:(AVPlayerItem *)playerItem{
    //监控状态属性，注意AVPlayer也有一个status属性，通过监控它的status也可以获得播放状态
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //监控网络加载情况属性
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}
-(void)removeObserverFromPlayerItem:(AVPlayerItem *)playerItem{
    [playerItem removeObserver:self forKeyPath:@"status"];
    [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
}
- (void)playErrorHud
{
    [self.ActivityIndicatorView setHidden:YES];
    self.hud.labelText = @"网络异常,请稍后再试";
    [self.hud show:YES];
    [self.hud hide:YES afterDelay:3];
}
/**
 *  通过KVO监控播放器状态
 *
 *  @param keyPath 监控属性
 *  @param object  监视器
 *  @param change  状态改变
 *  @param context 上下文
 */
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    AVPlayerItem *playerItem=object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status= [[change objectForKey:@"new"] intValue];
        if(status==AVPlayerStatusReadyToPlay){
//            NSLog(@"正在播放...，视频总长度:%.2f",CMTimeGetSeconds(playerItem.duration));
            _time.value =CMTimeGetSeconds(playerItem.duration);
            self.Alltime.text = [self strWithTimeInterval:(int)CMTimeGetSeconds(playerItem.duration)];
            [self.ActivityIndicatorView stopAnimating];
            [self.ActivityIndicatorView setHidden:YES];
        }else if (status ==AVPlayerItemStatusFailed )
        {
            [self playErrorHud];
            NSLog(@"播放失败");
        }
    }else if([keyPath isEqualToString:@"loadedTimeRanges"]){
        NSArray *array=playerItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
//        NSLog(@"共缓冲：%.2f",totalBuffer);
    }
}

- (IBAction)TouchComeBack:(id)sender {
     self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)TouchPlayOrPause:(id)sender {
    
    if(self.player.rate==0){ //说明时暂停
        [self.player play];
        self.PlayOrPause.selected = NO;
        [self recycleOrShow:nil];
    }else if(self.player.rate==1){//正在播放
        [self.player pause];
        self.PlayOrPause.selected = YES;
    }
}

/**
 *  播放完成通知
 *
 *  @param notification 通知对象
 */
-(void)playbackFinished:(NSNotification *)notification{
    NSLog(@"视频播放完成.");
    [self noHeidden];

    [self removeNotification];
}
/**
 *  播放失败通知
 *
 *  @return <#return value description#>
 */
- (void)playerERROR:(NSNotification *)notification{
    NSLog(@"播放失败");
}
/**
 *  点击手势收缩控件
 */
- (void)heidden
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [UIView animateWithDuration:0.5 animations:^{
        self.TopView.y = -self.TopView.height;
        self.bottonView.y = window.height;
        self.topBackgroundColorView.y = -self.topBackgroundColorView.height;
        self.bottomBackgroundColorView.y = window.height;
        self.PlayOrPause.hidden = YES;
        
    }];
    _Hidden = YES;

}
-(void)noHeidden
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [UIView animateWithDuration:0.5 animations:^{
        self.TopView.y = 0;
        self.bottonView.y = window.height- self.bottonView.height;
        self.topBackgroundColorView.y = 0;
        self.bottomBackgroundColorView.y = window.height- self.bottomBackgroundColorView.height;
        self.PlayOrPause.hidden = NO;
        if (self.PlayOrPause.selected == NO) {
            [self addTimer];
        }
    }];
    _Hidden = NO;
}
- (IBAction)recycleOrShow:(UITapGestureRecognizer *)sender {
    NSLog(@"点击了");;
    if (_Hidden ==NO) {

        [self heidden];
        
    }else
    {
        [self noHeidden];
    }
   
}

- (NSTimer *)watchTouch
{
    if (!_watchTouch) {
        self.watchTouch = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(UserHowToDo) userInfo:nil repeats:NO];
    }
    return _watchTouch;
}

- (void)addTimer
{
    // 2.创建定时器
    [self.watchTouch setFireDate:[NSDate dateWithTimeIntervalSinceNow:3]];
}

- (void)removeTimer;
{
    [self.watchTouch invalidate];
    self.watchTouch = nil;
}
- (void)UserHowToDo
{
    NSLog(@"正在使用计时器");
    if (self.player.rate == 1) {
        NSLog(@"计时器以消除");
        [self heidden];
        [self removeTimer];
    }else
    {
        [self removeTimer];
         NSLog(@"没有播放计时器以消除");

    }
}
- (IBAction)ControllerMovieTime:(id)sender {

    if (self.PlayOrPause.selected == NO) {
        [self.player pause];
        int time = self.Progress.value * _time.value;
//        NSLog(@"%d",time);
       [self.player seekToTime:CMTimeMakeWithSeconds(time, self.player.currentTime.timescale)];
        [self.player play];
    }else if (self.PlayOrPause.selected == YES)
    {
        [self.player pause];
        int time = self.Progress.value * _time.value;
        
        [self.player seekToTime:CMTimeMakeWithSeconds(time, self.player.currentTime.timescale)];

    }
    
}
#define H (ABS(point.x/point.y)>1.5) //水平
#define V (ABS(point.y/point.x)>1.5) //垂直

- (IBAction)PanControllerMovieTime:(UIPanGestureRecognizer *)sender {

    static double pointY = 0.5;
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        pointY = self.player.volume;
    }
    // 1.获得当前拖拽的位置
    // 获取到滑块平移的位置
    CGPoint point =  [sender translationInView:sender.view];
//    NSLog(@"%f",point.x);
//    NSLog(@"----拖拽百分比%f",point.x/self.container.width);
    
    if (H) {
        [self.player pause];
        int ac = point.x*0.3;
        int time = ac/self.container.width * _time.value+moveTime;
        
        if (time<0) {
            [self.player seekToTime:CMTimeMakeWithSeconds(0, self.player.currentTime.timescale)];
            self.Progress.value = 0;
        }else
        {
            [self.player seekToTime:CMTimeMakeWithSeconds(time, self.player.currentTime.timescale)];
        }
        if (self.PlayOrPause.selected == NO) {
            [self.player play];
        }

    }else if (V)
    {
        ;
        CGFloat volome = -point.y / self.container.height+pointY;
        
        if (volome <0) {
           
            self.player.volume = 0;
        }else if (volome > 1 )
        {
            self.player.volume = 1;
        }else
        {
            self.player.volume = volome;
            NSLog(@"%f",volome);

           
           
        }
    
        
    }
    
    
}
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [self TouchComeBack:hud];
}
-(MBProgressHUD *)hud
{
    if (!_hud) {
        _hud = [[MBProgressHUD alloc]initWithView:self.view];
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.delegate = self;
        [self.view addSubview:_hud];
    }
    return _hud;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeLeft;
}
- (BOOL)shouldAutorotate
{
    return YES;
}
@end
