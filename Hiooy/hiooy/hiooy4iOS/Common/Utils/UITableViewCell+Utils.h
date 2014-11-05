//
//  UITableViewCell+Utils.h
//  KKMYForU
//
//  Created by 黄磊 on 13-11-20.
//  Copyright (c) 2013年 黄磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICustomLineLabel.h"

@protocol TableViewCellDelegate <NSObject>

@end


@interface UITableViewCell (Utils)

@property (nonatomic, assign) id<TableViewCellDelegate> delegate;

- (void)configWithData:(id)data;

@end
