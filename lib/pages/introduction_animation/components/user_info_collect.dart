import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import '../../../api/user_api.dart';
import '../model/user_profile.dart';

import 'package:flutter/material.dart';

import '../model/user_profile.dart';

class PersonalInfoPage extends StatefulWidget {
  final AnimationController animationController;
  final UserProfileForm form;

  const PersonalInfoPage({Key? key, required this.animationController, required this.form}) : super(key: key);

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  late TextEditingController nicknameController;
  late TextEditingController ageController;
  late TextEditingController heightController;
  late TextEditingController weightController;

  @override
  void initState() {
    super.initState();
    ageController = TextEditingController(text: widget.form.age?.toString() ?? "");
    heightController = TextEditingController(text: widget.form.heightCm?.toString() ?? "");
    weightController = TextEditingController(text: widget.form.weightKg?.toString() ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(begin: Offset(1, 0), end: Offset.zero)
          .animate(CurvedAnimation(parent: widget.animationController, curve: Curves.easeOut)),
      child: Scaffold(
        backgroundColor: const Color(0xffF7EBE1),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Text(
            "基础信息填写",
            style: TextStyle(color: Colors.black87, fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIntro("请填写您的基本信息，便于我们为您提供个性化建议"),
              _buildLabel("性别"),
              Row(
                children: [
                  _buildGenderButton("男"),
                  const SizedBox(width: 16),
                  _buildGenderButton("女"),
                ],
              ),

              _buildLabel("年龄"),
              _buildInputField(hint: "请输入您的年龄", controller: ageController, onChanged: (v) => widget.form.age = int.tryParse(v)),

              _buildLabel("身高（厘米）"),
              _buildInputField(hint: "请输入您的身高", controller: heightController, onChanged: (v) => widget.form.heightCm = double.tryParse(v)),

              _buildLabel("体重（公斤）"),
              _buildInputField(hint: "请输入您的体重", controller: weightController, onChanged: (v) => widget.form.weightKg = double.tryParse(v)),

              const SizedBox(height: 48),
              _buildNextButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIntro(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 32),
    child: Text(text, style: const TextStyle(fontSize: 16, color: Colors.black54)),
  );

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8, top: 24),
    child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
  );

  Widget _buildInputField({required String hint, required TextEditingController controller, required ValueChanged<String> onChanged}) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildGenderButton(String label) {
    final isSelected = widget.form.gender == label;
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            widget.form.gender = label;
          });
        },
        child: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? const Color(0xff132137) : Colors.white,
          foregroundColor: isSelected ? Colors.white : Colors.black87,
          side: const BorderSide(color: Colors.grey),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(context, _createRoute(HealthInfoPage(animationController: widget.animationController, form: widget.form)));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff132137),
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        ),
        child: const Text("下一步", style: TextStyle(fontSize: 18)),
      ),
    );
  }

  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
            .chain(CurveTween(curve: Curves.ease));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }
}

class HealthInfoPage extends StatelessWidget {
  final AnimationController animationController;
  final UserProfileForm form;

  const HealthInfoPage({Key? key, required this.animationController, required this.form}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final medicalController = TextEditingController(text: form.medicalHistory ?? "");
    final exerciseController = TextEditingController(text: form.exerciseHabit ?? "");
    final dietController = TextEditingController(text: form.dietPreference ?? "");
    final sleepController = TextEditingController(text: form.sleepHours?.toString() ?? "");
    final smokingController = TextEditingController(text: form.smokingHabit ?? "");

    return SlideTransition(
      position: Tween<Offset>(begin: Offset(1, 0), end: Offset.zero)
          .animate(CurvedAnimation(parent: animationController, curve: Curves.easeOut)),
      child: Scaffold(
        backgroundColor: const Color(0xffF7EBE1),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () {
              Navigator.pop(context); // 返回上一页
            },
          ),
          title: const Text(
            "完善健康信息",
            style: TextStyle(color: Colors.black87, fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIntro("请填写您的健康相关信息，帮助我们更好了解您"),

              _buildLabel("过往病史"),
              _buildInputField(hint: "如高血压、糖尿病等", controller: medicalController, onChanged: (v) => form.medicalHistory = v),

              _buildLabel("运动习惯"),
              _buildInputField(hint: "每周运动几次？", controller: exerciseController, onChanged: (v) => form.exerciseHabit = v),

              _buildLabel("饮食偏好"),
              _buildInputField(hint: "偏好素食/高蛋白等", controller: dietController, onChanged: (v) => form.dietPreference = v),

              _buildLabel("每日睡眠时长"),
              _buildInputField(hint: "单位：小时", controller: sleepController, onChanged: (v) => form.sleepHours = double.tryParse(v)),

              _buildLabel("是否有抽烟习惯"),
              _buildInputField(hint: "是/否", controller: smokingController, onChanged: (v) => form.smokingHabit = v),

              const SizedBox(height: 48),
              _buildNextButton(context, GoalSettingPage(animationController: animationController, form: form)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIntro(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 32),
    child: Text(text, style: const TextStyle(fontSize: 16, color: Colors.black54)),
  );

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8, top: 24),
    child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
  );

  Widget _buildInputField({required String hint, required TextEditingController controller, required ValueChanged<String> onChanged}) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildNextButton(BuildContext context, Widget nextPage) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(context, _createRoute(nextPage));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff132137),
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        ),
        child: const Text("下一步", style: TextStyle(fontSize: 18)),
      ),
    );
  }

  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
            .chain(CurveTween(curve: Curves.ease));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }
}
class GoalSettingPage extends StatelessWidget {
  final AnimationController animationController;
  final UserProfileForm form;

