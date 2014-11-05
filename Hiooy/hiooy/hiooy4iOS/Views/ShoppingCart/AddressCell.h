//
//  AddressCell.h
//  hiooy
//
//  Created by retain on 14-4-25.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartResponseAddressModel.h"

@interface AddressCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *lblName;
@property (nonatomic, weak) IBOutlet UILabel *lblCity;
@property (nonatomic, weak) IBOutlet UILabel *lblStreet;
@property (nonatomic, weak) IBOutlet UIImageView *imgviewSelected;

+ (AddressCell *)cellFromNib;
- (void)settingCell:(id)data;

@end
