//
//  CommentView.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-5-19.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StarView.h"

@interface CommentView : UIView

@property (nonatomic, weak) IBOutlet UILabel *lblTitle;
@property (nonatomic, weak) IBOutlet StarView *star;

+ (CommentView *)viewFromNib;
- (void)settingView:(id)data;

@end
