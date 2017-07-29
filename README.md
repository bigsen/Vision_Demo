北京时间2017.6.6日凌晨1点，新一届的WWDC召开，苹果在大会上发布了iOS11的beta版，伴随着iOS 11的发布，也随之推出了一些新的API，如：ARKit 、Core ML、FileProvider、IdentityLookup 、Core NFC、Vison 等。

本篇文章主要简单介绍下其中的 Vision API 的使用（Vision更强大的地方是可以结合Core ML模型实现更强大的功能，本篇文章就不详细展开了）

## Vison 与 Core ML 的关系
Vision 是 Apple 在 WWDC 2017 推出的图像识别框架。

Core ML 是 Apple 在 WWDC 2017 推出的机器学习框架。


###Core ML
![](http://ata2-img.cn-hangzhou.img-pub.aliyun-inc.com/290b0d7ef09c756778dc7290c99afbdf.png)
根据这张图就可以看出，Core ML的作用就是将一个Core ML模型，转换成我们的App工程可以直接使用的对象,就是可以看做是一个模型的转换器。

Vision在这里的角色，就是相当于一个用于识别Core ML模型的一个角色.

###Vision
![screenshot.png](http://ata2-img.cn-hangzhou.img-pub.aliyun-inc.com/de139e61941d5829bfef3059fac620bc.png)

* 根据官方文档看，Vision 本身就有Face Detection and Recognition(人脸检测识别)、Machine Learning Image Analysis(机器学习图片分析)、Barcode Detection(条形码检测)、Text Detection(文本检测)。。。。。等等这些功能。

* 所以可以这样理解：
Vision库里本身就已经自带了很多训练好的Core ML模型，这些模型是针对上面提到的人脸识别、条形码检测等等功能，如果你要实现的功能刚好是Vision库本身就能实现的，那么你直接使用Vision库自带的一些类和方法就行，但是如果想要更强大的功能，那么还是需要结合其它Core ML模型。

###Vision 与 Core ML 总结
![](http://ata2-img.cn-hangzhou.img-pub.aliyun-inc.com/eeffaea665cc9ed972b4bfc2b5edf642.png)

* Core ML可以看做一个模型的转换器，可以将一个 ML Model 格式的模型文件自动生成一些类和方法，可以直接使用这些类去做分析，让我们更简单的在app中使用训练好的模型。

* Vision本身就是能对图片做分析，他自带了针对很多检测的功能，相当于内置了一些Model，另外Vision也能使用一个你设置好的其它的Core ML Model来对图进行分析。

* Vision就是建立在Core ML层之上的，使用Vision其实还是用到了Core ML，只是没有显式地直接写Core ML的代码而已。

## Vison 的应用场景
* 图像配准

* 矩形检测
![](http://ata2-img.cn-hangzhou.img-pub.aliyun-inc.com/35c2c9e96a561f00cefdaa25b8b1924d.png)
* 二维码/条形码检测
![](http://ata2-img.cn-hangzhou.img-pub.aliyun-inc.com/eda92e9ea6e615bd4fb2d82edcef466b.png)

* 目标跟踪：脸部，矩形和通用模板
![](http://ata2-img.cn-hangzhou.img-pub.aliyun-inc.com/86620cc43d04773f0acd6c9b8f6a8360.gif)
* 文字检测：监测文字外框，和文字识别
![](http://ata2-img.cn-hangzhou.img-pub.aliyun-inc.com/d622c663818d421c9e6fd7be22750494.png)
* 人脸检测：支持检测笑脸、侧脸、局部遮挡脸部、戴眼镜和帽子等场景，可以标记出人脸的矩形区域
![](http://ata2-img.cn-hangzhou.img-pub.aliyun-inc.com/7d1bc8fddf40a07aeba4b9adcf85083d.png)
* 人脸特征点：可以标记出人脸和眼睛、眉毛、鼻子、嘴、牙齿的轮廓，以及人脸的中轴线
![](http://ata2-img.cn-hangzhou.img-pub.aliyun-inc.com/56d666b182f8bb62ef03360f35cec58d.png)

## Vison 的设计理念
苹果最擅长的，把复杂的事情简单化，Vision的设计理念也正是如此。
对于使用者我们抽象的来说，我们只需要：提出问题-->经过机器-->得到结果。

开发者不需要是计算机视觉专家，开发者只需要得到结果即可，一切复杂的事情交给Vision。
![](http://ata2-img.cn-hangzhou.img-pub.aliyun-inc.com/a00f95919e87e4b9047c6753076fe4e8.png)

## Vison 的性能对比
Vision 与 iOS 上其他几种带人脸检测功能框架的对比：
![](http://ata2-img.cn-hangzhou.img-pub.aliyun-inc.com/dadc4904590e66ae87f5bb293066d746.png)
根据官方提供的资料可以看出来，Vision 和 Core Image、AV Capture 在精确度，耗时，耗电量来看基本都是Best、Fast、Good。

###Vision 支持的图片类型
Vision 支持多种图片类型，如：
* CIImage

* NSURL

* NSData

* CGImageRef

* CVPixelBufferRef

## Vison 的使用 与结构图
Vision使用中的角色有：
Request，RequestHandler，results和results中的Observation数组。

Request类型：
有很多种，比如图中列出的 人脸识别、特征识别、文本识别、二维码识别等。
###结果图
![screenshot.png](http://ata2-img.cn-hangzhou.img-pub.aliyun-inc.com/14d45583a62aec9bbaf345b88c394a67.png)

**使用概述：**
我们在使用过程中是给各种功能的 Request 提供给一个 RequestHandler，Handler 持有需要识别的图片信息，并将处理结果分发给每个 Request 的 completion Block 中。可以从 results 属性中得到 Observation 数组。

observations数组中的内容根据不同的request请求返回了不同的observation，如：VNFaceObservation、VNTextObservation、VNBarcodeObservation、VNHorizonObservation，不同的Observation都继承于VNDetectedObjectObservation，而VNDetectedObjectObservation则是继承于VNObservation。每种Observation有boundingBox，landmarks等属性，存储的是识别后物体的坐标，点位等，我们拿到坐标后，就可以进行一些UI绘制。

###具体人脸识别使用示例：
1，创建处理图片处理对应的RequestHandler对象。

```
// 转换CIImage
CIImage *convertImage = [[CIImage alloc]initWithImage:image];

// 创建处理requestHandler
VNImageRequestHandler *detectRequestHandler = [[VNImageRequestHandler alloc]initWithCIImage:convertImage options:@{}];
```

2， 创建回调Handler。（用于识别成功后进行回调执行的一个Block）

```
// 设置回调
CompletionHandler completionHandler = ^(VNRequest *request, NSError * _Nullable error) {
NSArray *observations = request.results;
};
```

3， 创建对应的识别 Request 请求，指定 Complete Handler

```
VNImageBasedRequest *detectRequest = [[VNDetectFaceRectanglesRequest alloc]initWithCompletionHandler: completionHandler];
```

4，发送识别请求，并在回调中处理回调接受的数据

```
[detectRequestHandler performRequests:@[detectRequest] error:nil];
```
###代码整合：
总的来说一共经过这几步之后基本的人脸识别就实现了。

```
// 转换CIImage
CIImage *convertImage = [[CIImage alloc]initWithImage:image];

// 创建处理requestHandler
VNImageRequestHandler *detectRequestHandler = [[VNImageRequestHandler alloc]initWithCIImage:convertImage options:@{}];

// 设置回调
CompletionHandler completionHandler = ^(VNRequest *request, NSError * _Nullable error) {
NSArray *observations = request.results;
[self handleImageWithType:type image:image observations:observations complete:complete];
};

// 创建BaseRequest
VNImageBasedRequest *detectRequest = [[VNDetectFaceRectanglesRequest alloc]initWithCompletionHandler:completionHandler];

// 发送识别请求
[detectRequestHandler performRequests:@[detectRequest] error:nil];

```

###VNFaceObservation 介绍：
VNFaceObservation里面，我们能拿到的有用信息就是boundingBox。

```
/// 处理人脸识别回调
+ (void)faceRectangles:(NSArray *)observations image:(UIImage *_Nullable)image complete:(detectImageHandler _Nullable )complete{

NSMutableArray *tempArray = @[].mutableCopy;

for (VNFaceObservation *observation  in observations) {
CGRect faceRect = [self convertRect:observation.boundingBox imageSize:image.size];
}

```

boundingBox直接是CGRect类型，但是boundingBox返回的是x,y,w,h的比例，需要进行转换。

```
/// 转换Rect
+ (CGRect)convertRect:(CGRect)oldRect imageSize:(CGSize)imageSize{

CGFloat w = oldRect.size.width * imageSize.width;
CGFloat h = oldRect.size.height * imageSize.height;
CGFloat x = oldRect.origin.x * imageSize.width;
CGFloat y = imageSize.height - (oldRect.origin.y * imageSize.height) - h;
return CGRectMake(x, y, w, h);
}
```
关于Y值为何不是直接oldRect.origin.y * imageSize.height出来，是因为这个时候直接算出来的脸部是MAX Y值而不是min Y值，所以需要进行转换一下。
![](http://ata2-img.cn-hangzhou.img-pub.aliyun-inc.com/e890390d1df54410ba4febf18c2aa812.png)

###特征识别介绍：
VNDetectFaceLandmarksRequest 特征识别请求返回的也是VNFaceObservation，但是这个时候VNFaceObservation 对象的 landmarks 属性就会有值，这个属性里面存储了人物面部特征的点。
如：

```
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
```
每个特征对象里面都有一个pointCount属性，通过特征对象的pointAtIndex方法，可以取出来特征里面的每一个点，我们拿到点进行转换后，相应的UI绘制或其他操作。
例如：

```

UIImage *sourceImage = image;

// 遍历所有特征
for (VNFaceLandmarkRegion2D *landmarks2D in pointArray) {

CGPoint points[landmarks2D.pointCount];
// 转换特征的所有点
for (int i=0; i<landmarks2D.pointCount; i++) {
vector_float2 point = [landmarks2D pointAtIndex:i];
CGFloat rectWidth  = sourceImage.size.width * observation.boundingBox.size.width;
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
```
##Vision Demo演示：
以上是简单列举了一些代码，具体更详细的可参考官方文档或Demo代码（后面有Demo 下载链接）
下面GIF演示一下Vision Demo ，此Demo比较简单，演示了基本的一些Vision的使用
####图像识别：
**人脸识别、特征识别、文字识别**
![](http://ata2-img.cn-hangzhou.img-pub.aliyun-inc.com/ce0cac40f49b91fa3d2b669c97bf971a.gif)

####动态识别：
**动态监测人脸，动态进行添加**
![55k2.gif](http://ata2-img.cn-hangzhou.img-pub.aliyun-inc.com/1fe0e407df35cb61e8b37ffc4899dde8.gif)

##参考资料：
http://www.jianshu.com/p/174b7b67acc9
http://www.jianshu.com/p/e371099f12bd
https://github.com/NilStack/HelloVision
https://www.atatech.org/articles/81702
https://developer.apple.com/documentation/vision
https://github.com/jeffreybergier/Blog-Getting-Started-with-Vision
https://tech.iheart.com/iheart-wwdc-familiar-faces-1093fe751d9e
http://yulingtianxia.com/blog/2017/06/19/Core-ML-and-Vision-Framework-on-iOS-11/
