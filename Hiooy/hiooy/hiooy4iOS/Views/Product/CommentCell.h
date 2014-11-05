//
//  CommentCell.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-4-16.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *imgviewPic;
@property (nonatomic, weak) IBOutlet UILabel *lblName;
@property (nonatomic, weak) IBOutlet UILabel *lblContent;
@property (nonatomic, weak) IBOutlet UILabel *lblTime;

+ (CommentCell *)cellFromNib;
- (void)settingCell:(id)data;

@end
