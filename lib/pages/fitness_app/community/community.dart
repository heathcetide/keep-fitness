import 'dart:math';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import '../../../widgets/bonss_avatar.dart';
import '../fitness_app_theme.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({Key? key, this.animationController}) : super(key: key);

  final AnimationController? animationController;

  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> with TickerProviderStateMixin {
  Animation<double>? topBarAnimation;
  late TabController _tabController;
  double topBarOpacity = 0.0;
  late Animation<double> contentAnimation;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);  // 默认进入推荐页面
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController!,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    contentAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController!,
            curve: Interval(0.5, 1.0, curve: Curves.fastOutSlowIn)));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: FitnessAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            getCommunityUI(),
            getAppBarUI(),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            ),
          ],
        ),
      ),
    );
  }

  Widget getCommunityUI() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: '搜索内容...',
              prefixIcon: Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Container(
          height: 48.0,
          child: TabBar(
            controller: _tabController,
            indicatorColor: Colors.blueAccent,
            labelColor: Colors.blueAccent,
            unselectedLabelColor: Colors.black,
            tabs: const <Widget>[
              Tab(text: '关注'),
              Tab(text: '推荐'),
              Tab(text: '活动'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // 关注部分
              ListView.builder(
                itemCount: 30, // 假设有30个关注的内容
                itemBuilder: (context, index) {
                  return FollowedPost(
                    posterUid: 114514 + index,
                    posterName: "小明同学 $index",
                    posterAvatar: "https://book.flutterchina.club/assets/img/logo.png?t=${Random(index).nextInt(10000000)}",
                    content: "这是用户$index 的动态内容。文字内容文字内容文字内容。",
                    time: DateTime.now().subtract(Duration(minutes: index * 10)),
                    isLiked: index % 2 == 0, // 假设偶数用户已点赞
                    likeCount: 20 + index,
                    commentCount: 5 + index,
                    displayLikeUserList: List.generate(3, (i) => {
                      "uid": 114515 + i,
                      "name": "点赞用户$i",
                    }),
                    imageList: List.generate(index % 3 + 1, (i) => "https://cetide-1325039295.cos.ap-chengdu.myqcloud.com/50bfa5c2-a8b7-4d48-b46e-cec667a699b8.png"),
                    displayCommentList: List.generate(2, (i) => {
                      "uid": 1919810 + i,
                      "name": "评论用户$i",
                      "replyName": null,
                      "replyUid": null,
                      "content": "评论内容评论内容评论内容。",
                    }),
                  );
                },
              ),
              _buildRecommendedTab(),  // 推荐页显示瀑布流
              // 活动部分
              ListView.builder(
                itemCount: 5, // 假设有5个活动
                itemBuilder: (context, index) {
                  return ActivityCard(
                    title: '活动标题 $index',
                    imageUrl: 'https://cetide-1325039295.cos.ap-chengdu.myqcloud.com/8b31e31a-f841-4e4a-ae32-8faa3b3310f2.jpg',
                    description: '活动描述内容，详细信息。',
                    time: '时间：${DateTime.now().add(Duration(days: index)).toLocal()}',
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: widget.animationController!,
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
              opacity: topBarAnimation!,
              child: Transform(
                transform: Matrix4.translationValues(0.0, 30 * (1.0 - topBarAnimation!.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: FitnessAppTheme.white.withOpacity(topBarOpacity),
                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(32.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: FitnessAppTheme.grey.withOpacity(0.4 * topBarOpacity),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: MediaQuery.of(context).padding.top),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 16 - 8.0 * topBarOpacity,
                            bottom: 12 - 8.0 * topBarOpacity),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Community',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: FitnessAppTheme.fontName,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 22 + 6 - 6 * topBarOpacity,
                                    letterSpacing: 1.2,
                                    color: FitnessAppTheme.darkerText,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 38,
                              width: 38,
                              child: InkWell(
                                highlightColor: Colors.transparent,
                                borderRadius: const BorderRadius.all(Radius.circular(32.0)),
                                onTap: () {},
                                child: Center(
                                  child: Icon(
                                    Icons.keyboard_arrow_left,
                                    color: FitnessAppTheme.grey,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }

  Widget _buildRecommendedTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,  // 每行2个
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 0.75,  // 适当调整卡片的宽高比
      ),
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        return RecommendedCard(index: index);
      },
    );
  }
}

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

class ActivityCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String description;
  final String time;

  const ActivityCard({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16)),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              height: 150,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              description,
              style: TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              time,
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

class RecommendedCard extends StatelessWidget {
  const RecommendedCard({Key? key, required this.index}) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16)),
              child: Image.network(
                'https://cetide-1325039295.cos.ap-chengdu.myqcloud.com/dfc2e3e1-2c63-44b3-8fee-1990d564a10c.jpeg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'User $index发布了一个动态',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '时间：10:00 AM',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}