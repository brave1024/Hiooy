//
//  ProductListCell.m
//  hiooy
//
//  Created by Xia Zhiyong on 14-4-11.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "ProductListCell.h"

@implementation ProductListCell

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

+ (ProductListCell *)cellFromNib
{
    return [[[NSBundle mainBundle] loadNibNamed:@"ProductListCell" owner:nil options:nil] objectAtIndex:0];
}

- (void)settingCell:(id)data
{
    
    
    
}


@end
