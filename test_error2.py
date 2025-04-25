import os
import sys

# 全局变量使用不当
global_var = None

def unsafe_file_operation(filename):
    # 不安全的文件操作，未使用上下文管理器
    file = open(filename, 'w')
    file.write("test data")
    # 忘记关闭文件
    return True

def process_user_input(input_data):
    # 未进行输入验证
    result = input_data * 2
    return result

class Database:
    def __init__(self):
        self.connection = None
    
    def connect(self):
        # 模拟数据库连接
        self.connection = "connected"
        return True
    
    def query(self, sql):
        # SQL注入风险
        return f"Executing: {sql}"
    
    def close(self):
        # 未检查连接状态
        self.connection = None

def main():
    # 使用已弃用的方法
    print("Python version:", sys.version)
    
    # 资源泄漏
    db = Database()
    db.connect()
    result = db.query("SELECT * FROM users")
    print(result)
    # 忘记关闭数据库连接
    
    # 不安全的类型转换
    user_input = "123"
    number = int(user_input)  # 可能抛出 ValueError
    
    # 未处理的异常
    try:
        unsafe_file_operation("test.txt")
    except:
        pass  # 空的异常处理
    
    # 循环中的效率问题
    items = [1, 2, 3, 4, 5]
    for i in range(len(items)):
        print(items[i])  # 直接使用迭代器更好
    
    # 未使用的导入
    os.path.exists("test.txt")

if __name__ == "__main__":
    main() 