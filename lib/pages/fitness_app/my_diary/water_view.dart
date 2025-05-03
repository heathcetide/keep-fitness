import 'package:demo_project/pages/fitness_app/ui_view/wave_view.dart';
import 'package:demo_project/pages/fitness_app/fitness_app_theme.dart';
import 'package:demo_project/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WaterView extends StatefulWidget {
  const WaterView(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation, required this.selectedDate})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;
  final DateTime selectedDate; // 接收 selectedDate 作为参数

  @override
  _WaterViewState createState() => _WaterViewState();
}

class _WaterViewState extends State<WaterView> with TickerProviderStateMixin {
  double currentWaterIntake = 2100.0; // 当前饮水量
  double totalWaterGoal = 3500.0; // 每日目标水量
  DateTime lastDrinkTime = DateTime.now(); // 最后一次饮水时间

  String dailyGoalText = 'of daily goal 3.5L'; // 每日目标文本

  TextEditingController waterIntakeController = TextEditingController(); // 控制水量输入框

  @override
  void initState() {
    print("初始化");
    super.initState();
    // 初始化时将 lastDrinkTime 设置为今天
    lastDrinkTime = DateTime.now();
    fetchWaterData(widget.selectedDate);  // 初始时根据 selectedDate 获取数据
  }

  // 模拟向后端接口请求数据的方法
  Future<void> fetchWaterData(DateTime lastDrinkTime) async {
    print("向后端请求数据，当前时间：$lastDrinkTime");

    double simulatedWaterIntake;
    double simulatedGoal = totalWaterGoal;

    // 根据日期返回不同的饮水量数据和每日目标
    if (lastDrinkTime.year == 2025 && lastDrinkTime.month == 5 && lastDrinkTime.day == 4) {
      simulatedWaterIntake = 2100.0;
      simulatedGoal = 3500.0;
      dailyGoalText = 'of daily goal 3.5L';
    } else if (lastDrinkTime.year == 2025 && lastDrinkTime.month == 5 && lastDrinkTime.day == 3) {
      simulatedWaterIntake = 1998.0;
      simulatedGoal = 3300.0;
      dailyGoalText = 'of daily goal 3.3L';
    } else if (lastDrinkTime.year == 2025 && lastDrinkTime.month == 5 && lastDrinkTime.day == 2) {
      simulatedWaterIntake = 2005.0;
      simulatedGoal = 3000.0;
      dailyGoalText = 'of daily goal 3.0L';
    } else {
      simulatedWaterIntake = 0.0;
      simulatedGoal = 3500.0;
      dailyGoalText = 'of daily goal 3.5L';
    }

    setState(() {
      currentWaterIntake = simulatedWaterIntake;
      totalWaterGoal = simulatedGoal;
    });

    print("模拟的饮水量为：$currentWaterIntake");
    print("模拟的每日目标为：$totalWaterGoal");
  }

  // 增加水量
  void _increaseWaterIntake() {
    if (_isToday(lastDrinkTime)) {
      double? inputWater = double.tryParse(waterIntakeController.text);
      if (inputWater != null && inputWater > 0) {
        setState(() {
          if (currentWaterIntake + inputWater <= totalWaterGoal) {
            currentWaterIntake += inputWater;
            lastDrinkTime = DateTime.now();
            print("当前饮水量：$currentWaterIntake ml");
          } else {
            print("饮水量超过每日目标！");
          }
        });
      } else {
        print("请输入有效的水量！");
      }
    } else {
      print("只能修改今天的饮水量。");
    }
  }

  // 减少水量
  void _decreaseWaterIntake() {
    if (_isToday(lastDrinkTime)) {
      double? inputWater = double.tryParse(waterIntakeController.text);
      if (inputWater != null && inputWater > 0) {
        setState(() {
          if (currentWaterIntake - inputWater >= 0) {
            currentWaterIntake -= inputWater;
            lastDrinkTime = DateTime.now();
            print("当前饮水量：$currentWaterIntake ml");
          } else {
            print("减少的饮水量超过了当前饮水量！");
          }
        });
      } else {
        print("请输入有效的水量！");
      }
    } else {
      print("只能修改今天的饮水量。");
    }
  }

  // 检查是否是今天
  bool _isToday(DateTime date) {
    final today = DateTime.now();
    return date.year == today.year && date.month == today.month && date.day == today.day;
  }

