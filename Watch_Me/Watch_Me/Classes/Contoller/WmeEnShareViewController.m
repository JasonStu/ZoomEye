//
//  WmeEnShareViewController.m
//  Watch_Me
//
//  Created by lanou on 15/7/30.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "WmeEnShareViewController.h"
#import "WmeFMDBTool.h"
#import "WmePlayingViewController.h"
#import "WmeEnShareTableViewCell.h"
#import "WmeTableModel.h"
#import "WmeChannelModel.h"
#import "WmeUrL.h"
#import "FRDLivelyButton.h"
@interface WmeEnShareViewController ()
@property (nonatomic, strong) NSMutableArray *enShareArray;
@property (nonatomic, strong) FRDLivelyButton *button;
@end

@implementation WmeEnShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的收藏";
    self.view.backgroundColor = [UIColor grayColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"WmeEnShareTableViewCell" bundle:nil] forCellReuseIdentifier:@"enShareListCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.button = [[FRDLivelyButton alloc] initWithFrame:CGRectMake(0,0,30,28)];
    //    [_button setStyle:kFRDLivelyButtonStyleHamburger animated:YES];
    [_button setStyle:kFRDLivelyButtonStyleArrowLeft animated:YES];
    [_button addTarget:self action:@selector(buttonActionComeBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:_button];
    self.navigationItem.leftBarButtonItem = buttonItem;
//    self.enShareArray = [WmeFMDBTool findAllMovieArray];
    
}
- (void)buttonActionComeBack:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    NSLog(@"%lu",self.enShareArray.count);
    return self.enShareArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    CGFloat heightForRowAtIndexPath = 200.0;
    
    return heightForRowAtIndexPath;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WmeEnShareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"enShareListCell" forIndexPath:indexPath];
    WmeTableModel *model  = self.enShareArray[indexPath.row];
    cell.enShareModel = model;

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self presentInPlayingVc:indexPath];
}
- (void)presentInPlayingVc:(NSIndexPath *)indexPath
{
    WmePlayingViewController *play = [[WmePlayingViewController alloc]init];
    WmeTableModel *model  = self.enShareArray[indexPath.row];
    NSLog(@"%@",model.url.m3u8);
    play.url = model.url.m3u8;
    play.title = model.title;
    play.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController presentViewController:play animated:NO completion:nil];
}

-(NSMutableArray *)enShareArray
{
    if (!_enShareArray) {
        _enShareArray = [NSMutableArray arrayWithArray:[WmeFMDBTool findAllMovieArray]];
    }
    return _enShareArray;
}
@end
