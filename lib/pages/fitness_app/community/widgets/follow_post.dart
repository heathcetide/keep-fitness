
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

import '../../../../widgets/bonss_avatar.dart';

class FollowedPost extends StatelessWidget {
  final int? posterUid;
  final String? posterName;
  final String? posterAvatar;
  final String? content;
  final DateTime? time;
  final bool? isLiked;
  final int? likeCount;
  final int? commentCount;
  final List<dynamic>? displayLikeUserList;
  final List<dynamic>? displayCommentList;
  final List<String>? imageList;

  const FollowedPost({
    Key? key,
    this.posterUid,
    this.posterName,
    this.posterAvatar,
    this.content,
    this.time,
    this.isLiked,
    this.likeCount,
    this.commentCount,
    this.displayLikeUserList,
    this.displayCommentList,
    this.imageList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[200]!))),
      padding: EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Avatar(
                posterAvatar!,
                name: posterName!,
              ),
              SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      posterName!,
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      content!,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "${time!.hour}:${time!.minute} | ${likeCount} Likes | ${commentCount} Comments",
                      style: TextStyle(color: Colors.grey),
                    ),
                    // 展示图片列表
                    if (imageList != null && imageList!.isNotEmpty)
                      Container(
                        margin: EdgeInsets.only(top: 8.0),
                        height: 100, // 设置高度
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: imageList!.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(right: 8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  imageList![index],
                                  fit: BoxFit.cover,
                                  width: 100, // 设置宽度
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          // 点赞和评论按钮
          Row(
            mainAxisAlignment: MainAxisAlignment.end, // 水平居右
            children: [
              LikeButton(
                isLiked: isLiked ?? false,
                onTap: (isLiked) async {
                  // 处理点赞逻辑
                  return !isLiked;
                },
              ),
              SizedBox(width: 8),
              Text('$likeCount Likes'),
              SizedBox(width: 16),
              GestureDetector(
                onTap: () {
                  _showCommentDialog(context);
                },
                child: Row(
                  children: [
                    Icon(Icons.comment, color: Colors.grey), // 评论图标
                    SizedBox(width: 4),
                    Text('$commentCount Comments'),
                  ],
                ),
              ),
            ],
          ),
          // 评论展示部分
          if (displayCommentList != null && displayCommentList!.isNotEmpty)
            Container(
              padding: EdgeInsets.only(top: 8.0),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey[300]!)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: displayCommentList!.map<Widget>((comment) {
                  return _buildComment(context, comment, 3); // 默认从一级评论开始
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  // 显示评论并处理二级评论
  Widget _buildComment(BuildContext context, dynamic comment, int level) {
    return Padding(
      padding: EdgeInsets.only(left: level * 16.0, top: 8.0), // 左侧缩进
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            margin: EdgeInsets.symmetric(vertical: 4.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Avatar(
                    "https://book.flutterchina.club/assets/img/logo.png", // 这里可以替换为评论者的头像
                    name: comment['name'],
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          comment['name'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(comment['content']),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 二级评论
          if (comment['replies'] != null)
            Column(
              children: comment['replies'].map<Widget>((reply) {
                return _buildComment(context, reply, level + 1); // 递归显示二级评论
              }).toList(),
            ),
        ],
      ),
    );
  }
  void _showCommentDialog(BuildContext context) {
    final TextEditingController commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('输入评论'),
          content: SingleChildScrollView(  // 让输入框可以滚动
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: commentController,
                  maxLines: 5,  // 允许最多显示5行
                  decoration: InputDecoration(
                    hintText: "输入你的评论...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.grey, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0), // 内边距
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('提交'),
              onPressed: () {
                // 处理提交评论逻辑
                String comment = commentController.text;
                // 这里可以添加代码来处理评论，例如发送到服务器或更新状态
                print("评论内容: $comment");
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}