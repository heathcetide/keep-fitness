import 'package:flutter/material.dart';
import '../../../api/user_api.dart';
import '../../../common/local_storage.dart';


class ProfileSummaryCard extends StatelessWidget {
  final AnimationController animationController;
  final Animation<double> animation;

  const ProfileSummaryCard({
    super.key,
    required this.animationController,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    final user = UserProfile.fromLocalStorage();

    return FadeTransition(
      opacity: animation,
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, '/profile_detail'),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 35,
                backgroundImage: user.avatarUrl.isNotEmpty
                    ? NetworkImage(user.avatarUrl)
                    : const AssetImage('assets/images/supportIcon.png') as ImageProvider,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.username,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.bio.isNotEmpty ? user.bio : '这个人很懒，什么也没写~',
                      style: const TextStyle(color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileInfoView extends StatefulWidget {
  const ProfileInfoView({super.key});

  @override
  State<ProfileInfoView> createState() => _ProfileInfoViewState();
}

class _ProfileInfoViewState extends State<ProfileInfoView> {
  late UserProfile user;

  @override
  void initState() {
    super.initState();
    user = UserProfile.fromLocalStorage();
  }

  void refreshUser() {
    setState(() {
      user = UserProfile.fromLocalStorage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(
          '个人资料',
          style: TextStyle(color: Colors.black87),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _submitUserInfoToBackend,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: user.avatarUrl.isNotEmpty
                        ? NetworkImage(user.avatarUrl)
                        : const AssetImage('assets/images/supportIcon.png')
                    as ImageProvider,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user.username,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    user.bio.isNotEmpty ? user.bio : '这个人很懒，什么也没写~',
                    style: const TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              '基础信息',
              style:
              TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            _buildEditableInfo(Icons.email, '邮箱', user.email, 'email'),
            _buildEditableInfo(Icons.phone, '电话', user.phone, 'phone'),
            _buildEditableInfo(Icons.location_on, '地址', user.address, 'address'),
            _buildEditableInfo(Icons.cake, '生日', user.birthday, 'birthday'),
            _buildEditableInfo(Icons.wc, '性别', _genderText(user.gender), 'gender'),

            const SizedBox(height: 24),
            const Text(
              '账户信息',
              style:
              TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            _buildInfoTile(Icons.timeline, '积分', user.points),
            _buildInfoTile(Icons.article, '文章数', user.articleCount),
            _buildInfoTile(Icons.event, '活动数', user.activityCount),
            _buildInfoTile(Icons.access_time, '最后登录', user.lastLoginTime),
            _buildInfoTile(Icons.calendar_today, '注册时间', user.createdAt),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableInfo(IconData icon, String label, String value, String fieldKey) {
    final isEditable = fieldKey != 'email' && fieldKey != 'phone';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '$label：${value.isNotEmpty ? value : '暂无信息'}',
              style: const TextStyle(fontSize: 15, color: Colors.black87),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (isEditable)
            IconButton(
              icon: const Icon(Icons.edit, size: 18, color: Colors.grey),
              onPressed: () async {
                final result = await showDialog(
                  context: context,
                  builder: (_) => EditProfileFieldDialog(
                    title: label,
                    fieldKey: fieldKey,
                    initialValue: value,
                    onSave: (key, value) {
                      LocalStorage.fieldMap[key]?.set(value);
                      setState(() {
                        user = UserProfile.fromLocalStorage();
                      });
                      refreshUser(); // 刷新用户数据
                    },
                  ),
                );
                if (result == true) refreshUser();
              },
            ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '$label：${value.isNotEmpty ? value : '暂无信息'}',
              style: const TextStyle(fontSize: 15, color: Colors.black87),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _genderText(int gender) {
    return gender == 1 ? '男' : gender == 0 ? '女' : '保密';
  }

  Future<void> _submitUserInfoToBackend() async {
    final result = await UserApi().updateUserProfile(user);

    if (result.code == 200) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('信息已成功保存')),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.message ?? '保存失败')),
        );
      }
    }
  }
}

class EditProfileFieldDialog extends StatefulWidget {
  final String title;           // 显示用标题
  final String fieldKey;        // 存储使用的 key
  final String initialValue;    // 当前值
  final void Function(String key, String value) onSave;

  const EditProfileFieldDialog({
    Key? key,
    required this.title,
    required this.fieldKey,
    required this.initialValue,
    required this.onSave,
  }) : super(key: key);

  @override
  State<EditProfileFieldDialog> createState() => _EditProfileFieldDialogState();
}

class _EditProfileFieldDialogState extends State<EditProfileFieldDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('修改 ${widget.title}'),
      content: widget.fieldKey == 'gender'
          ? _buildGenderSelector()
          : widget.fieldKey == 'birthday'
          ? _buildDateSelector(context)
          : TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: '请输入${widget.title}',
          border: const OutlineInputBorder(),
        ),
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        ElevatedButton(
          onPressed: () {
            final result = widget.fieldKey == 'birthday'
                ? _controller.text
                : _controller.text.trim();
            widget.onSave(widget.fieldKey, result);
            Navigator.of(context).pop(true);
          },
          child: const Text('保存'),
        ),
      ],
    );
  }

  Widget _buildGenderSelector() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [1, 0].map((g) {
        return RadioListTile<int>(
          value: g,
          groupValue: int.tryParse(_controller.text) ?? 0,
          title: Text(g == 1 ? '男' : '女'),
          onChanged: (val) {
            setState(() => _controller.text = val.toString());
          },
        );
      }).toList(),
    );
  }

  Widget _buildDateSelector(BuildContext context) {
    return InkWell(
      onTap: () async {
        final now = DateTime.now();
        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime.tryParse(_controller.text) ?? DateTime(2000),
          firstDate: DateTime(1900),
          lastDate: now,
        );
        if (picked != null) {
          final formatted = '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
          setState(() => _controller.text = formatted);
        }
      },
      child: IgnorePointer(
        child: TextField(
          controller: _controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            suffixIcon: Icon(Icons.calendar_today),
          ),
        ),
      ),
    );
  }
}