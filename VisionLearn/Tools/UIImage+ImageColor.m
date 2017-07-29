//
//  UIImage+ImageColor.m
//  iPhoneMiGui
//
//  Created by dasen on 16/7/19.
//  Copyright © 2016年 LEIHONGBEN. All rights reserved.
//

#import "UIImage+ImageColor.h"

@implementation UIImage (ImageColor)
+ (UIImage*)imageWithColor:(UIColor*)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

// 生成透明图片
+ (UIImage *)imageFromColor:(UIColor *)color{
    
    CGRect rect = CGRectMake(0, 0, 10, 10);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext(); return img;
}

//图片压缩到指定大小
- (UIImage *)scaleImage:(CGFloat )width {
    

    CGFloat height = self.size.height * width / self.size.width;
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [self drawInRect:CGRectMake(0, 0, width, height)];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    NSData *tempData = UIImageJPEGRepresentation(result, 0.5);
    return [UIImage imageWithData:tempData];
}
@end
