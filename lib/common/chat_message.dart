import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Message {
  String content;
  final bool isUser;
  final DateTime timestamp;

  Message({
    required this.content,
    required this.isUser,
    required this.timestamp,
  });
}

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({super.key, required this.message});

  // 简单的函数来处理Markdown
  List<Widget> _parseMarkdown(String text) {
    List<Widget> widgets = [];
    final RegExp boldRegExp = RegExp(r'(\*\*|__)(.*?)\1');
    final RegExp italicRegExp = RegExp(r'(\*|_)(.*?)\1');
    final RegExp codeRegExp = RegExp(r'`(.*?)`');

    // 处理代码块
    text = text.replaceAllMapped(codeRegExp, (match) {
      return '`' + match.group(1)! + '`';
    });

    // 处理加粗
    text = text.replaceAllMapped(boldRegExp, (match) {
      return '**' + match.group(2)! + '**';
    });

    // 处理斜体
    text = text.replaceAllMapped(italicRegExp, (match) {
      return '*' + match.group(2)! + '*';
    });

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser)
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: CircleAvatar(
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.smart_toy, color: Colors.white),
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: message.isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: message.isUser
                        ? Colors.blueAccent.withOpacity(0.1)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: message.isUser
                          ? Colors.blueAccent.withOpacity(0.3)
                          : Colors.grey.withOpacity(0.2),
                    ),
                  ),
                  child: Text(
                    message.content,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    DateFormat('HH:mm').format(message.timestamp),
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (message.isUser)
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: CircleAvatar(
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.person, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
