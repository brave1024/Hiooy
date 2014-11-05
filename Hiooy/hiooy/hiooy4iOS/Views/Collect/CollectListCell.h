//
//  CollectListCell.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-4-11.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectListCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *imgview;
@property (nonatomic, weak) IBOutlet UILabel *lblTitle;
//@property (nonatomic, weak) IBOutlet UILabel *lblPriceMarket;
@property (nonatomic, weak) IBOutlet UILabel *lblPrice;     // 市场价
@property (nonatomic, weak) IBOutlet UILabel *lblMarket;    // 是否上架
@property (nonatomic, weak) IBOutlet UILabel *lblCollect;   // 收藏
@property (nonatomic, weak) IBOutlet UILabel *lblStore;     // 库存

+ (CollectListCell *)cellFromNib;
- (void)settingCell:(id)data;

@end
