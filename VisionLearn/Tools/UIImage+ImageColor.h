//
//  UIImage+ImageColor.h
//  iPhoneMiGui
//
//  Created by dasen on 16/7/19.
//  Copyright © 2016年 LEIHONGBEN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageColor)
+ (UIImage*)imageWithColor:(UIColor*)color size:(CGSize)size;
+ (UIImage *)imageFromColor:(UIColor *)color;

- (UIImage *)scaleImage:(CGFloat)width;
@end