  const GoalSettingPage({Key? key, required this.animationController, required this.form}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final targetWeightController = TextEditingController(text: form.targetWeight?.toString() ?? "");
    final goalDurationController = TextEditingController(text: form.goalDurationWeeks?.toString() ?? "");
    final calorieGoalController = TextEditingController(text: form.dailyCalorieGoal?.toString() ?? "");
    final stepsGoalController = TextEditingController(text: form.dailyStepsGoal?.toString() ?? "");

    return SlideTransition(
      position: Tween<Offset>(begin: Offset(1, 0), end: Offset.zero)
          .animate(CurvedAnimation(parent: animationController, curve: Curves.easeOut)),
      child: Scaffold(
        backgroundColor: const Color(0xffF7EBE1),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            "制定目标",
            style: TextStyle(color: Colors.black87, fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),

        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIntro("设定清晰可行的目标，帮助我们为您制定计划"),

              _buildLabel("目标体重（kg）"),
              _buildInputField(hint: "请输入目标体重", controller: targetWeightController, onChanged: (v) => form.targetWeight = double.tryParse(v)),

              _buildLabel("目标周期（周）"),
              _buildInputField(hint: "例如12周", controller: goalDurationController, onChanged: (v) => form.goalDurationWeeks = int.tryParse(v)),

              _buildLabel("每日卡路里目标"),
              _buildInputField(hint: "请输入每日摄入卡路里", controller: calorieGoalController, onChanged: (v) => form.dailyCalorieGoal = int.tryParse(v)),

              _buildLabel("每日步数目标"),
              _buildInputField(hint: "例如10000步", controller: stepsGoalController, onChanged: (v) => form.dailyStepsGoal = int.tryParse(v)),

              const SizedBox(height: 48),
              _buildNextButton(context, ContactInfoPage(form: form)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIntro(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 32),
    child: Text(text, style: const TextStyle(fontSize: 16, color: Colors.black54)),
  );

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8, top: 24),
    child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
  );

  Widget _buildInputField({required String hint, required TextEditingController controller, required ValueChanged<String> onChanged}) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildNextButton(BuildContext context, Widget nextPage) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(context, _createRoute(nextPage));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff132137),
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        ),
        child: const Text("下一步", style: TextStyle(fontSize: 18)),
      ),
    );
  }

  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
            .chain(CurveTween(curve: Curves.ease));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }
}
class ContactInfoPage extends StatelessWidget {
  final UserProfileForm form;

  const ContactInfoPage({Key? key, required this.form}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bodyFatController = TextEditingController(text: form.bodyFatPercent?.toString() ?? "");
    final muscleMassController = TextEditingController(text: form.muscleMass?.toString() ?? "");
    final bmrController = TextEditingController(text: form.bmr?.toString() ?? "");
    final bmiController = TextEditingController(text: form.bmi?.toString() ?? "");
    final waistController = TextEditingController(text: form.waistCm?.toString() ?? "");
    final hipController = TextEditingController(text: form.hipCm?.toString() ?? "");

    return Scaffold(
      backgroundColor: const Color(0xffF7EBE1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "补充身体数据(选填)",
          style: TextStyle(color: Colors.black87, fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel("体脂率（%）"),
            _buildInputField(hint: "请输入体脂率", controller: bodyFatController, onChanged: (v) => form.bodyFatPercent = double.tryParse(v)),

            _buildLabel("肌肉量（kg）"),
            _buildInputField(hint: "请输入肌肉量", controller: muscleMassController, onChanged: (v) => form.muscleMass = double.tryParse(v)),

            _buildLabel("基础代谢率（BMR）"),
            _buildInputField(hint: "请输入BMR", controller: bmrController, onChanged: (v) => form.bmr = double.tryParse(v)),

            _buildLabel("BMI指数"),
            _buildInputField(hint: "请输入BMI", controller: bmiController, onChanged: (v) => form.bmi = double.tryParse(v)),

            _buildLabel("腰围（cm）"),
            _buildInputField(hint: "请输入腰围", controller: waistController, onChanged: (v) => form.waistCm = double.tryParse(v)),

            _buildLabel("臀围（cm）"),
            _buildInputField(hint: "请输入臀围", controller: hipController, onChanged: (v) => form.hipCm = double.tryParse(v)),

            const SizedBox(height: 48),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  print('提交表单数据: ${form.toJson()}');
                  // 调用接口发送数据
                  final response = await UserApi().addAndUpdateUserProfile(form);
                  if (response.code == 200) {
                    Navigator.pushReplacementNamed(context, '/');
                  } else {
                    // 失败的话可以弹个提示
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('提交失败：${response.message ?? '未知错误'}')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff132137),
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                ),
                child: const Text("完成", style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8, top: 24),
    child: Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
  );

  Widget _buildInputField({required String hint, required TextEditingController controller, required ValueChanged<String> onChanged}) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}