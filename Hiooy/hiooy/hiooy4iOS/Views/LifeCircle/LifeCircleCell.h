//
//  LifeCircleCell.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-3-28.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  ...<未使用>

#import <UIKit/UIKit.h>

@interface LifeCircleCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *imgview;
@property (nonatomic, weak) IBOutlet UILabel *lblTitle;

+ (LifeCircleCell *)cellFromNib;
- (void)settingCell:(id)cellData;

@end
