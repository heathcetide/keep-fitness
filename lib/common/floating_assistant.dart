import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'chat_message.dart';

class FloatingAssistant extends StatefulWidget {
  @override
  _FloatingAssistantState createState() => _FloatingAssistantState();
}

class _FloatingAssistantState extends State<FloatingAssistant> with SingleTickerProviderStateMixin {
  double _xPosition = 100;
  double _yPosition = 100;
  bool _isVisible = true;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  double _dragOpacity = 1.0;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut)
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                openBuilder: (context, _) => ChatWindow(),
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
            left: _xPosition - 50,
            top: _yPosition - 80,
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
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
          '点我咨询\n双击打开聊天',
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
}

class ChatWindow extends StatefulWidget {
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

    _controller.clear();
    _scrollToBottom();

    // 模拟AI回复
    await Future.delayed(Duration(seconds: 1));

    final aiMessage = Message(
      content: "您好！我是您的AI助手，当前为演示版本。以下是一些示例回复：\n\n"
          "```python\nprint('Hello World!')\n```\n\n"
          "**功能特点**\n"
          "- 多行文本支持\n- 代码高亮\n- 实时交互\n- 上下文记忆",
      isUser: false,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(aiMessage);
      _isAIThinking = false;
    });
    _scrollToBottom();
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
        title: Text("AI 助手"),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => setState(_messages.clear),
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