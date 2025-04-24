import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:ionicons/ionicons.dart';
import 'package:demo_project/common/helper_functions.dart';

import 'package:demo_project/common/constants.dart';
import '../../../api/user_api.dart';
import '../../../common/local_storage.dart';
import '../animations/change_screen_animation.dart';
import 'bottom_text.dart';
import 'top_text.dart';

enum Screens {
  createAccount,
  welcomeBack,
}

class LoginContent extends StatefulWidget {
  const LoginContent({Key? key}) : super(key: key);

  @override
  State<LoginContent> createState() => _LoginContentState();
}

class _LoginContentState extends State<LoginContent>
    with TickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late final List<Widget> createAccountContent;
  late final List<Widget> loginContent;

  Widget inputField(String hint, IconData iconData, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 8),
      child: SizedBox(
        height: 50,
        child: Material(
          elevation: 8,
          shadowColor: Colors.black87,
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          child: TextField(
            controller: controller,
            textAlignVertical: TextAlignVertical.bottom,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              hintText: hint,
              prefixIcon: Icon(iconData),
            ),
          ),
        ),
      ),
    );
  }

  Widget loginButton(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 135, vertical: 16),
      child: ElevatedButton(
        onPressed: () {
          // 发送验证码逻辑
          sendVerificationCode(_emailController.text);
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14), backgroundColor: kSecondaryColor,
          shape: const StadiumBorder(),
          elevation: 8,
          shadowColor: Colors.black87,
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget registerButton(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
      child: ElevatedButton(
        onPressed: () {
          // 注册逻辑
          registerUser(
            _emailController.text,
            _codeController.text,
          );
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14), backgroundColor: kSecondaryColor,
          shape: const StadiumBorder(),
          elevation: 8,
          shadowColor: Colors.black87,
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget verifyCodeField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 50,
              child: Material(
                elevation: 8,
                shadowColor: Colors.black87,
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(30),
                child: TextField(
                  controller: _codeController,
                  textAlignVertical: TextAlignVertical.bottom,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Verification Code',
                    prefixIcon: Icon(Icons.code),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // 新增: 发送验证码按钮
          ValueListenableBuilder<int>(
            valueListenable: _countdownNotifier,
            builder: (context, value, child) {
              return ElevatedButton(
                onPressed: value == 0 ? _startCountdown : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  backgroundColor: kSecondaryColor,
                  shape: const StadiumBorder(),
                  elevation: 8,
                  shadowColor: Colors.black87,
                ),
                child: Text(
                  value == 0 ? 'Send Code' : '$value s',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget verifyButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
      child: ElevatedButton(
        onPressed: () {
          // 验证验证码逻辑
          verifyCode(_emailController.text, _codeController.text);
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          backgroundColor: kSecondaryColor,
          shape: const StadiumBorder(),
          elevation: 8,
          shadowColor: Colors.black87,
        ),
        child: Text(
          'Verify',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget orDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 130, vertical: 8),
      child: Row(
        children: [
          Flexible(
            child: Container(
              height: 1,
              color: kPrimaryColor,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
          ),
          Flexible(
            child: Container(
              height: 1,
              color: kPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }



  Widget forgotPassword() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 110),
      child: TextButton(
        onPressed: () {},
        child: const Text(
          'Forgot Password?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: kSecondaryColor,
          ),
        ),
      ),
    );
  }

  // 新增: 发送验证码方法
  Future<void> sendVerificationCode(String email) async {
    var response = await UserApi().sendEmailVerificationCode(email);
    if (response.code == 200) {
      SmartDialog.showToast('验证码已发送，请查收');
    } else {
      SmartDialog.showToast('发送验证码失败，请重试');
    }
  }

  // 新增: 用户注册方法
  Future<void> registerUser(String email, String code) async {
    var response = await UserApi().register(code, email);
    if (response.code == 200) {
      SmartDialog.showToast('注册成功');
      Navigator.pushReplacementNamed(context, '/introduction_animation');
      LocalStorage.access_token.set(response.data['accessToken']?.toString() ?? '');
      LocalStorage.refresh_token.set(response.data['refreshToken']?.toString() ?? '');
      LocalStorage.user_userName.set(response.data['username']?.toString() ?? '');
      LocalStorage.user_email.set(response.data['email']?.toString() ?? '');
      LocalStorage.user_phone.set(response.data['phone']?.toString() ?? '');
      LocalStorage.user_address.set(response.data['address']?.toString() ?? '');
      LocalStorage.user_points.set(response.data['points']?.toString() ?? '');
      LocalStorage.user_articleCount.set(response.data['articleCount']?.toString() ?? '');
      LocalStorage.user_activityCount.set(response.data['activityCount']?.toString() ?? '');
      LocalStorage.user_gender.set(response.data['gender']?.toString() ?? '');
      LocalStorage.user_bio.set(response.data['bio']?.toString() ?? '');
      LocalStorage.user_birthday.set(response.data['birthday']?.toString() ?? '');
      LocalStorage.user_lastLoginTime.set(response.data['lastLoginTime']?.toString() ?? '');
      LocalStorage.user_createdAt.set(response.data['createdAt']?.toString() ?? '');
      LocalStorage.user_avatarUrl.set(response.data['avatarUrl']?.toString() ?? '');
    } else {
      SmartDialog.showToast(response.message ?? '注册失败，请重试');
    }
  }

  // 新增: 验证验证码方法
  Future<void> verifyCode(String email, String code) async {
    var response = await UserApi().login(code, email);
    if (response.code == 200) {
      SmartDialog.showToast('欢迎回来');
      Navigator.pushReplacementNamed(context, '/');
      LocalStorage.access_token.set(response.data['accessToken']?.toString() ?? '');
      LocalStorage.refresh_token.set(response.data['refreshToken']?.toString() ?? '');
      LocalStorage.user_userName.set(response.data['username']?.toString() ?? '');
      LocalStorage.user_email.set(response.data['email']?.toString() ?? '');
      LocalStorage.user_phone.set(response.data['phone']?.toString() ?? '');
      LocalStorage.user_address.set(response.data['address']?.toString() ?? '');
      LocalStorage.user_points.set(response.data['points']?.toString() ?? '');
      LocalStorage.user_articleCount.set(response.data['articleCount']?.toString() ?? '');
      LocalStorage.user_activityCount.set(response.data['activityCount']?.toString() ?? '');
      LocalStorage.user_gender.set(response.data['gender']?.toString() ?? '');
      LocalStorage.user_bio.set(response.data['bio']?.toString() ?? '');
      LocalStorage.user_birthday.set(response.data['birthday']?.toString() ?? '');
      LocalStorage.user_lastLoginTime.set(response.data['lastLoginTime']?.toString() ?? '');
      LocalStorage.user_createdAt.set(response.data['createdAt']?.toString() ?? '');
      LocalStorage.user_avatarUrl.set(response.data['avatarUrl']?.toString() ?? '');
    } else {
      SmartDialog.showToast(response.message ?? '登录失败请重试');
    }
  }

  @override
  void initState() {
    createAccountContent = [
      inputField('Email', Ionicons.mail_outline, _emailController),
      verifyCodeField(),
      registerButton('Sign Up'),
      orDivider(),
    ];

    loginContent = [
      inputField('Email', Ionicons.mail_outline, _emailController),
      verifyCodeField(),
      verifyButton(),
      forgotPassword(),
    ];

    ChangeScreenAnimation.initialize(
      vsync: this,
      createAccountItems: createAccountContent.length,
      loginItems: loginContent.length,
    );

    for (var i = 0; i < createAccountContent.length; i++) {
      createAccountContent[i] = HelperFunctions.wrapWithAnimatedBuilder(
        animation: ChangeScreenAnimation.createAccountAnimations[i],
        child: createAccountContent[i],
      );
    }

    for (var i = 0; i < loginContent.length; i++) {
      loginContent[i] = HelperFunctions.wrapWithAnimatedBuilder(
        animation: ChangeScreenAnimation.loginAnimations[i],
        child: loginContent[i],
      );
    }

    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned(
          top: 136,
          left: 24,
          child: TopText(),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: createAccountContent,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: loginContent,
              ),
            ],
          ),
        ),
        const Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: 50),
            child: BottomText(),
          ),
        ),
      ],
    );
  }

  // 新增: 倒计时控制器
  final ValueNotifier<int> _countdownNotifier = ValueNotifier<int>(0);

  // 新增: 开始倒计时的方法
  void _startCountdown() {
    _countdownNotifier.value = 60;
    sendVerificationCode(_emailController.text);
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdownNotifier.value > 0) {
        _countdownNotifier.value--;
      } else {
        timer.cancel();
      }
    });
  }
}

