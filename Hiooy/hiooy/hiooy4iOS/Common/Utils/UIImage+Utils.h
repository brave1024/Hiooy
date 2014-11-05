//
//  UIImage+Utils.h
//  KKMYForU
//
//  Created by Xia Zhiyong on 13-11-4.
//  Copyright (c) 2013年 Xia Zhiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extensions)

+ (UIImage*)imageFromBundleNamed:(NSString*)filename;
+ (NSString*)imagePathFromBundleNamed:(NSString*)filename;

- (UIImage *)imageAtRect:(CGRect)rect;
- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize;
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;
- (UIImage *)imageByScalingWithScale:(float)targetScale;
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;
- (UIImage *)imageByFillingSize:(CGSize)targetSize;
//- (UIImage *)fixOrientation;

@end
