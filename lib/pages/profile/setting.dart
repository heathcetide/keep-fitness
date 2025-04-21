import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:demo_project/common/page_scaffold.dart';  // 引入PageScaffold

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = false; // 主题开关状态
  bool _isNotificationsEnabled = true; // 通知开关状态
  bool _isLoggingEnabled = false; // 日志记录开关状态
  String _language = 'English'; // 当前语言

  // 模拟语言选择项
  List<String> languages = ['English', '中文', 'Español', 'Français'];

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: const Text('软件设置'),
      leading: getPopLeading(context), // 返回按钮
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildGeneralSettingsCard(),
            _buildThemeSettingsCard(),
            _buildNotificationSettingsCard(),
            _buildLoggingSettingsCard(),
            _buildLanguageSettingsCard(),
            _buildAboutAppCard(),
          ],
        ),
      ),
    );
  }

  // 基本设置卡片
  Widget _buildGeneralSettingsCard() {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          ListTile(
            title: const Text('基本设置'),
            leading: const Icon(Icons.settings),
            onTap: () {
              // 可以跳转到其他设置页面
            },
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
          ),
        ],
      ),
    );
  }

  // 主题设置卡片
  Widget _buildThemeSettingsCard() {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 16),
      child: SwitchListTile(
        value: _isDarkMode,
        onChanged: (bool value) {
          setState(() {
            _isDarkMode = value;
          });
          // 这里可以通过改变 ThemeData 来切换深色模式
          if (_isDarkMode) {
            // 切换到深色主题
            SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
          } else {
            // 切换到浅色主题
            SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
          }
        },
        title: const Text('深色模式'),
        subtitle: const Text('启用深色主题以保护眼睛'),
        secondary: const Icon(Icons.dark_mode),
      ),
    );
  }

  // 通知设置卡片
  Widget _buildNotificationSettingsCard() {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 16),
      child: SwitchListTile(
        value: _isNotificationsEnabled,
        onChanged: (bool value) {
          setState(() {
            _isNotificationsEnabled = value;
          });
        },
        title: const Text('启用通知'),
        subtitle: const Text('开启通知提醒重要事件'),
        secondary: const Icon(Icons.notifications),
      ),
    );
  }

  // 日志记录设置卡片
  Widget _buildLoggingSettingsCard() {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        title: const Text('日志记录'),
        leading: const Icon(Icons.receipt),
        onTap: () {
          // 点击后跳转到日志页面
          Navigator.pushNamed(context, '/logger'); // 使用路由跳转到日志页面
        },
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }

  // 语言设置卡片
  Widget _buildLanguageSettingsCard() {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        title: const Text('语言'),
        subtitle: Text(_language),
        leading: const Icon(Icons.language),
        onTap: () async {
          String? selectedLanguage = await _showLanguageDialog();
          if (selectedLanguage != null) {
            setState(() {
              _language = selectedLanguage;
            });
          }
        },
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }

  // 关于软件卡片
  Widget _buildAboutAppCard() {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        title: const Text('关于软件'),
        leading: const Icon(Icons.info),
        onTap: () {
          // 跳转到关于页面
        },
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }

  // 显示语言选择对话框
  Future<String?> _showLanguageDialog() async {
    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('选择语言'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: languages.map((lang) {
              return RadioListTile<String>(
                value: lang,
                groupValue: _language,
                onChanged: (String? value) {
                  Navigator.of(context).pop(value); // 选择语言后关闭对话框
                },
                title: Text(lang),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}