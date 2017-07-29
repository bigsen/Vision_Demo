//
//  DSVisionTool.h
//  DSVisionTool
//
//  Created by dasen on 2017/7/5.
//  Copyright © 2017年 Dasen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSDetectData.h"
#import "DSViewTool.h"
#import <AVFoundation/AVFoundation.h>
typedef void(^detectImageHandler)(DSDetectData * __nullable detectData);

typedef NS_ENUM(NSUInteger,DSDetectionType) {
    DSDetectionTypeFace,     // 人脸识别
    DSDetectionTypeLandmark, // 特征识别
    DSDetectionTypeTextRectangles,  // 文字识别
    DSDetectionTypeFaceHat,
    DSDetectionTypeFaceRectangles
};

@interface DSVisionTool : NSObject

/// 转换坐标与大小
+ (CGRect)convertRect:(CGRect)oldRect imageSize:(CGSize)imageSize;

/// 识别图片
+ (void)detectImageWithType:(DSDetectionType)type image:(UIImage *_Nullable)image complete:(detectImageHandler _Nullable )complete;

@end
