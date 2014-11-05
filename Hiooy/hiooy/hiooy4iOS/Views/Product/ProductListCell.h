//
//  ProductListCell.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-4-11.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductListCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *imgview;
@property (nonatomic, weak) IBOutlet UILabel *lblTitle;
@property (nonatomic, weak) IBOutlet UILabel *lblPriceMarket;
@property (nonatomic, weak) IBOutlet UILabel *lblPrice;

+ (ProductListCell *)cellFromNib;
- (void)settingCell:(id)data;

@end
