//
//  PayProductView.h
//  hiooy
//
//  Created by retain on 14-4-28.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayProductView : UIView

@property (nonatomic, weak) IBOutlet UILabel *lblTitle;
@property (nonatomic, weak) IBOutlet UILabel *lblNumber;

+ (PayProductView *)viewFromNib;

@end
