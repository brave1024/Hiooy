//
//  SliderViewController.h
//  hiooy
//
//  Created by 黄磊 on 14-3-17.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  ...<不再使用>

#import <UIKit/UIKit.h>

@interface SliderViewController : BaseViewController

// push处理方式
typedef enum {
    kDisplayLeftView = -1,               // 显示左边的VC
    kDisplayCenterView,                 // 显示中间的VC
    kDisplayRightView,                  // 显示右边的VC
} SliderDisplayView;

@property(nonatomic,copy) NSArray *viewControllers;
// main view controller
@property (nonatomic, strong) IBOutlet UIViewController *centerViewController;
// view controllers under main view controller
@property (nonatomic, strong) IBOutlet UIViewController *leftViewController;
@property (nonatomic, strong) IBOutlet UIViewController *rightViewController;

@property (nonatomic, strong) IBOutlet UIView *viewLeft;
@property (nonatomic, strong) IBOutlet UIView *viewCenter;
@property (nonatomic, strong) IBOutlet UIView *viewRight;

@property (nonatomic, assign) SliderDisplayView curDisplayView;

@property (nonatomic, assign) float activeEdge;     // 可激活滑动的边缘宽度

@property (nonatomic, assign) BOOL canShowRight;    // 是否可滑动显示右边视图，两个视图是不现实右边，三个视图是默认可以显示右边

@property (nonatomic, strong) IBOutlet UIView *borderView;

- (id)initWithViewControllers:(NSArray *)viewControllers;

- (void)showLeftView;
- (void)showCenterView;
- (void)showRightView;

- (void)showCenterViewAnimations:(BOOL)animations;

@end


/** UIViewController extension */
@interface UIViewController (SliderViewController)

@property (nonatomic, strong) UINavigationItem *slideNavItem;

/** Convience method for getting access to the NMSSlidingViewController instance */
- (SliderViewController *)sliderViewController;
- (void)viewWillShow;

@end
