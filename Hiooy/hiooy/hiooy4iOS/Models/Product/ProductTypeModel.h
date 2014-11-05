//
//  ProductTypeModel.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-4-18.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@protocol ProductTypeModel <NSObject>

@end

@interface ProductTypeModel : JSONModel

@property (nonatomic, strong) NSString *product_id;             // 商品id
@property (nonatomic, strong) NSString *price;                  // 商品价格
@property (nonatomic, strong) NSString<Optional> *spec_info;    // 多规格信息
@property (nonatomic, strong) NSString<Optional> *store;        // 库存

@property (nonatomic, strong) NSString<Optional> *isSelected;   // 是否已选 1:已选 0:未选

@end
