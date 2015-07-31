//
//  WmeBaseNavigationController.m
//  Watch_Me
//
//  Created by lanou on 15/7/26.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "WmeBaseNavigationController.h"
#import "WmePlayingViewController.h"
@interface WmeBaseNavigationController ()<UINavigationControllerDelegate>

@end

@implementation WmeBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#warning UINavigationControllerDelegate 代理方法
//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//        if ( [viewController isKindOfClass:[WmeMoviePlayViewController class]]) {
//            
//        } else if ( [navigationController isNavigationBarHidden] ) {
//            
//        }
//}
-(NSUInteger)supportedInterfaceOrientations
{
//    if ([self.visibleViewController isKindOfClass:[WmePlayingViewController class]]) {
//        return UIInterfaceOrientationLandscapeLeft;
//    }
    return UIInterfaceOrientationMaskPortrait;
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