  @override
  void didUpdateWidget(covariant WaterView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 如果 selectedDate 改变，重新获取数据
    if (oldWidget.selectedDate != widget.selectedDate) {
      fetchWaterData(widget.selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.mainScreenAnimation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.mainScreenAnimation!.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 18),
              child: Container(
                decoration: BoxDecoration(
                  color: FitnessAppTheme.white,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                      topRight: Radius.circular(68.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: FitnessAppTheme.grey.withOpacity(0.2),
                        offset: const Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 4, bottom: 3),
                                      child: Text(
                                        currentWaterIntake.toStringAsFixed(0),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: FitnessAppTheme.fontName,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 32,
                                          color: FitnessAppTheme.nearlyDarkBlue,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8, bottom: 8),
                                      child: Text(
                                        'ml',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: FitnessAppTheme.fontName,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                          letterSpacing: -0.2,
                                          color: FitnessAppTheme.nearlyDarkBlue,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 4, top: 2, bottom: 14),
                                  child: Text(
                                    dailyGoalText,  // 显示每日目标文本
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: FitnessAppTheme.fontName,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      letterSpacing: 0.0,
                                      color: FitnessAppTheme.darkText,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 4, right: 4, top: 8, bottom: 16),
                              child: Container(
                                height: 2,
                                decoration: BoxDecoration(
                                  color: FitnessAppTheme.background,
                                  borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(left: 4),
                                        child: Icon(
                                          Icons.access_time,
                                          color: FitnessAppTheme.grey.withOpacity(0.5),
                                          size: 16,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 4.0),
                                        child: Text(
                                          'Last drink: ${lastDrinkTime.hour}:${lastDrinkTime.minute} AM',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: FitnessAppTheme.fontName,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            letterSpacing: 0.0,
                                            color: FitnessAppTheme.grey.withOpacity(0.5),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: TextField(
                                controller: waterIntakeController,
                                keyboardType: TextInputType.numberWithOptions(decimal: true), // 支持小数点输入
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')), // 只允许数字和小数点
                                ],
                                decoration: InputDecoration(
                                  labelText: '请输入要增加的水量 (ml)',  // 输入框标签
                                  hintText: '例如: 200',  // 提示文本
                                  labelStyle: TextStyle(
                                    color: FitnessAppTheme.nearlyDarkBlue,  // 标签文字颜色
                                    fontWeight: FontWeight.w500,  // 标签字体加粗
                                  ),
                                  hintStyle: TextStyle(
                                    color: Colors.grey[500],  // 提示文字颜色
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),  // 圆角边框
                                    borderSide: BorderSide(color: Colors.transparent),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),  // 圆角边框
                                    borderSide: BorderSide(color: Colors.blueAccent.withOpacity(0.5), width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),  // 圆角边框
                                    borderSide: BorderSide(color: Colors.blueAccent, width: 2), // 焦点时的边框颜色
                                  ),
                                  filled: true,
                                  fillColor: Colors.blue[50],  // 背景填充颜色，轻微渐变效果
                                  suffixIcon: waterIntakeController.text.isEmpty
                                      ? Container(width: 0) // 如果输入框为空，不显示清除按钮
                                      : IconButton(
                                    icon: Icon(Icons.clear),  // 清除按钮
                                    onPressed: () {
                                      setState(() {
                                        waterIntakeController.clear();  // 清空输入框
                                      });
                                    },
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // 内边距
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    // 每当输入框内容改变时，检查输入内容
                                    if (double.tryParse(value) != null) {
                                      // 输入是有效的数字
                                    } else {
                                      // 输入无效，可以显示提示
                                      print('请输入有效的数字');
                                    }
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 34,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            // Add water button
                            GestureDetector(
                              onTap: _increaseWaterIntake,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: FitnessAppTheme.nearlyWhite,
                                  shape: BoxShape.circle,
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: FitnessAppTheme.nearlyDarkBlue.withOpacity(0.4),
                                        offset: const Offset(4.0, 4.0),
                                        blurRadius: 8.0),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Icon(
                                    Icons.add,
                                    color: FitnessAppTheme.nearlyDarkBlue,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 28),
                            // Remove water button
                            GestureDetector(
                              onTap: _decreaseWaterIntake,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: FitnessAppTheme.nearlyWhite,
                                  shape: BoxShape.circle,
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: FitnessAppTheme.nearlyDarkBlue.withOpacity(0.4),
                                        offset: const Offset(4.0, 4.0),
                                        blurRadius: 8.0),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Icon(
                                    Icons.remove,
                                    color: FitnessAppTheme.nearlyDarkBlue,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 8, top: 16),
                        child: Container(
                          width: 60,
                          height: 160,
                          decoration: BoxDecoration(
                            color: HexColor('#E8EDFE'),
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(80.0),
                                bottomLeft: Radius.circular(80.0),
                                bottomRight: Radius.circular(80.0),
                                topRight: Radius.circular(80.0)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: FitnessAppTheme.grey.withOpacity(0.4),
                                  offset: const Offset(2, 2),
                                  blurRadius: 4),
                            ],
                          ),
                          child: WaveView(percentageValue: (currentWaterIntake / totalWaterGoal) * 100),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
