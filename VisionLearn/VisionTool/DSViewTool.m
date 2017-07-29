//
//  DSViewTool.m
//  DSVisionTool
//
//  Created by dasen on 2017/7/6.
//  Copyright © 2017年 Dasen. All rights reserved.
//
#import "DSViewTool.h"
#import <Vision/Vision.h>
@implementation DSViewTool

+ (UIImage *)drawImage:(UIImage *)image observation:(VNFaceObservation *)observation pointArray:(NSArray *)pointArray{
    
    UIImage *sourceImage = image;
    
    // 遍历所有特征
    for (VNFaceLandmarkRegion2D *landmarks2D in pointArray) {
        
        CGPoint points[landmarks2D.pointCount];
        // 转换特征的所有点
        for (int i=0; i<landmarks2D.pointCount; i++) {
            vector_float2 point = [landmarks2D pointAtIndex:i];
            CGFloat rectWidth = sourceImage.size.width * observation.boundingBox.size.width;
            CGFloat rectHeight = sourceImage.size.height * observation.boundingBox.size.height;
            CGPoint p = CGPointMake(point.x * rectWidth + observation.boundingBox.origin.x * sourceImage.size.width, observation.boundingBox.origin.y * sourceImage.size.height + point.y * rectHeight);
            points[i]  = p;
        }
        
        UIGraphicsBeginImageContextWithOptions(sourceImage.size, false, 1);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [[UIColor greenColor] set];
        CGContextSetLineWidth(context, 2);
        
        // 设置翻转
        CGContextTranslateCTM(context, 0, sourceImage.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        
        // 设置线类型
        CGContextSetLineJoin(context, kCGLineJoinRound);
        CGContextSetLineCap(context, kCGLineCapRound);
        
        // 设置抗锯齿
        CGContextSetShouldAntialias(context, true);
        CGContextSetAllowsAntialiasing(context, true);
        
        // 绘制
        CGRect rect = CGRectMake(0, 0, sourceImage.size.width, sourceImage.size.height);
        CGContextDrawImage(context, rect, sourceImage.CGImage);
        CGContextAddLines(context, points, landmarks2D.pointCount);
        CGContextDrawPath(context, kCGPathStroke);
        
        // 结束绘制
        sourceImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    return sourceImage;
}

+ (UIView *)getRectViewWithFrame:(CGRect)frame{
    
    UIView *boxView = [[UIView alloc]initWithFrame:frame];
    boxView.backgroundColor = [UIColor clearColor];
    
    boxView.layer.borderColor = [UIColor orangeColor].CGColor;
    boxView.layer.borderWidth = 2;
    return boxView;
}

@end
