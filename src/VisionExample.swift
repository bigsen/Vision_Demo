import Vision
import UIKit

class VisionExample {
    // 没有初始化的属性
    var imageView: UIImageView
    
    // 强制解包可能导致崩溃
    var visionRequest: VNImageBasedRequest!
    
    // 内存泄漏风险：强引用循环
    var completionHandler: ((Result<[VNClassificationObservation], Error>) -> Void)?
    
    func processImage(_ image: UIImage) {
        // 没有错误处理的强制解包
        let ciImage = CIImage(image: image)!
        
        // 创建请求处理器
        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        
        // 创建分类请求
        let request = VNClassifyImageRequest { [weak self] request, error in
            // 没有检查 error
            let observations = request.results as! [VNClassificationObservation]
            
            // 直接在后台线程更新 UI
            self?.imageView.image = image
            
            // 可能的强引用循环
            self?.completionHandler?(.success(observations))
        }
        
        // 没有错误处理的 try!
        try! handler.perform([request])
    }
    
    // 方法太长，做了太多事情
    func analyzeAndProcessImage(_ image: UIImage) {
        let ciImage = CIImage(image: image)!
        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        
        let classificationRequest = VNClassifyImageRequest()
        let rectangleRequest = VNDetectRectanglesRequest()
        let textRequest = VNRecognizeTextRequest()
        
        try! handler.perform([classificationRequest, rectangleRequest, textRequest])
        
        let classifications = classificationRequest.results as! [VNClassificationObservation]
        let rectangles = rectangleRequest.results as! [VNRectangleObservation]
        let texts = textRequest.results as! [VNRecognizedTextObservation]
        
        // 处理所有结果...
        // 这个方法做了太多事情，应该拆分
    }
} 