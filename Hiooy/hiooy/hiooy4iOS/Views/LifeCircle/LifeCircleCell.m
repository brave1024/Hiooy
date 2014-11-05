//
//  LifeCircleCell.m
//  hiooy
//
//  Created by Xia Zhiyong on 14-3-28.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "LifeCircleCell.h"

@implementation LifeCircleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (LifeCircleCell *)cellFromNib
{
    return [[[NSBundle mainBundle] loadNibNamed:@"LifeCircleCell" owner:nil options:nil] objectAtIndex:0];
}

- (void)settingCell:(id)cellData
{
    self.imgview.image = [UIImage imageNamed:@"80"];
    self.lblTitle.text = @"海印又一城";
    
}


@end
