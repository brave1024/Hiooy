//
//  AddressView.h
//  hiooy
//
//  Created by retain on 14-4-24.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddressViewDelegate <NSObject>

- (void)selectAddress;

@end

@interface AddressView : UIView

@property (nonatomic, weak) IBOutlet UIImageView *imgviewPic;
@property (nonatomic, weak) IBOutlet UILabel *lblTitle;
@property (nonatomic, weak) IBOutlet UILabel *lblName;
@property (nonatomic, weak) IBOutlet UILabel *lblPhone;
@property (nonatomic, weak) IBOutlet UILabel *lblAddress;
@property (nonatomic, weak) IBOutlet UIButton *btnAddr;
@property (nonatomic, weak) IBOutlet UILabel *lblTip;
@property (nonatomic, assign) id<AddressViewDelegate> delegate;

+ (AddressView *)viewFromNib;
- (void)settingView:(id)data;
- (IBAction)addressBtnTouched:(id)sender;

@end
