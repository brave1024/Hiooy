//
//  RightViewController.h
//  hiooy
//
//  Created by 黄磊 on 14-3-17.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  更多分类new...<已去掉>

#import <UIKit/UIKit.h>
#import "UMSocial.h"

@interface RightViewController : BaseViewController <UMSocialUIDelegate>

@property (nonatomic, strong) IBOutlet UIImageView *imgview;

- (IBAction)QRCodeScanActionTest:(id)sender;
- (IBAction)EncodeActionTest:(id)sender;

- (IBAction)showCenterView:(id)sender;

- (IBAction)memberCenterAction:(id)sender;

- (IBAction)getCategory:(id)sender;

@end


