import Foundation

// MARK: - 网络请求管理器
class NetworkManager {
    // 单例实现存在问题：没有访问控制
    static let shared = NetworkManager()
    
    // 可变状态没有线程保护
    private var requestCache: [String: Data] = [:]
    private var activeTasks: [URLSessionTask] = []
    
    // 硬编码的超时时间
    private let timeout: TimeInterval = 30
    
    // 危险：直接暴露内部实现
    var session: URLSession!
    
    private init() {
        // 配置不当：没有proper配置
        session = URLSession.shared
    }
    
    // 错误处理不完整
    func fetchData(from urlString: String, completion: @escaping (Data?) -> Void) {
        // 强制解包 URL
        let url = URL(string: urlString)!
        
        // 没有取消之前的请求
        let task = session.dataTask(with: url) { [weak self] data, response, error in
            // 响应状态码检查缺失
            if let data = data {
                // 直接在后台线程操作共享资源
                self?.requestCache[urlString] = data
                
                // 回调没有考虑线程安全
                completion(data)
            } else {
                // 错误处理不完整
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
            }
        }
        
        // 数组操作没有同步保护
        activeTasks.append(task)
        task.resume()
    }
    
    // 方法命名不规范
    func dl(_ url: String) {
        fetchData(from: url) { _ in }
    }
    
    // 资源清理不完整
    func cancelAllTasks() {
        // 没有同步保护
        activeTasks.forEach { $0.cancel() }
        activeTasks.removeAll()
        // 没有清理缓存
    }
    
    // 内存管理问题：循环引用风险
    func setupPeriodicFetch(url: String) {
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { timer in
            self.fetchData(from: url) { data in
                // 强引用 self
                self.requestCache[url] = data
            }
        }
    }
    
    // 错误的错误传播
    func validateResponse(_ response: URLResponse?) -> Bool {
        guard let httpResponse = response as? HTTPURLResponse else {
            // 应该抛出错误而不是返回 false
            return false
        }
        
        // 魔法数字
        return httpResponse.statusCode == 200
    }
    
    // 重试逻辑实现不当
    func fetchWithRetry(url: String, retries: Int = 3) {
        func retry(_ remainingAttempts: Int) {
            guard remainingAttempts > 0 else { return }
            
            fetchData(from: url) { data in
                if data == nil {
                    // 递归调用没有延迟，可能导致立即重试
                    retry(remainingAttempts - 1)
                }
            }
        }
        
        retry(retries)
    }
    
    // 违反单一职责原则
    func processAndCacheImage(from url: String) {
        fetchData(from: url) { data in
            guard let data = data,
                  let image = UIImage(data: data) else { return }
            
            // 图像处理逻辑不应该在网络层
            let size = CGSize(width: 100, height: 100)
            UIGraphicsBeginImageContext(size)
            image.draw(in: CGRect(origin: .zero, size: size))
            let resized = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            // 缓存逻辑混合在一起
            DispatchQueue.main.async {
                self.requestCache[url] = resized?.pngData()
            }
        }
    }
} 