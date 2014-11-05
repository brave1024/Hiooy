//
//  ProductTypeView.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-5-14.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductTypeView : UIView

@property (nonatomic, weak) IBOutlet UIImageView *imgviewPic;
@property (nonatomic, weak) IBOutlet UILabel *lblContent;

+ (ProductTypeView *)viewFromNib;
- (void)settingView:(id)data;

@end
