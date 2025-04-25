import UIKit
import Vision
import CoreImage

// 缺少类型文档注释
class ImageProcessor {
    // 糟糕的变量命名
    var v: VNImageRequestHandler?
    var p: CGFloat = 0.8
    
    // 可选类型的不安全处理
    private var imageProcessor: CIContext!
    
    // 违反单一职责原则：一个数组存储多种不同类型
    private var items: [Any] = []
    
    // 线程安全问题：没有同步机制
    private var cache: [String: UIImage] = [:]
    
    // 危险的强制类型转换
    func process(data: Any) -> UIImage {
        return data as! UIImage
    }
    
    // 错误的错误处理
    func loadImage(from url: URL) {
        do {
            let data = try Data(contentsOf: url)
            // 忽略了错误处理
        } catch {
            print("Error: \(error)")
            // 没有适当的错误传播
        }
    }
    
    // 性能问题：重复创建对象
    func applyFilter(to image: UIImage) -> UIImage? {
        let context = CIContext()  // 每次调用都创建新的 context
        let filter = CIFilter(name: "CISepiaTone")
        
        // 强制解包
        let ciImage = CIImage(image: image)!
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        // 没有错误检查
        let outputImage = filter?.outputImage
        let cgImage = context.createCGImage(outputImage!, from: outputImage!.extent)
        
        return UIImage(cgImage: cgImage!)
    }
    
    // 资源泄露：没有清理
    func startProcessing() {
        // 创建了定时器但从未停止
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.process(data: UIImage())
        }
    }
    
    // 闭包中的循环引用
    lazy var processHandler: () -> Void = {
        self.items.removeAll()  // 强引用 self
        self.cache.removeAll()
    }
    
    // 违反 DRY 原则：重复代码
    func processAndCache(_ image: UIImage) {
        // 重复的图像处理逻辑
        let context = CIContext()
        let filter = CIFilter(name: "CISepiaTone")
        let ciImage = CIImage(image: image)!
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        let outputImage = filter?.outputImage
        let cgImage = context.createCGImage(outputImage!, from: outputImage!.extent)
        let processed = UIImage(cgImage: cgImage!)
        
        // 重复的缓存逻辑
        DispatchQueue.main.async {
            self.cache["key"] = processed
        }
    }
    
    // 不必要的强制解包
    func resize(_ image: UIImage, to size: CGSize) -> UIImage! {
        UIGraphicsBeginImageContext(size)
        image.draw(in: CGRect(origin: .zero, size: size))
        let resized = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resized!  // 强制解包
    }
} 