class ChatWindow extends StatefulWidget {
  @override
  _ChatWindowState createState() => _ChatWindowState();
}

class _ChatWindowState extends State<ChatWindow> with AutomaticKeepAliveClientMixin {
  final List<Message> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isAIThinking = false;

  @override
  bool get wantKeepAlive => true;

  void _sendMessage() {
    String message = _controller.text.trim();
    if (message.isNotEmpty) {
      _messages.add(Message(content: message, isUser: true));
      _controller.clear();
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

      setState(() {
        _isAIThinking = true;
      });

      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          _messages.add(Message(content: "这是AI的回复", isUser: false));
          _isAIThinking = false;
        });
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("AI 助手", style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.black),
            onPressed: () => setState(_messages.clear),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(16),
              itemCount: _messages.length + (_isAIThinking ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < _messages.length) {
                  return MessageBubble(message: _messages[index]);
                } else {
                  return _buildTypingIndicator();
                }
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blueAccent,
            child: Icon(Icons.smart_toy, color: Colors.white),
          ),
          SizedBox(width: 12),
          Text("AI正在思考...", style: TextStyle(color: Colors.grey, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              maxLines: 5,
              minLines: 1,
              decoration: InputDecoration(
                hintText: "输入消息...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          SizedBox(width: 12),
          CircleAvatar(
            backgroundColor: Colors.blueAccent,
            child: IconButton(
              icon: Icon(Icons.send, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final Message message;

  MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Align(
        alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: message.isUser ? Colors.blueAccent : Colors.grey[200],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            message.content,
            style: TextStyle(
              color: message.isUser ? Colors.white : Colors.black,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

class Message {
  final String content;
  final bool isUser;

  Message({required this.content, required this.isUser});
}
