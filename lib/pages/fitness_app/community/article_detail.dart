import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:demo_project/api/article_api.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:share_plus/share_plus.dart';

class ArticleDetailScreen extends StatefulWidget {
  final String articleId;

  const ArticleDetailScreen({Key? key, required this.articleId}) : super(key: key);

  @override
  _ArticleDetailScreenState createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  bool isLoading = true;
  Map<String, dynamic>? articleData;
  List<Map<String, dynamic>> comments = [
    {
      'id': 1,
      'user': '健身爱好者1',
      'avatar': 'https://randomuser.me/api/portraits/men/1.jpg',
      'content': '这篇文章很有帮助！',
      'time': '2023-10-01 10:00',
      'replies': [
        {
          'id': 11,
          'user': '健身达人2',
          'avatar': 'https://randomuser.me/api/portraits/women/2.jpg',
          'content': '我也觉得很有帮助！',
          'time': '2023-10-01 10:05',
        },
      ],
    },
    {
      'id': 2,
      'user': '健身达人2',
      'avatar': 'https://randomuser.me/api/portraits/women/2.jpg',
      'content': '学到了很多新知识，感谢分享！',
      'time': '2023-10-01 11:00',
      'replies': [],
    },
  ];
  bool isCommentLoading = true;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadArticleDetail();
  }

  Future<void> _loadArticleDetail() async {
    try {
      final result = await ArticleApi().getArticleInfoById(widget.articleId);
      if (result.code == 200) {
        setState(() {
          articleData = result.data;
          isLoading = false;
        });
        _loadComments();
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('加载文章详情失败: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          isLoading
              ? Center(child: CircularProgressIndicator())
              : articleData == null
                  ? Center(child: Text('加载失败'))
                  : CustomScrollView(
                      slivers: [
                        SliverPadding(
                          padding: EdgeInsets.all(16.0),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate([
                              if (articleData!['thumbnailUrl'] != null)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    articleData!['thumbnailUrl'],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 200,
                                  ),
                                ),
                              SizedBox(height: 16.0),
                              Text(
                                articleData!['title'] ?? '无标题',
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Row(
                                children: [
                                  Icon(Icons.calendar_today, size: 16.0, color: Colors.grey),
                                  SizedBox(width: 4.0),
                                  Text(
                                    '发布于 ${articleData!['createdAt']}',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16.0),
                            ]),
                          ),
                        ),
                        _buildContent(),
                        SliverPadding(
                          padding: EdgeInsets.all(16.0),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate([
                              SizedBox(height: 16.0),
                              Row(
                                children: [
                                  Icon(Icons.thumb_up, size: 20.0, color: Colors.blue),
                                  SizedBox(width: 4.0),
                                  Text(
                                    '${articleData!['thumbsUpCount'] ?? 0}',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  SizedBox(width: 16.0),
                                  Icon(Icons.comment, size: 20.0, color: Colors.green),
                                  SizedBox(width: 4.0),
                                  Text(
                                    '${articleData!['commentCount'] ?? 0}',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16.0),
                              if (articleData!['tags'] != null)
                                Wrap(
                                  spacing: 8.0,
                                  children: (jsonDecode(articleData!['tags']) as List)
                                      .map<Widget>((tag) => Chip(
                                            label: Text(tag),
                                            backgroundColor: Colors.blue[50],
                                          ))
                                      .toList(),
                                ),
                            ]),
                          ),
                        ),
                        _buildCommentList(),
                        SliverPadding(
                          padding: EdgeInsets.only(bottom: 80.0), // 为底部输入框留出空间
                        ),
                      ],
                    ),
          // 固定在底部的评论输入框
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildCommentInput(),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent, // 背景透明
      elevation: 0, // 去除阴影
      title: Text(
        '文章详情',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black, // 标题文字黑色
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.share, color: Colors.black), // 图标黑色
          onPressed: _shareArticle,
        ),
      ],
      flexibleSpace: Container(
        color: Colors.transparent, // 不再需要渐变背景
      ),
      iconTheme: IconThemeData(color: Colors.black), // 返回箭头也变黑
    );
  }

  Future<void> _shareArticle() async {
    if (articleData == null) {
      print('文章数据为空，无法分享');
      return;
    }

    print('开始分享文章: ${articleData!['title']}');
    try {
      final String shareText = '${articleData!['title']}\n\n${articleData!['previewContent']}\n\n阅读更多：http://localhost:8080/fitness/api/articles/get/${widget.articleId}';
      await Share.share(shareText);
      print('分享成功');
    } catch (e) {
      print('分享失败: $e');
    }
  }

  Widget _buildContent() {
    final content = articleData!['content'] ?? '无内容';
    final paragraphs = content.split('\n'); // 将内容按段落分割

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              paragraphs[index],
              style: TextStyle(fontSize: 16.0, height: 1.6),
            ),
          );
        },
        childCount: paragraphs.length,
      ),
    );
  }

  Future<void> _loadComments() async {
    try {
      // 模拟从API获取评论数据
      await Future.delayed(Duration(seconds: 1));
      setState(() {
        comments = [
          {
            'id': 1,
            'user': '健身爱好者1',
            'avatar': 'https://randomuser.me/api/portraits/men/1.jpg',
            'content': '这篇文章很有帮助！',
            'time': '2023-10-01 10:00',
            'replies': [
              {
                'id': 11,
                'user': '健身达人2',
                'avatar': 'https://randomuser.me/api/portraits/women/2.jpg',
                'content': '我也觉得很有帮助！',
                'time': '2023-10-01 10:05',
              },
            ],
          },
          {
            'id': 2,
            'user': '健身达人2',
            'avatar': 'https://randomuser.me/api/portraits/women/2.jpg',
            'content': '学到了很多新知识，感谢分享！',
            'time': '2023-10-01 11:00',
            'replies': [],
          },
        ];
        isCommentLoading = false;
      });
    } catch (e) {
      print('加载评论失败: $e');
    }
  }

  Widget _buildCommentList() {
    if (isCommentLoading) {
      return SliverToBoxAdapter(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (comments.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(child: Text('暂无评论')),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final comment = comments[index];
          return _buildComment(context, comment, 0); // 从层级0开始
        },
        childCount: comments.length,
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      height: 80.0, // 与SliverPadding的底部内边距一致
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey[200]!,
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: '写下你的评论...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.send, color: Colors.blue),
            onPressed: _submitComment,
          ),
        ],
      ),
    );
  }

  Future<void> _submitComment() async {
    final content = _commentController.text.trim();
    if (content.isEmpty) return;

    setState(() {
      comments.insert(0, {
        'id': comments.length + 1,
        'user': '当前用户',
        'avatar': 'https://randomuser.me/api/portraits/men/3.jpg',
        'content': content,
        'time': '刚刚',
      });
      _commentController.clear();
    });

    // 模拟提交到API
    await Future.delayed(Duration(seconds: 1));
  }

  Widget _buildComment(BuildContext context, Map<String, dynamic> comment, int level) {
    return Padding(
      padding: EdgeInsets.only(left: level * 16.0, top: 8.0), // 根据层级缩进
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            margin: EdgeInsets.symmetric(vertical: 4.0),
            color: level == 0 ? Colors.white : Colors.grey[50], // 父级评论和二级评论背景色不同
            elevation: level == 0 ? 2.0 : 0.0, // 父级评论有阴影，二级评论无阴影
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: BorderSide(
                color: level == 0 ? Colors.grey[200]! : Colors.transparent, // 父级评论有边框
                width: 1.0,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(comment['avatar']),
                        radius: 16.0,
                      ),
                      SizedBox(width: 8.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              comment['user'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              comment['time'],
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (level == 0) // 只有父级评论显示回复按钮
                        IconButton(
                          icon: Icon(Icons.reply, size: 16.0, color: Colors.grey),
                          onPressed: () => _showReplyDialog(context, comment['id']),
                        ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    comment['content'],
                    style: TextStyle(fontSize: 14.0),
                  ),
                ],
              ),
            ),
          ),
          // 显示二级评论
          if (comment['replies'] != null && comment['replies'].isNotEmpty)
            Padding(
              padding: EdgeInsets.only(left: 16.0), // 二级评论缩进
              child: Column(
                children: comment['replies'].map<Widget>((reply) {
                  return _buildComment(context, reply, level + 1); // 递归显示二级评论
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  void _showReplyDialog(BuildContext context, int parentId) {
    final TextEditingController replyController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('回复评论'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: replyController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "输入你的回复...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.grey, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
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
                final reply = replyController.text.trim();
                if (reply.isNotEmpty) {
                  _submitReply(parentId, reply);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _submitReply(int parentId, String content) {
    setState(() {
      final parentComment = comments.firstWhere((comment) => comment['id'] == parentId);
      if (parentComment['replies'] == null) {
        parentComment['replies'] = []; // 初始化replies列表
      }
      parentComment['replies'].add({
        'id': DateTime.now().millisecondsSinceEpoch, // 使用时间戳作为ID
        'user': '当前用户',
        'avatar': 'https://randomuser.me/api/portraits/men/3.jpg',
        'content': content,
        'time': '刚刚',
      });
    });
  }
} 