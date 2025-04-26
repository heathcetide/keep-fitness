import 'dart:math';
import 'package:demo_project/pages/fitness_app/community/widgets/follow_post.dart';
import 'package:demo_project/pages/fitness_app/community/widgets/recommend_view.dart';
import 'package:flutter/material.dart';
import '../fitness_app_theme.dart';
import 'package:demo_project/pages/fitness_app/community/widgets/activity_view.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:demo_project/api/article_api.dart';
import 'package:demo_project/pages/fitness_app/community/article_detail.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({Key? key, this.animationController}) : super(key: key);

  final AnimationController? animationController;

  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> with TickerProviderStateMixin {
  static const Color primaryColor = Color(0xFF4CAF50); // 健康绿
  static const Color accentColor = Color(0xFFFF9800); // 活力橙
  static const Color backgroundColor = Color(0xFFF5F5F5);

  Animation<double>? topBarAnimation;
  late TabController _tabController;
  double topBarOpacity = 0.0;
  late Animation<double> contentAnimation;
  List<dynamic> recommendArticles = [];
  bool isLoading = true;
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  int? lastId;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3, 
      vsync: this,
      initialIndex: 1,
    );
    _tabController.addListener(() {
      setState(() {});
    });
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController!,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    contentAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController!,
            curve: Interval(0.5, 1.0, curve: Curves.fastOutSlowIn)));
    _loadRecommendArticles();
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
    return Container(
      color: backgroundColor,
      child: Column(
      children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 4.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 18.0),
                  child: Text(
                    '社区',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 18.0),
                  child: IconButton(
                    icon: Icon(Icons.notifications_none, color: Colors.grey[600]),
                    onPressed: () {
                      // 处理通知按钮点击
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.0),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 8.0,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
          child: TextField(
            decoration: InputDecoration(
                  hintText: '搜索健身话题...',
                  prefixIcon: Icon(Icons.search, color: primaryColor),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                ),
              ),
            ),
          ),
          SizedBox(height: 8.0),
        Container(
          height: 48.0,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 4.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          child: TabBar(
            controller: _tabController,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 2.0,
              indicatorColor: primaryColor,
              labelColor: primaryColor,
              unselectedLabelColor: Colors.grey[600],
              labelPadding: EdgeInsets.symmetric(horizontal: 8.0),
              labelStyle: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w500,
              ),
              onTap: (index) {
                setState(() {
                  _tabController.index = index;
                });
              },
            tabs: const <Widget>[
                Tab(
                  icon: Icon(Icons.people, size: 18.0),
                  text: '关注',
                ),
                Tab(
                  icon: Icon(Icons.thumb_up, size: 18.0),
                  text: '推荐',
                ),
                Tab(
                  icon: Icon(Icons.event, size: 18.0),
                  text: '活动',
                ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              ListView.builder(
                  padding: EdgeInsets.only(top: 8.0),
                  itemCount: 30,
                itemBuilder: (context, index) {
                  return FollowedPost(
                    posterUid: 114514 + index,
                      posterName: "健身达人 $index",
                      posterAvatar: "https://randomuser.me/api/portraits/${index % 2 == 0 ? 'men' : 'women'}/${index % 100}.jpg",
                      content: _getRandomFitnessContent(index),
                    time: DateTime.now().subtract(Duration(minutes: index * 10)),
                      isLiked: index % 2 == 0,
                    likeCount: 20 + index,
                    commentCount: 5 + index,
                    displayLikeUserList: List.generate(3, (i) => {
                      "uid": 114515 + i,
                        "name": "健身爱好者$i",
                    }),
                      imageList: _getRandomFitnessImages(index),
                    displayCommentList: List.generate(2, (i) => {
                      "uid": 1919810 + i,
                        "name": "健身伙伴$i",
                      "replyName": null,
                      "replyUid": null,
                        "content": _getRandomCommentContent(i),
                    }),
                  );
                },
              ),
                _buildWaterfallTab(),
              ListView.builder(
                  padding: EdgeInsets.all(16.0),
                  itemCount: 5,
                itemBuilder: (context, index) {
                  return ActivityCard(
                      title: _getRandomActivityTitle(index),
                      imageUrl: _getRandomActivityImage(index),
                      description: _getRandomActivityDescription(index),
                    time: '时间：${DateTime.now().add(Duration(days: index)).toLocal()}',
                  );
                },
              ),
            ],
          ),
        ),
      ],
      ),
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
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation!.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: FitnessAppTheme.white.withOpacity(topBarOpacity),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: FitnessAppTheme.grey
                              .withOpacity(0.4 * topBarOpacity),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
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
                                  '社区',
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
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(32.0)),
                                onTap: () {},
                                child: Center(
                                  child: Icon(
                                    Icons.keyboard_arrow_left,
                                    color: FitnessAppTheme.grey,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 8,
                                right: 8,
                              ),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Icon(
                                      Icons.calendar_today,
                                      color: FitnessAppTheme.grey,
                                      size: 18,
                                    ),
                                  ),
                                  Text(
                                    '15 May',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: FitnessAppTheme.fontName,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18,
                                      letterSpacing: -0.2,
                                      color: FitnessAppTheme.darkerText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 38,
                              width: 38,
                              child: InkWell(
                                highlightColor: Colors.transparent,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(32.0)),
                                onTap: () {},
                                child: Center(
                                  child: Icon(
                                    Icons.keyboard_arrow_right,
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

  Widget _buildWaterfallTab() {
    return SmartRefresher(
      controller: _refreshController,
      enablePullUp: true,
      onRefresh: _onRefresh,
      onLoading: _loadMoreArticles,
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.all(16.0),
            sliver: SliverMasonryGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _buildArticleCard(recommendArticles[index]);
                },
                childCount: recommendArticles.length,
              ),
              gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              mainAxisSpacing: 16.0,
        crossAxisSpacing: 16.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleCard(dynamic article) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleDetailScreen(
              articleId: article['id'].toString(),
            ),
          ),
        );
      },
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article['thumbnailUrl'] != null)
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
                child: Image.network(
                  article['thumbnailUrl'],
                  fit: BoxFit.cover,
                  height: 150,
                  width: double.infinity,
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article['title'] ?? '无标题',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    article['previewContent'] ?? '无内容',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey[600],
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      Icon(Icons.thumb_up, size: 16.0, color: Colors.grey),
                      SizedBox(width: 4.0),
                      Text(
                        '${article['thumbsUpCount'] ?? 0}',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey,
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.comment, size: 16.0, color: Colors.grey),
                      SizedBox(width: 4.0),
                      Text(
                        '${article['commentCount'] ?? 0}',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadRecommendArticles() async {
    try {
      final result = await ArticleApi().getRecommendArticles();
      if (result.code == 200) {
        setState(() {
          recommendArticles = result.data;
          lastId = recommendArticles.isNotEmpty ? recommendArticles.last['id'] : null;
        });
      }
    } catch (e) {
      print('加载推荐文章失败: $e');
    }
  }

  Future<void> _loadMoreArticles() async {
    print('加载更多，lastId: $lastId, hasMore: $hasMore');

    if (!hasMore) {
      print('没有更多数据');
      _refreshController.loadNoData();
      return;
    }

    try {
      final result = await ArticleApi().getArticlesByCursor(
        lastId: lastId,
        pageSize: 10,
      );

      if (result.code == 200) {
        print('加载成功，数据长度: ${result.data.length}');
        setState(() {
          recommendArticles.addAll(result.data);
          lastId = recommendArticles.isNotEmpty ? recommendArticles.last['id'] : null;
          hasMore = result.data.length >= 10;
        });
        print("更新上一次Id  ");
        print(lastId);
        _refreshController.loadComplete();
      }
    } catch (e) {
      print('加载更多文章失败: $e');
      _refreshController.loadFailed();
    }
  }

  Future<void> _onRefresh() async {
    try {
      final result = await ArticleApi().getRecommendArticles();
      if (result.code == 200) {
        setState(() {
          recommendArticles = result.data;
          lastId = recommendArticles.isNotEmpty ? recommendArticles.last['id'] : null;
          hasMore = true;
        });
        _refreshController.refreshCompleted();
      }
    } catch (e) {
      print('刷新失败: $e');
      _refreshController.refreshFailed();
    }
  }

  String _getRandomFitnessContent(int index) {
    final contents = [
      '今天完成了30分钟的有氧运动，感觉棒极了！💪',
      '坚持健身第${index + 1}天，继续加油！',
      '分享我的健身餐：鸡胸肉+西兰花+糙米饭 🥗',
      '今天尝试了新的HIIT训练，效果不错！🏃‍♀️',
      '记录一下今天的运动数据：跑步5公里，消耗300卡路里 🏃‍♂️'
    ];
    return contents[index % contents.length];
  }

  List<String> _getRandomFitnessImages(int index) {
    final images = [
      'https://images.unsplash.com/photo-1594737625785-a6cbdabd333c?w=500', // 健身器材
      'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?w=500', // 瑜伽
      'https://images.unsplash.com/photo-1576678927484-cc907957088c?w=500', // 跑步
      'https://images.unsplash.com/photo-1594737626072-90dc274bc2bd?w=500', // 举重
    ];
    return List.generate(index % 3 + 1, (i) => images[(index + i) % images.length]);
  }

  String _getRandomCommentContent(int index) {
    final comments = [
      '一起加油！💪',
      '你的坚持让我也充满动力！🔥',
      '这个训练计划看起来不错，我也要试试！',
      '感谢分享，学到了很多！🙏',
      '期待看到你更多的健身成果！'
    ];
    return comments[index % comments.length];
  }

  String _getRandomActivityTitle(int index) {
    final titles = [
      '周末瑜伽体验课',
      '城市马拉松比赛',
      '健身达人分享会',
      '户外徒步活动',
      'CrossFit挑战赛'
    ];
    return titles[index % titles.length];
  }

  String _getRandomActivityImage(int index) {
    final images = [
      'https://images.unsplash.com/photo-1544367567-0f2fcb0091ae?w=500', // 瑜伽
      'https://images.unsplash.com/photo-1552674605-db6ffd4facb5?w=500', // 马拉松
      'https://images.unsplash.com/photo-1594737625785-a6cbdabd333c?w=500', // 健身
      'https://images.unsplash.com/photo-1541532713592-79a0317b6b77?w=500', // 徒步
      'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?w=500'  // CrossFit
    ];
    return images[index % images.length];
  }

  String _getRandomActivityDescription(int index) {
    final descriptions = [
      '加入我们的瑜伽课程，放松身心，提高柔韧性。',
      '参加城市马拉松，挑战自我，享受运动的快乐。',
      '与健身达人面对面交流，学习专业的健身知识。',
      '周末户外徒步，感受大自然，锻炼身体。',
      'CrossFit挑战赛，测试你的极限，提升综合体能。'
    ];
    return descriptions[index % descriptions.length];
  }
}

