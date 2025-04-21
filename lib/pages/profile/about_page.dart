import 'package:flutter/material.dart';
import 'package:demo_project/common/page_scaffold.dart';  // 引入 PageScaffold

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: const Text('关于软件'),
      leading: getPopLeading(context),  // 返回按钮
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // 软件介绍卡片
            _buildAppDescriptionCard(),
            const SizedBox(height: 16),
            // 版本信息卡片
            _buildVersionInfoCard(),
            const SizedBox(height: 16),
            // 开发者信息卡片
            _buildDeveloperInfoCard(),
            const SizedBox(height: 16),
            // 隐私政策与用户协议卡片
            _buildPrivacyPolicyCard(),
          ],
        ),
      ),
    );
  }

  // 软件介绍卡片
  Widget _buildAppDescriptionCard() {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        title: const Text('应用介绍'),
        subtitle: const Text(
          '这款应用致力于为用户提供便捷、高效的操作体验，主要功能包括：\n- 管理个人信息\n- 提供个性化设置\n- 提供反馈渠道以优化用户体验',
          style: TextStyle(fontSize: 14),
        ),
        leading: const Icon(Icons.info_outline),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // 可以跳转到其他页面，比如“详细介绍”
        },
      ),
    );
  }

  // 版本信息卡片
  Widget _buildVersionInfoCard() {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        title: const Text('版本信息'),
        subtitle: const Text('当前版本：v1.0.0'),
        leading: const Icon(Icons.person_outlined),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // 可跳转到更新日志页面（如果有）
        },
      ),
    );
  }

  // 开发者信息卡片
  Widget _buildDeveloperInfoCard() {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        title: const Text('开发者信息'),
        subtitle: const Text(
          '开发者：张三\n联系方式：1234567890\n邮箱：developer@example.com',
          style: TextStyle(fontSize: 14),
        ),
        leading: const Icon(Icons.developer_mode),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // 可以跳转到开发者联系页面
        },
      ),
    );
  }

  // 隐私政策与用户协议卡片
  Widget _buildPrivacyPolicyCard() {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        title: const Text('隐私政策与用户协议'),
        subtitle: const Text('阅读和同意隐私政策与用户协议'),
        leading: const Icon(Icons.security),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // 跳转到隐私政策与用户协议页面
        },
      ),
    );
  }
}