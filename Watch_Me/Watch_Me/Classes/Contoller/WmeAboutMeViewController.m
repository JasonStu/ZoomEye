//
//  WmeAboutMeViewController.m
//  Watch_Me
//
//  Created by lanou on 15/7/31.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "WmeAboutMeViewController.h"
#import "FRDLivelyButton.h"
@interface WmeAboutMeViewController ()
@property (strong, nonatomic) IBOutlet UILabel *aboutMe;
@property (nonatomic, strong) FRDLivelyButton *button;
@end

@implementation WmeAboutMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关于我与它";
    self.aboutMe.text = @"  本app所有内容,包括文字、图⽚、⾳频、视频、软件、程序、以及版式设计等均在网上搜集。\n\n  访问者可将本app提供的内容或服务⽤于个⼈学习、研究或欣赏,以及其他非商业性或非盈利性用途,但同时应遵守著作权法及其他相关法律的规定,不得侵犯本app及相关权利人的合法权利。除此以外,将本app任何内容或服务⽤于其他用途时,须征得本app及相关权利人的书面许可,并支付报酬。\n\n  本app内容原作者如不愿意在本app刊登内容,请及时通知本app,予以删除。 \n\n  姓名:徐杰鸿\n\n  电子邮箱:jason4271735@163.com";
    
    self.button = [[FRDLivelyButton alloc] initWithFrame:CGRectMake(0,0,30,28)];
    //    [_button setStyle:kFRDLivelyButtonStyleHamburger animated:YES];
    [_button setStyle:kFRDLivelyButtonStyleArrowLeft animated:YES];
    [_button addTarget:self action:@selector(buttonActionAboutMeComeBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:_button];
    self.navigationItem.leftBarButtonItem = buttonItem;
    
    // Do any additional setup after loading the view from its nib.
}
- (void)buttonActionAboutMeComeBack:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
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
