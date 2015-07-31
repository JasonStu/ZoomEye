//
//  ASFSharedViewTransition.h
//  ASFTransitionTest
//
//  Created by Asif Mujteba on 09/08/2014.
//  Copyright (c) 2014 Asif Mujteba. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol ASFSharedViewTransitionDataSource <NSObject>

- (UIView *)sharedView;

@end

@interface ASFSharedViewTransition : NSObject<UIViewControllerAnimatedTransitioning, UINavigationControllerDelegate>

@property (nonatomic, weak) Class fromVCClass;
@property (nonatomic, weak) Class toVCClass;

+ (void)addTransitionWithFromViewControllerClass:(Class<ASFSharedViewTransitionDataSource>)aFromVCClass
                                  ToViewControllerClass:(Class<ASFSharedViewTransitionDataSource>)aToVCClass
                        WithNavigationController:(UINavigationController *)aNav
                                      WithDuration:(NSTimeInterval)aDuration;

@end
