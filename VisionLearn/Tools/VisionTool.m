//
//  VisionTool.m
//  VisionLearn
//
//  Created by dasen on 2017/6/17.
//  Copyright © 2017年 Dasen. All rights reserved.
//

#import "VisionTool.h"



@implementation VisionTool

// 静态图像处理
- (void)detectionImageWithType:(DetectionType)type image:(UIImage *_Nullable)image requestHandler:(detectImageHandler  _Nullable )detectImageHandler
{
    _currentImage = image;
    _imageHandler = detectImageHandler;
    
    // 转换CIImage
    CIImage *convertImag = [[CIImage alloc]initWithImage:image];
    
    // 创建处理Handler
    VNImageRequestHandler *detectRequestHandler = [[VNImageRequestHandler alloc]initWithCIImage:convertImag options:@{}];
   __block VNImageBasedRequest *detectRequest = [[VNImageBasedRequest alloc]init];
    
   __weak typeof(self)wself = self;
    [self setRequestHandler:^(VNRequest *request, NSError * _Nullable error) {
        NSArray *observation = request.results;
        [wself handleImageWithType:type observation:observation];
    }];
    
    // 根据类型进行处理
    switch (type) {
        case DetectionTypeFace:
        {
            // 创建人脸识别Request
            detectRequest = [[VNDetectFaceRectanglesRequest alloc]initWithCompletionHandler:self.requestHandler];
        }
            break;
        case DetectionTypeLandmark:
        {
            // 创建特征识别request
            detectRequest =  [[VNDetectFaceLandmarksRequest alloc]initWithCompletionHandler:self.requestHandler];
            break;
        }
        case DetectTextRectangles:
        {
            // 创建文本识别request
            detectRequest = [[VNDetectTextRectanglesRequest alloc]initWithCompletionHandler:self.requestHandler];
            [detectRequest setValue:@(YES) forKey:@"reportCharacterBoxes"];
            break;
        }
        default:
            break;
    }
    
    // 发送识别请求
    [detectRequestHandler performRequests:@[detectRequest] error:nil];
}

- (void)handleImageWithType:(DetectionType)type observation:(NSArray *)observation{
    switch (type) {
        case DetectionTypeFace:
        {
            [self addShapesToFace:observation];
        }
            break;
        case DetectionTypeLandmark:
        {
            [self addToFace:observation];
        }
        case DetectTextRectangles:
        {
            [self addTextRectangles:observation];
        }
        default:
            break;
    }
}

- (void)addTextRectangles:(NSArray *)observations{
    for (VNTextObservation *observation  in observations) {
        for (VNRectangleObservation *box in observation.characterBoxes) {
            // CreateBoxView
            CGRect newRect = [VisionTool convertRect:box.boundingBox imageRect:self.currentImage.size];
            UIView *boxView = [self getShowViewWithFrame:newRect];
            self.imageHandler(boxView);
        }
    }
}

/// 添加特征
- (void)addToFace:(NSArray *)observations{
    
    for (VNFaceObservation *observation  in observations) {
        
        VNFaceLandmarks2D *landmarks = observation.landmarks;
        NSMutableArray *landmarkRegions = [NSMutableArray array];
        // 脸部轮廊
        [landmarkRegions addObject:landmarks.faceContour];
        
        // 左眼，右眼
        [landmarkRegions addObject:landmarks.leftEye];
        [landmarkRegions addObject:landmarks.rightEye];
        
        // 鼻子，鼻嵴
        [landmarkRegions addObject:landmarks.nose];
        [landmarkRegions addObject:landmarks.noseCrest];
        
        // 中线
        [landmarkRegions addObject:landmarks.medianLine];
        
        // 外唇，内唇
        [landmarkRegions addObject:landmarks.outerLips];
        [landmarkRegions addObject:landmarks.innerLips];
        
        // 左眉毛，右眉毛
        [landmarkRegions addObject:landmarks.leftEyebrow];
        [landmarkRegions addObject:landmarks.rightEyebrow];
        
        // 左瞳,右瞳
        [landmarkRegions addObject:landmarks.leftPupil];
        [landmarkRegions addObject:landmarks.rightPupil];
        
        [self drawOnImage:self.currentImage boundingRect:observation.boundingBox faceLandmarkRegions:landmarkRegions];
    }
    
    self.imageHandler((UIView *)self.currentImage);
}

// 绘制面部特征
- (void)drawOnImage:(UIImage *)source boundingRect:(CGRect)boundingRect faceLandmarkRegions:(NSMutableArray *)faceLandmarkRegions{
    
    // 开启图片上下文与设置基本属性
    UIGraphicsBeginImageContextWithOptions(source.size, false, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor greenColor] set];
    
    CGContextTranslateCTM(context, 0, source.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineCap(context, kCGLineCapRound);
    
    CGContextSetShouldAntialias(context, true);
    CGContextSetAllowsAntialiasing(context, true);
    
    CGFloat rectWidth = source.size.width * boundingRect.size.width;
    CGFloat rectHeight = source.size.height * boundingRect.size.height;
    
    CGRect rect = CGRectMake(0, 0, source.size.width, source.size.height);
    CGContextDrawImage(context, rect, source.CGImage);
    
    CGContextFillPath(context);
    
    // 绘制面部特征
    CGContextSetLineWidth(context, 2);
    
    for (VNFaceLandmarkRegion2D *faceLandmarkRegion in faceLandmarkRegions) {
        CGPoint points [faceLandmarkRegion.pointCount];
        
        for (int i=0; i<faceLandmarkRegion.pointCount; i++) {
            vector_float2 point = [faceLandmarkRegion pointAtIndex:i];
            CGPoint p = CGPointMake(point.x * rectWidth + boundingRect.origin.x * source.size.width, boundingRect.origin.y * source.size.height + point.y * rectHeight);
            points[i]  = p;
        }
        
        CGContextAddLines(context, points, faceLandmarkRegion.pointCount);
        CGContextDrawPath(context, kCGPathStroke);
    }
    // 结束绘制
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.currentImage = image;
}

/// 添加矩形
- (void)addShapesToFace:(NSArray *)observations{
    for (VNFaceObservation *observation  in observations) {
        CGRect newRect = [VisionTool convertRect:observation.boundingBox imageRect:self.currentImage.size];
        UIView *boxView = [self getShowViewWithFrame:newRect];
        self.imageHandler(boxView);
    }
}

///  Rect 转换
+ (CGRect)convertRect:(CGRect)oldRect imageRect:(CGSize)imageRect{
    
    CGFloat w = oldRect.size.width * imageRect.width;
    CGFloat h = oldRect.size.height * imageRect.height;
    CGFloat x = oldRect.origin.x * imageRect.width;
    CGFloat y = imageRect.height - (oldRect.origin.y * imageRect.height) - h;
    
    return CGRectMake(x, y, w, h);
}

- (UIView *)getShowViewWithFrame:(CGRect)frame{
    
    UIView *boxView = [[UIView alloc]initWithFrame:frame];
    boxView.layer.borderColor = [UIColor orangeColor].CGColor;
    boxView.layer.borderWidth = 1;
    boxView.backgroundColor = [UIColor clearColor];
    return boxView;
}




@end
