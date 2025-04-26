import 'package:demo_project/pages/fitness_app/models/tabIcon_data.dart';
import 'package:demo_project/pages/fitness_app/training/training_screen.dart';
import 'package:flutter/material.dart';
import '../../common/floating_assistant.dart';
import 'bottom_navigation_view/bottom_bar_view.dart';
import 'community/community.dart';
import 'fitness_app_theme.dart';
import 'mine/profile.dart';
import 'my_diary/my_diary_screen.dart';

class FitnessAppHomeScreen extends StatefulWidget {
  @override
  _FitnessAppHomeScreenState createState() => _FitnessAppHomeScreenState();
}

class _FitnessAppHomeScreenState extends State<FitnessAppHomeScreen>
    with TickerProviderStateMixin {
  AnimationController? animationController;

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  Widget tabBody = Container(
    color: FitnessAppTheme.background,
  );

  @override
  void initState() {
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;

    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    tabBody = MyDiaryScreen(animationController: animationController);
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: FitnessAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return LayoutBuilder(
                builder: (context, constraints) {
                  final bottomNavHeight = 80.0; // 底部导航栏高度
                  return Stack(
                    children: <Widget>[
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        bottom: bottomNavHeight, // 为底部导航栏留出空间
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: constraints.maxHeight - bottomNavHeight,
                          ),
                          child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: constraints.maxHeight - bottomNavHeight,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min, // 关键修改
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: tabBody,
                                  ),
                                ],
                              ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: _buildBottomNavigation(),
                      ),
                      FloatingAssistant(),
                    ],
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  Widget _buildBottomNavigation() {
    return BottomBarView(
      tabIconsList: tabIconsList,
      addClick: () {},
      changeIndex: (int index) {
        if (index == 0) {
          _updateTabBody(MyDiaryScreen(animationController: animationController));
        } else if (index == 1) {
          _updateTabBody(TrainingScreen(animationController: animationController));
        } else if (index == 2) {
          _updateTabBody(CommunityScreen(animationController: animationController));
        } else if (index == 3) {
          _updateTabBody(MyProfileScreen(animationController: animationController));
        }
      },
    );
  }

  void _updateTabBody(Widget newBody) {
    animationController?.reverse().then<dynamic>((data) {
      if (!mounted) return;
      setState(() => tabBody = newBody);
    });
  }
}
