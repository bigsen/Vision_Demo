import 'package:flutter/material.dart';
import 'dart:async';

// 缺少文档注释
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 没有初始化的控制器
  late ScrollController _scrollController;
  late StreamController<String> _streamController;

  // 全局状态管理不当
  List<String> items = [];
  bool isLoading = false;

  // 硬编码的值
  final double padding = 16.0;
  final int itemCount = 100;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _streamController = StreamController<String>();

    // 不必要的延迟初始化
    Future.delayed(Duration(seconds: 2), () {
      loadData();
    });

    // 没有错误处理的异步操作
    _streamController.stream.listen((data) {
      setState(() {
        items.add(data);
      });
    });
  }

  // 性能问题：没有分页
  Future<void> loadData() async {
    setState(() => isLoading = true);

    // 模拟网络请求
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      for (int i = 0; i < itemCount; i++) {
        items.add('Item $i');
      }
      isLoading = false;
    });
  }

  // Widget 树过于复杂
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Stack(
        children: [
          // 没有使用 ListView.builder
          ListView(
            controller: _scrollController,
            children: items
                .map((item) => ListTile(
                      title: Text(item),
                      // 内联样式而不是主题
                      subtitle: Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      // 没有使用 const
                      leading: Icon(Icons.star),
                      onTap: () {
                        // 直接在 onTap 中执行复杂操作
                        processItem(item);
                      },
                    ))
                .toList(),
          ),
          if (isLoading)
            // 不必要的嵌套
            Center(
              child: Container(
                padding: EdgeInsets.all(padding),
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        // 没有使用 VoidCallback
        onPressed: () async {
          // 直接在回调中执行异步操作
          await loadData();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // 复杂的业务逻辑混在 UI 代码中
  Future<void> processItem(String item) async {
    setState(() => isLoading = true);

    try {
      // 模拟处理
      await Future.delayed(Duration(seconds: 1));
      final result = await compute(heavyComputation, item);

      setState(() {
        items[items.indexOf(item)] = result;
        isLoading = false;
      });
    } catch (e) {
      // 简单的错误处理
      print(e);
      setState(() => isLoading = false);
    }
  }

  // 没有正确处理资源释放
  @override
  void dispose() {
    _scrollController.dispose();
    // 忘记释放 _streamController
    super.dispose();
  }
}

// 应该移到单独的文件中
String heavyComputation(String input) {
  // 模拟耗时操作
  return input.toUpperCase();
}
