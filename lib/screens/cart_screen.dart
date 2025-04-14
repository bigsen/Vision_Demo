import 'package:flutter/material.dart';
import 'dart:async';

// 问题：缺少类注释文档
class CartScreen extends StatefulWidget {
  CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // 问题：全局变量，应该使用状态管理
  List<Map<String, dynamic>> cartItems = [
    {'name': 'Product 1', 'price': 99.99, 'quantity': 1},
    {'name': 'Product 2', 'price': 149.99, 'quantity': 2},
    {'name': 'Product 3', 'price': 199.99, 'quantity': 1},
  ];

  // 问题：未初始化的控制器
  late StreamController<double> _totalPriceController;

  // 问题：硬编码的样式值
  final double spacing = 16.0;
  final TextStyle priceStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.blue,
  );

  @override
  void initState() {
    super.initState();
    _totalPriceController = StreamController<double>();
    // 问题：没有错误处理的异步操作
    calculateTotal();
  }

  // 问题：性能 - 每次都重新计算
  void calculateTotal() {
    double total = 0;
    for (var item in cartItems) {
      total += (item['price'] as double) * (item['quantity'] as int);
    }
    _totalPriceController.sink.add(total);
  }

  // 问题：未处理的异步错误
  Future<void> updateQuantity(int index, int newQuantity) async {
    setState(() {
      cartItems[index]['quantity'] = newQuantity;
    });
    calculateTotal();
  }

  // 问题：复杂的 build 方法，应该拆分
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('购物车'),
        // 问题：硬编码的颜色
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // 问题：未使用 ListView.builder
          Expanded(
            child: ListView(
              children: List.generate(
                cartItems.length,
                (index) => Container(
                  margin: EdgeInsets.all(spacing),
                  padding: EdgeInsets.all(spacing),
                  decoration: BoxDecoration(
                    // 问题：硬编码的颜色和样式
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cartItems[index]['name'] as String,
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '¥${cartItems[index]['price']}',
                              style: priceStyle,
                            ),
                          ],
                        ),
                      ),
                      // 问题：未优化的数量选择器
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () => updateQuantity(
                              index,
                              (cartItems[index]['quantity'] as int) - 1,
                            ),
                          ),
                          Text('${cartItems[index]['quantity']}'),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () => updateQuantity(
                              index,
                              (cartItems[index]['quantity'] as int) + 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // 问题：未处理加载状态
          StreamBuilder<double>(
            stream: _totalPriceController.stream,
            builder: (context, snapshot) {
              return Container(
                padding: EdgeInsets.all(spacing),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('总计:', style: priceStyle),
                    Text(
                      '¥${snapshot.data ?? 0.0}',
                      style: priceStyle,
                    ),
                  ],
                ),
              );
            },
          ),
          // 问题：未考虑不同设备尺寸
          Container(
            width: double.infinity,
            height: 50,
            // 问题：硬编码的边距
            margin: EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                // 问题：未实现的功能
                print('Checkout pressed');
              },
              child: Text('结算'),
            ),
          ),
        ],
      ),
    );
  }

  // 问题：未正确释放资源
  @override
  void dispose() {
    super.dispose();
    // 问题：在 super.dispose() 之后调用
    _totalPriceController.close();
  }
}
