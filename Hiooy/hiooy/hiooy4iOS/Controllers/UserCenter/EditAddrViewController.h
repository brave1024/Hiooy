//
//  EditAddrViewController.h
//  hiooy
//
//  Created by 黄磊 on 14-3-22.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  添加、编辑收货地址

#import <UIKit/UIKit.h>
#import "AddressModel.h"        // 用于返回
#import "AddressItemModel.h"    // 用于请求

@interface EditAddrViewController : BaseViewController <UITextFieldDelegate, UIScrollViewDelegate, UIPickerViewDelegate>
{
    NSMutableArray *arrayEdit;      //存放视图中可编辑的控件
    KeyBoardTopBar *keyboardbar;    //
}

@property (nonatomic, strong) AddressModel *curAddrInfo;
@property (nonatomic, assign) NSInteger editIndex;

@property (nonatomic, weak) IBOutlet UIScrollView *scrollContent;
@property (nonatomic, weak) IBOutlet UITextField *txtfieldName;
@property (nonatomic, weak) IBOutlet UITextField *txtfieldMobile;
@property (nonatomic, weak) IBOutlet UITextField *txtfieldTel;
@property (nonatomic, weak) IBOutlet UITextField *txtfieldZipcode;
@property (nonatomic, weak) IBOutlet UITextField *txtfieldRegion;
@property (nonatomic, weak) IBOutlet UITextField *txtfieldAddr;

@property (nonatomic, weak) IBOutlet UIButton *btnRegion;
@property (nonatomic, strong) IBOutlet UIView *viewPick;
@property (nonatomic, strong) IBOutlet UIPickerView *pickerview;

- (IBAction)selectRegion:(id)sender;
- (IBAction)pickerSelectAction:(id)sender;

@end
