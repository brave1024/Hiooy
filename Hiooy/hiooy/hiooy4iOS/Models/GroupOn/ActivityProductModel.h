//
//  ActivityProductModel.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-6-9.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ActivityProductModel <NSObject>

@end


@interface ActivityProductModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *product_id;     // 商品id
@property (nonatomic, copy) NSString<Optional> *goods_id;       //
@property (nonatomic, copy) NSString<Optional> *price;          // 价格
@property (nonatomic, copy) NSString<Optional> *spec_info;      // 多规格信息
@property (nonatomic, copy) NSString<Optional> *store;          // 库存

@property (nonatomic, strong) NSString<Optional> *isSelected;   // 是否已选 1:已选 0:未选

@end
