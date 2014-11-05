//
//  CartPromotionModel.h
//  hiooy
//
//  Created by retain on 14-5-6.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import "JSONModel.h"

@protocol CartPromotionModel <NSObject>

@end

@interface CartPromotionModel : JSONModel

@property (nonatomic, copy) NSString *name;             // 折扣名称
@property (nonatomic, copy) NSString *discount_amount;  // 折扣金额

@end
