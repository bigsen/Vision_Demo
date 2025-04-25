def calculate_average(numbers):
    # 未处理空列表的情况
    return sum(numbers) / len(numbers)

def process_data(data):
    # 未使用的变量
    temp = []
    for item in data:
        if item > 0:
            temp.append(item)
    return data  # 返回了原始数据而不是处理后的数据

class User:
    def __init__(self, name, age):
        self.name = name
        self.age = age
    
    def get_info(self):
        # 字符串格式化使用旧式方法
        return "Name: %s, Age: %d" % (self.name, self.age)

def main():
    # 硬编码的魔法数字
    numbers = [1, 2, 3, 4, 5]
    result = calculate_average(numbers)
    print("Average:", result)
    
    # 未处理的异常
    data = [1, -2, 3, -4, 5]
    processed = process_data(data)
    print("Processed data:", processed)
    
    # 创建用户对象但未使用
    user = User("Test", 25)
    
    # 重复的代码
    print("User info:", user.get_info())
    print("User info:", user.get_info())

if __name__ == "__main__":
    main() 