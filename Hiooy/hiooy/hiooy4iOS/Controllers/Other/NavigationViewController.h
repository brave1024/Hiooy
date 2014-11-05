//
//  NavigationViewController.h
//  KKMYForU
//
//  Created by 黄磊 on 13-11-22.
//  Copyright (c) 2013年 黄磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigationViewController : UINavigationController

- (void)showBackButtonWith:(UIViewController *)viewController;
- (void)showBackButtonWith:(UIViewController *)viewController andAction:(SEL)action;

@end


/** UIViewController extension */
@interface UIViewController (NavigationViewController)

- (NavigationViewController *)navController;
- (void)backBarClick;

@end

