//
//  DSLandmark.h
//  DSVisionTool
//
//  Created by dasen on 2017/7/6.
//  Copyright © 2017年 Dasen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Vision/Vision.h>

@interface DSDetectFaceData : NSObject

@property (nonatomic, strong)VNFaceObservation * _Nullable observation;

@property (nonatomic, strong)NSMutableArray * _Nullable allPoints;

// 脸部轮廊
@property (nonatomic, strong) VNFaceLandmarkRegion2D * _Nonnull faceContour;
// 左眼，右眼
@property (nonatomic, strong) VNFaceLandmarkRegion2D * _Nullable leftEye;
@property (nonatomic, strong) VNFaceLandmarkRegion2D * _Nullable rightEye;
// 鼻子，鼻嵴
@property (nonatomic, strong) VNFaceLandmarkRegion2D * _Nullable nose;
@property (nonatomic, strong) VNFaceLandmarkRegion2D * _Nullable noseCrest;
@property (nonatomic, strong) VNFaceLandmarkRegion2D * _Nullable medianLine;
// 外唇，内唇
@property (nonatomic, strong) VNFaceLandmarkRegion2D * _Nullable outerLips;
@property (nonatomic, strong) VNFaceLandmarkRegion2D * _Nullable innerLips;
// 左眉毛，右眉毛
@property (nonatomic, strong) VNFaceLandmarkRegion2D * _Nullable leftEyebrow;
@property (nonatomic, strong) VNFaceLandmarkRegion2D * _Nullable rightEyebrow;
// 左瞳,右瞳
@property (nonatomic, strong) VNFaceLandmarkRegion2D * _Nullable leftPupil;
@property (nonatomic, strong) VNFaceLandmarkRegion2D * _Nullable rightPupil;

@end


@interface DSDetectData : NSObject

// 所有识别的人脸坐标
@property (nonatomic, strong)NSMutableArray * _Nonnull faceAllRect;

// 所有识别的文本坐标
@property (nonatomic, strong)NSMutableArray * _Nonnull textAllRect;

// 所有识别的特征points
@property (nonatomic, strong)NSMutableArray * _Nonnull facePoints;
@end


