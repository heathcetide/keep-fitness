import 'package:demo_project/pages/introduction_animation/components/care_view.dart';
import 'package:demo_project/pages/introduction_animation/components/center_next_button.dart';
import 'package:demo_project/pages/introduction_animation/components/mood_diary_vew.dart';
import 'package:demo_project/pages/introduction_animation/components/relax_view.dart';
import 'package:demo_project/pages/introduction_animation/components/splash_view.dart';
import 'package:demo_project/pages/introduction_animation/components/top_back_skip_view.dart';
import 'package:demo_project/pages/introduction_animation/components/welcome_view.dart';
import 'package:demo_project/pages/introduction_animation/components/user_info_collect.dart';
import 'package:flutter/material.dart';

import 'model/user_profile.dart';

class IntroductionAnimationScreen extends StatefulWidget {
  const IntroductionAnimationScreen({Key? key}) : super(key: key);

  @override
  _IntroductionAnimationScreenState createState() =>
      _IntroductionAnimationScreenState();
}

class _IntroductionAnimationScreenState
    extends State<IntroductionAnimationScreen> with TickerProviderStateMixin {
  AnimationController? _introAnimationController;
  AnimationController? _formAnimationController;
  bool _showForm = false;
  final UserProfileForm _form = UserProfileForm();

  @override
  void initState() {
    _introAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 8));
    _formAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _introAnimationController?.value = 0.0;
    _formAnimationController?.value = 0.0;
    super.initState();
  }

  @override
  void dispose() {
    _introAnimationController?.dispose();
    _formAnimationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF7EBE1),
      body: Stack(
        children: [
          // 引导动画页面
          if (!_showForm) ...[
            SplashView(animationController: _introAnimationController!),
            RelaxView(animationController: _introAnimationController!),
            CareView(animationController: _introAnimationController!),
            MoodDiaryVew(animationController: _introAnimationController!),
            WelcomeView(animationController: _introAnimationController!),
          ],
          // 表单动画页面
          if (_showForm) ...[
            PersonalInfoPage(form: _form ,animationController: _formAnimationController!),
          ],
          if (!_showForm)
            TopBackSkipView(
              onBackClick: _onBackClick,
              onSkipClick: _onSkipClick,
              animationController: _introAnimationController!,
            ),
          if (!_showForm)
            CenterNextButton(
              animationController: _introAnimationController!,
              onNextClick: _onNextClick,
            ),
        ],
      ),
    );
  }

  void _onNextClick() {
    print('Current animation value: ${_introAnimationController!.value}');
    if (_introAnimationController!.value >= 0 &&
        _introAnimationController!.value < 0.2) {
      _introAnimationController?.animateTo(0.2);
    } else if (_introAnimationController!.value >= 0.2 &&
        _introAnimationController!.value < 0.4) {
      _introAnimationController?.animateTo(0.4);
    } else if (_introAnimationController!.value >= 0.4 &&
        _introAnimationController!.value < 0.6) {
      _introAnimationController?.animateTo(0.6);
    } else if (_introAnimationController!.value >= 0.6 &&
        _introAnimationController!.value < 0.8) {
      _introAnimationController?.animateTo(0.8);
    } else if (_introAnimationController!.value >= 0.8 &&
        _introAnimationController!.value < 1.0) {
      _introAnimationController?.animateTo(1.0);
      setState(() {
        _showForm = true; // 显示表单页面
        _introAnimationController?.dispose();
      });
      _formAnimationController?.forward(); // 启动表单动画
    } else {
      _introAnimationController?.animateTo(1.0);
    }
  }

  void _onBackClick() {
    if (_introAnimationController!.value >= 0 &&
        _introAnimationController!.value <= 0.2) {
      _introAnimationController?.animateTo(0.0);
    } else if (_introAnimationController!.value > 0.2 &&
        _introAnimationController!.value <= 0.4) {
      _introAnimationController?.animateTo(0.2);
    } else if (_introAnimationController!.value > 0.4 &&
        _introAnimationController!.value <= 0.6) {
      _introAnimationController?.animateTo(0.4);
    } else if (_introAnimationController!.value > 0.6 &&
        _introAnimationController!.value <= 0.8) {
      _introAnimationController?.animateTo(0.6);
    } else if (_introAnimationController!.value > 0.8 &&
        _introAnimationController!.value <= 1.0) {
      _introAnimationController?.animateTo(0.8);
    } else {
      _introAnimationController?.animateTo(1.0);
    }
  }

  void _onSkipClick() {
    _introAnimationController?.animateTo(1.0);
    setState(() {
      _showForm = true; // 显示表单页面
    });
    _formAnimationController?.forward(); // 启动表单动画
  }

  void _signUpClick() {
    Navigator.pushNamed(context, '/');
  }
}
