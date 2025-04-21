import 'package:flutter/material.dart';
import 'package:demo_project/common/logger.dart';

class LogPage extends StatefulWidget {
  @override
  _LogPageState createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  String selectedLevel = 'ALL';  // 默认显示所有日志
  List<Map<String, dynamic>> logs = [];
  final int maxMessageLength = 100; // 限制消息的最大长度

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  // 加载日志数据
  _loadLogs() async {
    List<Map<String, dynamic>> logData = await AppLogger.getLogs(selectedLevel);
    setState(() {
      logs = logData;
    });
  }

  // 为不同的日志级别指定不同的颜色
  Color _getLogLevelColor(String level) {
    switch (level) {
      case 'ERROR':
        return Colors.red;
      case 'WARNING':
        return Colors.orange;
      case 'INFO':
        return Colors.blue;
      case 'DEBUG':
        return Colors.green;
      case 'VERBOSE':
        return Colors.purple;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Logs"),
        actions: [
          DropdownButton<String>(
            value: selectedLevel,
            icon: Icon(Icons.filter_list),
            onChanged: (String? newValue) {
              setState(() {
                selectedLevel = newValue!;
                _loadLogs();  // 根据选中的日志级别重新加载日志
              });
            },
            items: <String>['ALL', 'INFO', 'ERROR', 'WARNING', 'DEBUG', 'VERBOSE']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: AppLogger.getLogs(selectedLevel),  // 获取日志
          builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No logs found.'));
            }
            List<Map<String, dynamic>> logData = snapshot.data!;
            return ListView.builder(
              itemCount: logData.length,
              itemBuilder: (context, index) {
                final log = logData[index];

                // Check if error or stack trace exists
                bool hasError = log['error'] != '' && log['error'] != null;
                bool hasStackTrace = log['stackTrace'] != '' && log['stackTrace'] != null;

                // 截断日志消息
                String truncatedMessage = log['message'].length > maxMessageLength
                    ? log['message'].substring(0, maxMessageLength) + '...'
                    : log['message'];

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  color: _getLogLevelColor(log['level']).withOpacity(0.1), // 设置背景颜色
                  child: ListTile(
                    title: Text(truncatedMessage),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(log['timestamp']),
                      ],
                    ),
                    trailing: Text(
                      log['level'],
                      style: TextStyle(
                        color: _getLogLevelColor(log['level']), // 设置文本颜色
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // 点击查看更多详细信息
                    onTap: () => _showFullLogDialog(context, log),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 显示清空日志确认对话框
          _showClearLogsConfirmationDialog(context);
        },
        child: Icon(Icons.delete),
      ),
    );
  }

  // 弹出清空日志确认对话框
  void _showClearLogsConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Clear Logs"),
          content: Text("Are you sure you want to clear all logs?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();  // 关闭对话框
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                AppLogger.clearLogs();  // 清空日志
                _loadLogs();  // 重新加载日志
                Navigator.of(context).pop();  // 关闭对话框
              },
              child: Text("Clear"),
            ),
          ],
        );
      },
    );
  }

  // 弹出显示完整日志的对话框
  void _showFullLogDialog(BuildContext context, Map<String, dynamic> log) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('日志详情'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('消息: ${log['message']}'),
                Text('时间戳: ${log['timestamp']}'),
                if (log['error'] != '' && log['error'] != null) Text('错误: ${log['error']}'),
                if (log['stackTrace'] != '' && log['stackTrace'] != null) Text('堆栈: ${log['stackTrace']}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();  // 关闭对话框
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }
}