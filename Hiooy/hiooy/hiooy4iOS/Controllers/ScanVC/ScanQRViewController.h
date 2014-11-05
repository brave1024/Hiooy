//
//  ScanQRViewController.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-3-24.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  二维码扫描

#import <UIKit/UIKit.h>
#import "ZXingObjC.h"
//#import <ZXingObjC/ZXingObjC.h>

@interface ScanQRViewController : BaseViewController <ZXCaptureDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImage *imgPic;

@end
