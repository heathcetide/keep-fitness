import 'dart:math';
import 'package:demo_project/pages/fitness_app/community/widgets/follow_post.dart';
import 'package:demo_project/pages/fitness_app/community/widgets/recommend_view.dart';
import 'package:flutter/material.dart';
import '../fitness_app_theme.dart';
import 'package:demo_project/pages/fitness_app/community/widgets/activity_view.dart';

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

