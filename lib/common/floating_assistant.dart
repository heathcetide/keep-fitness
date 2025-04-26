import 'dart:async';

import 'package:demo_project/api/user_api.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'chat_message.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';

class FloatingAssistant extends StatefulWidget {
  @override
  _FloatingAssistantState createState() => _FloatingAssistantState();
}

class _FloatingAssistantState extends State<FloatingAssistant> with SingleTickerProviderStateMixin {
  double _xPosition = 280;
  double _yPosition = 600;
  bool _isVisible = true;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  double _dragOpacity = 1.0;
  bool _isDragging = false;
  String _tipMessage = '正在获取智能建议...';
  Timer? _tipTimer;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _fetchTipMessage(); // 初始调用
    _tipTimer = Timer.periodic(Duration(minutes: 5), (_) => _fetchTipMessage());
  }

  @override
  void dispose() {
    _animationController.dispose();
    _tipTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;


    return Stack(
      children: [
        AnimatedPositioned(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeOut,
          left: _xPosition,
          top: _yPosition,
          child: GestureDetector(
            onPanStart: (_) {
              _animationController.forward();
              setState(() {
                _isDragging = true;
                _dragOpacity = 0.7;
              });
            },
            onPanUpdate: (details) {
              setState(() {
                _xPosition += details.delta.dx;
                _yPosition += details.delta.dy;

                // 限制边界（同时考虑提示气泡和悬浮球）
                final maxX = screenWidth - 60;
                final maxY = screenHeight - 60 - 90; // 60球 + 30气泡高度

                _xPosition = _xPosition.clamp(0, maxX);
                _yPosition = _yPosition.clamp(0, maxY);
              });
            },
            onPanEnd: (_) {
              _animationController.reverse();
              setState(() {
                _isDragging = false;
                _dragOpacity = 1.0;
                // 限制边界
                final screenWidth = MediaQuery.of(context).size.width;
                if (_xPosition < 0) _xPosition = 0;
                if (_xPosition > screenWidth - 60) _xPosition = screenWidth - 60;
              });
            },
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: OpenContainer(
                closedElevation: 6.0,
                closedShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                closedColor: Colors.transparent,
                openColor: Colors.white,
                transitionDuration: Duration(milliseconds: 500),
                openBuilder: (context, _) => ChatWindow(_tipMessage),
                closedBuilder: (context, openContainer) => AnimatedOpacity(
                  opacity: _dragOpacity,
                  duration: Duration(milliseconds: 200),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () {
                        HapticFeedback.lightImpact();
                        _showTip();
                      },
                      onDoubleTap: () {
                        HapticFeedback.heavyImpact();
                        openContainer();
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blueAccent, Colors.lightBlue],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              spreadRadius: 2,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            // 脉冲动画背景
                            _buildPulseEffect(),
                            Center(
                              child: Image.asset(
                                'assets/icons/message_icon.png', // 建议使用AI相关图标
                                width: 32,
                                height: 32,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (_isVisible)
          Positioned(
            left: _xPosition - 60,
            top: _yPosition - 60,
            child: _buildAnimatedTip(),
          ),
      ],
    );
  }

  Widget _buildPulseEffect() {
    return AnimatedOpacity(
      opacity: _isDragging ? 0.0 : 0.4,
      duration: Duration(milliseconds: 300),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [Colors.white.withOpacity(0.2), Colors.transparent],
            stops: [0.1, 1.0],
          ),
        ),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 1000),
          curve: Curves.easeInOut,
          margin: EdgeInsets.all(_isDragging ? 0 : 10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withOpacity(0.5),
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedTip() {
    return AnimatedOpacity(
      opacity: _isVisible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 300),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              spreadRadius: 2,
            )
          ],
        ),
        child: Text(
          _tipMessage,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _showTip() {
    if (!_isVisible) {
      setState(() => _isVisible = true);
      Future.delayed(Duration(seconds: 2), () {
        if (mounted) setState(() => _isVisible = false);
      });
    }
  }

  Future<void> _fetchTipMessage() async {
    // final tip = await getSmartTipFromAI("请根据用户健康数据，用一句话提供简洁建议");
    final tip = "请根据用户健康数据\n 用一句话提供简洁建议";
    setState(() {
      _tipMessage = tip;
    });
  }

  Future<String> getSmartTipFromAI(String prompt) async {
    var userSummary = " ";
    var baseInfo = await UserApi().getUserInfoByToken();
    if(baseInfo.code == 200){
      var userProfile = await UserApi().getUserProfile();
      var userSummary = "[附属信息: 以下是当前用户的身体数据"+baseInfo.data+userProfile.data+"]";
    }
    final dio = Dio();
    final url = 'https://try2.fit2cloud.cn/api/application/chat_message/26fc124a-201e-11f0-a05b-0242ac140003';
    final token = 'application-2b370cbd857c4c64fb974cd4da2a3888';

    final data = {
      "0": "n",
      "1": "e",
      "2": "w",
      "message": prompt + "(备注: 请用普通文本格式, 不支持Markdown格式, 不要包含HTML标签, 每次回答请不要超过40个字符 每次回答请不要超过40个字符" + userSummary + ")",
      "re_chat": false,
      "form_data": {}
    };

    final options = Options(
      headers: {
        "Content-Type": "application/json",
        "Authorization": token,
      },
      responseType: ResponseType.stream,
    );

    try {
      final response = await dio.post<ResponseBody>(url, data: data, options: options);
      final stream = response.data!.stream
          .transform(StreamTransformer.fromBind((s) => s.cast<List<int>>().transform(utf8.decoder)));

      StringBuffer buffer = StringBuffer();

      await for (final line in stream) {
        final trimmed = line.trim();

        if (trimmed.isEmpty || !trimmed.startsWith('data:')) continue;

        final jsonPart = trimmed.substring(5);
        try {
          final jsonData = json.decode(jsonPart);
          if (jsonData["content"] != null) {
            buffer.write(jsonData["content"]);
          }
        } catch (e) {
          print("解析失败，跳过该段: $e");
          continue;
        }
      }

      String formatText(String input) {
        final buffer = StringBuffer();
        for (int i = 0; i < input.length; i++) {
          buffer.write(input[i]);
          if ((i + 1) % 8 == 0 && i != input.length - 1) {
            buffer.write('\n');
          }
        }
        return buffer.toString();
      }

      return buffer.toString().trim().isNotEmpty
          ? formatText(buffer.toString().trim()) : "小主您好\n 我是您的健康减肥智能助手\n 双击我即可跟我聊天";
    } catch (e) {
      print("AI提示获取失败: $e");
      return "小主您好\n 我是您的健康减肥智能助手\n 双击我即可跟我聊天";
    }
  }
}

class ChatWindow extends StatefulWidget {
  final String? initialMessage;

  ChatWindow(this.initialMessage);

  @override
  _ChatWindowState createState() => _ChatWindowState();
}

class _ChatWindowState extends State<ChatWindow> with AutomaticKeepAliveClientMixin {
  final TextEditingController _controller = TextEditingController();
  final List<Message> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isAIThinking = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    if (widget.initialMessage != null && widget.initialMessage!.trim().isNotEmpty) {
      // 自动发起消息
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.text = widget.initialMessage!;
        _sendMessage();
      });
    }
  }

  void _sendMessage() async {
    if (_controller.text.isEmpty) return;

    final userMessage = Message(
      content: _controller.text,
      isUser: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMessage);
      _isAIThinking = true;
    });

    final userInput = _controller.text;
    _controller.clear();
    _scrollToBottom();

    final dio = Dio();
    final url = 'https://try2.fit2cloud.cn/api/application/chat_message/26fc124a-201e-11f0-a05b-0242ac140003';
    final token = 'application-2b370cbd857c4c64fb974cd4da2a3888';

    final data = {
      "0": "n",
      "1": "e",
      "2": "w",
      "message": userInput + "(备注: 请用普通文本格式, 不支持Markdown格式, 回答请不要包含任何HTML标签和样式, 不要回答跟此备注相关的信息)",
      "re_chat": false,
      "form_data": {}
    };

    final options = Options(
      headers: {
        "Content-Type": "application/json",
        "Authorization": token,
      },
      responseType: ResponseType.stream,
    );

    try {
      final response = await dio.post<ResponseBody>(url, data: data, options: options);

      final stream = response.data!.stream
          .transform(StreamTransformer.fromBind((s) => s.cast<List<int>>().transform(utf8.decoder)));
      Message aiMessage = Message(content: '', isUser: false, timestamp: DateTime.now());

      setState(() {
        _messages.add(aiMessage);
      });
      print("AI消息内容更新: ${aiMessage.content}");
      await for (final line in stream) {
        final trimmed = line.trim();
        if (trimmed.startsWith("data:")) {
          final jsonStr = trimmed.substring(5);
          try {
            final jsonData = json.decode(jsonStr);
            if (jsonData["content"] != null) {
              // 直接修改 aiMessage 内容（引用已在 _messages 中）
              setState(() {
                aiMessage.content += jsonData["content"];
                _scrollToBottom();
              });
            }
          } catch (e) {
            print("解析失败: $e");
          }
        }
      }
    } catch (e) {
      print("AI请求出错: $e");
      setState(() {
        _messages.add(Message(
          content: "AI 请求失败，请稍后重试。",
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });
    }

    setState(() {
      _isAIThinking = false;
    });
  }
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("AI 助手"),
        titleTextStyle: TextStyle(color: Colors.black), // 设置标题文字颜色为黑色
        iconTheme: IconThemeData(color: Colors.black), // 设置图标颜色为黑色
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            color: Colors.black, // 设置图标颜色为黑色
            onPressed: () => setState(() => _messages.clear()),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  ..._messages.map((msg) => MessageBubble(message: msg)),
                  if (_isAIThinking) _buildTypingIndicator(),
                ],
              ),
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
          Text("AI正在思考...",
              style: TextStyle(color: Colors.grey, fontSize: 14)),
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
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
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