//
//  WmeTableViewController.m
//  Watch_Me
//
//  Created by lanou on 15/7/24.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "WmeTableViewController.h"
#import "AFNetworking.h"
#import "WmeTableModel.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "DiceTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "WmeChannelModel.h"
#import "WmeUrL.h"
#import "WmeMovieViewController.h"
#import "WmeBaseViewController.h"
#import "WmePlayerTableViewController.h"
#import "FRDLivelyButton.h"
#import "WmeOtherViewController.h"
static int count = 1;
@interface WmeTableViewController ()<UINavigationControllerDelegate>

@property (nonatomic, strong) NSMutableArray *homeArray;
@property (assign, nonatomic) CGPoint lastContentOffset;
@property (nonatomic, strong) WmeTableModel *model;
@property (nonatomic, strong) FRDLivelyButton *button;

@end

@implementation WmeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor grayColor];
  
    self.navigationController.delegate = self;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    // 马上进入刷新状态
    [self.tableView.header beginRefreshing];
//    [self.tableView.footer beginRefreshing];

    [self.tableView registerNib:[UINib nibWithNibName:@"DiceTableViewCell" bundle:nil] forCellReuseIdentifier:@"DiceTableViewCell"];
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes =dict;
    
    self.button = [[FRDLivelyButton alloc] initWithFrame:CGRectMake(0,0,30,28)];
    [_button setStyle:kFRDLivelyButtonStyleHamburger animated:YES];
    [_button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:_button];
    self.navigationItem.leftBarButtonItem = buttonItem;
    
  
    
}
- (void)buttonAction:(UIButton *)button
{
    WmeOtherViewController *other = [[WmeOtherViewController alloc]init];
    [self.navigationController pushViewController:other animated:YES];


}
-(void)loadNewData
{
    
    NSString *url = @"http://ditto.short.tv/api/v1/videos?page=1";
    AFHTTPSessionManager  *afn = [AFHTTPSessionManager manager];
    __weak WmeTableViewController *W_m = self;
    [afn GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSMutableArray *array = (NSMutableArray *)[WmeTableModel objectArrayWithKeyValuesArray:responseObject];
        [W_m.homeArray removeAllObjects];
        [W_m.homeArray addObjectsFromArray:array];
        [W_m.tableView reloadData];
        [W_m.tableView.header endRefreshing ];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [W_m.tableView.header endRefreshing ];
        NSLog(@"没有更多的数据了");
    }];
    count =1;
}
- (void)loadMoreData
{
    
    NSString *url = [NSString stringWithFormat:@"http://ditto.short.tv/api/v1/videos?page=%d",count+1];
    AFHTTPSessionManager  *afn = [AFHTTPSessionManager manager];
    __weak WmeTableViewController *W_m = self;
    [afn GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSMutableArray *array = (NSMutableArray *)[WmeTableModel objectArrayWithKeyValuesArray:responseObject];
        [W_m.homeArray addObjectsFromArray:array];
        [W_m.tableView reloadData];
        [W_m.tableView.footer endRefreshing ];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [W_m.tableView.footer endRefreshing ];
        NSLog(@"没有更多的数据了");
        count =0;
        
    }];
    count++;

}
// 将秒转换为指定格式的字符串
- (NSString *)strWithTimeInterval:(int)interval
{
    int m = interval / 60;
    int s = (int)interval % 60;
    return [NSString stringWithFormat:@"%02d: %02d", m , s];
}
-(NSMutableArray *)homeArray
{
    if (!_homeArray) {
        _homeArray = [NSMutableArray array];
        
    }
    return _homeArray;
}
#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    CGFloat heightForRowAtIndexPath = 200.0f;
    
    return heightForRowAtIndexPath;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    
    return self.homeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    DiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DiceTableViewCell" forIndexPath:indexPath];

    WmeTableModel *model =self.homeArray[indexPath.row];

    [cell.imageViewBackground sd_setImageWithURL:[NSURL URLWithString:model.image]];
    cell.imageTitle.text = [NSString stringWithFormat:@"#%@",model.title];
    cell.auterName.layer.masksToBounds = YES;
    cell.auterName.layer.cornerRadius = 15;
    [cell.auterName sd_setImageWithURL:[NSURL URLWithString:model.channel.avatar]];
    cell.auter.text = model.channel.title;
    cell.play_count.text = [self strWithTimeInterval:[model.duration intValue]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WmeTableModel *model =self.homeArray[indexPath.row];
    WmeMovieViewController *wme = [[WmeMovieViewController alloc]init];
    wme.titleViewUrl = model.image;
    wme.model = model;
    [self.navigationController pushViewController:wme animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    DiceTableViewCellScrollDirection scrollDirection = ScrollDirectionNone;
    
    if (self.lastContentOffset.x > scrollView.contentOffset.x)
    {
        scrollDirection = ScrollDirectionRight;
    }
    else if (self.lastContentOffset.x < scrollView.contentOffset.x)
    {
        scrollDirection = ScrollDirectionLeft;
    }
    else if (self.lastContentOffset.y > scrollView.contentOffset.y)
    {
        scrollDirection = ScrollDirectionDown;
        //        NSLog(@"DOWN");
    }
    else if (self.lastContentOffset.y < scrollView.contentOffset.y)
    {
        scrollDirection = ScrollDirectionUp;
        //        NSLog(@"UP");
    }
    else
    {
        scrollDirection = ScrollDirectionCrazy;
    }
    
    self.lastContentOffset = scrollView.contentOffset;
    
    id notificationObject = [NSNumber numberWithInteger:scrollDirection];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:DiceTableViewCellDirectionNotification object:notificationObject];
    
    
}
#warning UINavigationControllerDelegate 代理方法
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ( [viewController isKindOfClass:[WmeMovieViewController class]]) {
        [navigationController setNavigationBarHidden:YES animated:animated];
        [self.navigationController.view bringSubviewToFront:self.navigationController.navigationBar];
    } else if ( [navigationController isNavigationBarHidden] ) {
        [navigationController setNavigationBarHidden:NO animated:animated];
    }
}
-(WmeTableModel *)model
{
    if (!_model) {
        _model = [[WmeTableModel alloc]init];
        
    }
    return _model;
}
//-(BOOL)shouldAutorotate
//{
//    return YES;
//}
//-(NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskPortrait;
//}
@end
