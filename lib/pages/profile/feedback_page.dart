import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';  // 用于星级评分的包

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  TextEditingController _feedbackController = TextEditingController();
  double _rating = 3.0;  // 初始星级评分

  // 提交反馈的逻辑
  void _submitFeedback() {
    String feedback = _feedbackController.text;
    if (feedback.isEmpty) {
      // 如果没有输入反馈内容
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "请输入您的反馈",
            textAlign: TextAlign.left, // 设置文本左对齐
          ),
        ),
      );
      return;
    }
    // 提交反馈后的逻辑，例如提交到服务器
    print("提交的反馈: $feedback");
    print("评分: $_rating");

    // 提交成功后，可以显示一个提示框
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("感谢您的反馈！")));
    // 清空输入框
    _feedbackController.clear();
    setState(() {
      _rating = 3.0;  // 重置星级评分
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('反馈'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // 反馈说明
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Text(
                "您的反馈对我们非常重要，请告诉我们您的想法，帮助我们改进产品。",
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
            ),
            // 反馈输入框
            TextField(
              controller: _feedbackController,
              maxLines: 6,
              decoration: InputDecoration(
                labelText: "请输入您的反馈",
                hintText: "请描述您的问题或建议",
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(10),
              ),
            ),
            const SizedBox(height: 20),
            // 星级评分
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("评分：", style: TextStyle(fontSize: 16)),
                RatingBar.builder(
                  initialRating: _rating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 40,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, index) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      _rating = rating;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            // 提交按钮
            ElevatedButton(
              onPressed: _submitFeedback,
              child: const Text('提交反馈'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                textStyle: TextStyle(fontSize: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}