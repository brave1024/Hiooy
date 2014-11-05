//
//  MainViewController.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-3-14.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  主页

#import <UIKit/UIKit.h>

@interface MainViewController : BaseViewController <UIScrollViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView *scrollTop;
@property (nonatomic, strong) IBOutlet UIImageView *imgviewBanner;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) IBOutlet UIView *viewTop;

@property (nonatomic, strong) IBOutlet UIScrollView *scrollContent;
@property (nonatomic, strong) IBOutlet UIView *viewActivitity;
@property (nonatomic, strong) IBOutlet UIImageView *imgviewSecond;      // 秒杀
@property (nonatomic, strong) IBOutlet UIImageView *imgviewGroup;       // 团购
@property (nonatomic, strong) IBOutlet UIImageView *imgviewActivity1;   // 优惠券1
@property (nonatomic, strong) IBOutlet UIImageView *imgviewActivity2;   // 优惠券2

- (IBAction)scanQRAction:(id)sender;
- (IBAction)productTypeSelected:(id)sender;
- (IBAction)groupBuyingAction:(id)sender;
- (IBAction)secondKillAction:(id)sender;

@end
