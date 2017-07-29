//
//  DSViewTool.h
//  DSVisionTool
//
//  Created by dasen on 2017/7/6.
//  Copyright © 2017年 Dasen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSDetectData.h"
@interface DSViewTool : NSObject

+ (UIImage *)drawImage:(UIImage *)source observation:(VNFaceObservation *)observation pointArray:(NSArray *)pointArray;

+ (UIView *)getRectViewWithFrame:(CGRect)frame;
@end
