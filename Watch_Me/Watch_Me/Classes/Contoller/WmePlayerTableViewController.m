//
//  WmePlayerTableViewController.m
//  Watch_Me
//
//  Created by lanou on 15/7/29.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "WmePlayerTableViewController.h"
#import "XHPathCover.h"
#import "UIImageView+WebCache.h"
#import "WmeChannelModel.h"
#import "UIButton+WebCache.h"
#import "WmePlayListTableViewCell.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "WmePlayingViewController.h"
#import "WmeUrL.h"
@interface WmePlayerTableViewController ()
@property (nonatomic, strong) XHPathCover *pathCover;
@property (nonatomic, strong) NSMutableArray *listArray;
@end

@implementation WmePlayerTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 25, 30, 30);
    [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn] ;
    self.title =self.listModel.channel.title;
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes =dict;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _pathCover = [[XHPathCover alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 250)];
    [self.pathCover.bannerImageView sd_setImageWithURL:[NSURL URLWithString:self.listModel.channel.background]];
    self.pathCover.bannerImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.pathCover.avatarButton sd_setBackgroundImageWithURL:[NSURL URLWithString:self.listModel.channel.avatar] forState:UIControlStateNormal];
    [_pathCover setInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.listModel.channel.title, XHUserNameKey,self.listModel.channel.Mdescription, XHBirthdayKey, nil]];
    self.tableView.tableHeaderView = self.pathCover;
    __weak WmePlayerTableViewController *wself = self;
    
    [self loadMoreData];
    
    [_pathCover setHandleRefreshEvent:^{
        [wself _refreshing];
    }];
    self.tableView.backgroundColor = [UIColor grayColor];
    self.tableView.contentInset = UIEdgeInsetsMake(-40, 0, 0, 0);
    [self.tableView registerNib:[UINib nibWithNibName:@"WmePlayListTableViewCell" bundle:nil] forCellReuseIdentifier:@"MovieListCell"];
}

- (void)_refreshing {
    // refresh your data sources
    
    __weak WmePlayerTableViewController *wself = self;
    double delayInSeconds = 4.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [wself.pathCover stopRefresh];
    });
}
- (void)loadMoreData
{
    NSString *url = [NSString stringWithFormat:@"http://ditto.short.tv/api/v1/channels/%d/videos",self.listModel.channel.ID];
    AFHTTPSessionManager  *afn = [AFHTTPSessionManager manager];
    __weak WmePlayerTableViewController *W_m = self;
    [afn GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSMutableArray *array = (NSMutableArray *)[WmeTableModel objectArrayWithKeyValuesArray:responseObject];
        [W_m.listArray addObjectsFromArray:array];
        [W_m.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"没有更多的数据了");
    }];
}

-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- scroll delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_pathCover scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [_pathCover scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [_pathCover scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_pathCover scrollViewWillBeginDragging:scrollView];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    
    return self.listArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    CGFloat heightForRowAtIndexPath = 100.0f;
    
    return heightForRowAtIndexPath;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    WmePlayListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieListCell" forIndexPath:indexPath];
    WmeTableModel *model  = self.listArray[indexPath.row];
    cell.listModel = model;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self presentInPlayingVc:indexPath];
}
- (void)presentInPlayingVc:(NSIndexPath *)indexPath
{
    WmePlayingViewController *play = [[WmePlayingViewController alloc]init];
    WmeTableModel *model  = self.listArray[indexPath.row];
    play.url = model.url.m3u8;
    play.title = model.title;
    play.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController presentViewController:play animated:NO completion:nil];
}
-(NSMutableArray *)listArray
{
    if (!_listArray) {
        _listArray = [[NSMutableArray alloc]init];
        
    }
    return _listArray;
}
@end
