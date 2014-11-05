//
//  ViewController.h
//  hiooy
//
//  Created by Xia Zhiyong on 14-3-14.
//  Copyright (c) 2014年 Xia Zhiyong. All rights reserved.
//  支付宝快捷支付测试

#import <UIKit/UIKit.h>
#import "AlixLibService.h"

@interface Product : NSObject{
@private
	float _price;
	NSString *_subject;
	NSString *_body;
	NSString *_orderId;
}

@property (nonatomic, assign) float price;
@property (nonatomic, retain) NSString *subject;
@property (nonatomic, retain) NSString *body;
@property (nonatomic, retain) NSString *orderId;

@end

@interface ViewController : UIViewController
{
    NSMutableArray *_products;
    SEL _result;
}
@property (nonatomic,assign) SEL result;//这里声明为属性方便在于外部传入。
-(void)paymentResult:(NSString *)result;
@end