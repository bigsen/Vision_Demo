//
//  VisionTool.h
//  VisionLearn
//
//  Created by dasen on 2017/6/17.
//  Copyright © 2017年 Dasen. All rights reserved.
//
#import <Vision/Vision.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSUInteger,DetectionType) {
    DetectionTypeFace,
    DetectionTypeLandmark,
    DetectTextRectangles,
    DetectFaceRectangles,
    DetectFaceHat,
    DetectTrackObject
};

@interface VisionTool : NSObject

typedef void(^detectImageHandler)(UIView * _Nullable image);
typedef void(^detectRequestHandler)(VNRequest * _Nullable request, NSError * _Nullable error);

@property (nonatomic, strong) UIImage * _Nullable currentImage;
@property (nonatomic, copy) detectRequestHandler _Nullable requestHandler;
@property (nonatomic, copy) detectImageHandler _Nullable imageHandler;

- (void)detectionImageWithType:(DetectionType)type image:(UIImage *_Nullable)image requestHandler:(detectImageHandler  _Nullable )detectImageHandler;

+ (CGRect)convertRect:(CGRect)oldRect imageRect:(CGSize)imageRect;

@end
