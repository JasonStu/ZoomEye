//
//  WmeOtherViewController.m
//  Watch_Me
//
//  Created by lanou on 15/7/30.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "WmeOtherViewController.h"
#import "FRDLivelyButton.h"
#import "WmeEnShareViewController.h"
#import "WmeAboutMeViewController.h"
#import "SDImageCache.h"
@interface WmeOtherViewController ()<UIAlertViewDelegate>
@property (nonatomic, strong) FRDLivelyButton *button;
@end

@implementation WmeOtherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];

    self.button = [[FRDLivelyButton alloc] initWithFrame:CGRectMake(0,0,30,28)];
//    [_button setStyle:kFRDLivelyButtonStyleHamburger animated:YES];
    [_button setStyle:kFRDLivelyButtonStyleArrowLeft animated:YES];
    [_button addTarget:self action:@selector(buttonActionComeBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:_button];
    self.navigationItem.leftBarButtonItem = buttonItem;
    
    
    
}
- (IBAction)goToShare:(id)sender {
    WmeEnShareViewController *enShare = [[WmeEnShareViewController alloc]init];
//    [self.navigationController presentViewController:enShare animated:YES completion:nil];
    [self.navigationController pushViewController:enShare animated:YES];
    
}
- (IBAction)removeCacer:(id)sender {
    
    UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"提示" message:[self getSize] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [aler show];
    
}
- (void)buttonActionComeBack:(UIButton *)button
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [_button setStyle:kFRDLivelyButtonStyleHamburger animated:YES];
    
}
- (IBAction)aboutMe:(id)sender {
    WmeAboutMeViewController *about = [[WmeAboutMeViewController alloc]init];
    [self.navigationController pushViewController:about animated:YES];
    
}
-(NSString *)getSize
{
    NSInteger size = [[SDImageCache sharedImageCache] getSize];
    
    //        NSLog(@"%ld",size);
    NSString *unit = @"B";
    CGFloat sizeFormater = 0;
    if (size > 1024 * 1024) {
        sizeFormater = (size * 1.0) / 1024 /1024;
        unit = @"M";
    }
    else if(size >  1024)
    {
        sizeFormater = size * 1.0/1024;
        unit = @"KB";
    }
    else{
        sizeFormater = size;
        unit = @"B";
    }
    
    NSString *sizeString = [NSString stringWithFormat:@"%.2f%@",sizeFormater,unit];
    
    NSLog(@"%@",sizeString);
    return sizeString;
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[SDImageCache sharedImageCache]clearDisk];
        [[SDImageCache sharedImageCache]clearMemory];
    }
}
    // Do any additional setup after loading the view from its nib.


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
