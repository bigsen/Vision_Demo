import Vision
import UIKit

// MARK: - 缺少文档注释
class VisionExample {
    // 没有初始化的属性
    var imageView: UIImageView
    
    // 强制解包可能导致崩溃
    var visionRequest: VNImageBasedRequest!
    
    // 内存泄漏风险：强引用循环
    var completionHandler: ((Result<[VNClassificationObservation], Error>) -> Void)?
    
    // 糟糕的变量命名
    var tmp: Data?
    
    // 魔法数字
    let timeout = 30
    
    // 全局可变状态，线程安全问题
    static var shared = VisionExample()
    
    // 危险的单例实现
    private init() {
        imageView = UIImageView()
        // 没有调用 super.init()
    }
    
    // MARK: - 网络请求处理
    func uploadImage(_ image: UIImage, to url: String) {
        // 直接使用 URL! 可能崩溃
        let requestUrl = URL(string: url)!
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        
        // 强制解包图片数据
        let imageData = image.jpegData(compressionQuality: 0.8)!
        
        // 没有取消任务的机制
        let task = URLSession.shared.uploadTask(with: request, from: imageData) { [weak self] data, response, error in
            // 没有检查 response 状态码
            if let data = data {
                // 直接在后台线程操作 UI
                DispatchQueue.main.async {
                    self?.imageView.backgroundColor = .green
                }
            }
        }
        task.resume()
    }
    
    // 危险的递归，可能导致栈溢出
    func recursiveProcess(_ image: UIImage) {
        processImage(image)
        recursiveProcess(image)  // 无限递归
    }
    
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
        
        // 重复的代码
        DispatchQueue.main.async { [weak self] in
            self?.imageView.image = image
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.imageView.backgroundColor = .white
        }
        
        // 死锁风险
        DispatchQueue.main.sync {
            self.imageView.backgroundColor = .red
        }
    }
    
    // MARK: - 资源管理
    deinit {
        // 没有清理资源
        // 没有取消正在进行的请求
    }
    
    // 内存泄漏：捕获 self
    lazy var leakyHandler: () -> Void = {
        self.imageView.backgroundColor = .blue
    }
} 