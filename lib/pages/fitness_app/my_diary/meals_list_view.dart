import 'package:demo_project/pages/fitness_app/fitness_app_theme.dart';
import 'package:demo_project/pages/fitness_app/models/meals_list_data.dart';
import 'package:demo_project/main.dart';
import 'package:flutter/material.dart';

class MealsListView extends StatefulWidget {
  const MealsListView(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation, required this.selectedDate})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;
  final DateTime selectedDate;  // 新增一个selectedDate来根据日期获取数据

  @override
  _MealsListViewState createState() => _MealsListViewState();
}

class _MealsListViewState extends State<MealsListView> with TickerProviderStateMixin {
  AnimationController? animationController;
  late List<MealsListData> mealsListData;
  // 定义这些变量来保存用户输入的内容
  String? selectedMealType;  // 用户选择的餐品类型（如：早餐、午餐、晚餐）
  TextEditingController mealsController = TextEditingController();  // 控制菜品输入
  String selectedImage = "assets/fitness_app/breakfast.png";

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
    _loadMealsData(widget.selectedDate);  // 在初始化时加载数据
  }

  @override
  void didUpdateWidget(covariant MealsListView oldWidget) {
    print("旧数据 ");
    print(oldWidget.selectedDate);
    print("新数据");
    print(widget.selectedDate);
    super.didUpdateWidget(oldWidget);
    // 当选中的日期改变时，更新数据
    if (oldWidget.selectedDate != widget.selectedDate) {
      _loadMealsData(widget.selectedDate);  // 更新数据
    }
  }

  void _loadMealsData(DateTime selectedDate) {
    // 根据选中的日期来加载不同的数据
    if (selectedDate.year == 2025 && selectedDate.month == 5 && selectedDate.day == 3) {
      // 如果是 2025-5-3，使用一种假数据
      mealsListData = [
        MealsListData(
          titleTxt: '吃个屁餐',
          meals: ['鸡蛋', '全麦吐司', '牛奶'],
          kacl: 400,
          startColor: "#FF8C00",
          endColor: "#FF6347",
          imagePath: "assets/fitness_app/breakfast.png",
        ),
        MealsListData(
          titleTxt: '午餐',
          meals: ['鸡胸肉', '米饭', '沙拉'],
          kacl: 600,
          startColor: "#008000",
          endColor: "#006400",
          imagePath: "assets/fitness_app/lunch.png",
        ),
        MealsListData(
          titleTxt: '晚餐',
          meals: ['牛肉', '土豆泥', '烤蔬菜'],
          kacl: 700,
          startColor: "#A52A2A",
          endColor: "#800000",
          imagePath: "assets/fitness_app/dinner.png",
        ),
      ];
    } else {
      // 否则使用另一组假数据
      mealsListData = [
        MealsListData(
          titleTxt: '早餐',
          meals: ['煎蛋', '果汁', '水果'],
          kacl: 350,
          startColor: "#87CEEB",
          endColor: "#4682B4",
          imagePath: "assets/fitness_app/breakfast.png",
        ),
        MealsListData(
          titleTxt: '午餐',
          meals: ['沙拉', '烤鸡', '面包'],
          kacl: 500,
          startColor: "#FF6347",
          endColor: "#FF4500",
          imagePath: "assets/fitness_app/lunch.png",
        ),
        MealsListData(
          titleTxt: '晚餐',
          meals: ['三文鱼', '青菜', '米饭'],
          kacl: 550,
          startColor: "#008080",
          endColor: "#20B2AA",
          imagePath: "assets/fitness_app/dinner.png",
        ),
      ];
    }
  }

  void _addMealRecord() {
    // 定义变量
    String? selectedMealType = '早餐';  // 默认选择一个餐品类型
    TextEditingController mealsController = TextEditingController();  // 用于菜品输入框

    // 打开对话框，收集饮食记录并提交到后端
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("添加饮食记录"),
          content: SingleChildScrollView(  // 使用SingleChildScrollView避免内容溢出
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 选择餐品名称
                DropdownButton<String>(
                  isExpanded: true,
                  hint: Text("选择餐品"),
                  value: selectedMealType,
                  onChanged: (newValue) {
                    setState(() {
                      selectedMealType = newValue!;
                    });
                  },
                  items: <String>['早餐', '午餐', '晚餐', '加餐']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(height: 10),
                // 输入菜品（允许多个菜品）
                TextField(
                  controller: mealsController,
                  decoration: InputDecoration(
                    labelText: '菜品（多个菜品用逗号隔开）',
                    hintText: '例如：鸡蛋, 牛奶, 面包',
                  ),
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: 10),
                // 图片选择
                Text("选择餐品图片"),
                SizedBox(height: 10),
                // 图片选择器，展示多个图片供用户选择
                GridView.count(
                  shrinkWrap: true,  // 不占用额外空间
                  crossAxisCount: 3,  // 每行显示3个图片
                  crossAxisSpacing: 10,  // 图片间横向间距
                  mainAxisSpacing: 10,  // 图片间纵向间距
                  childAspectRatio: 1,  // 每个图片占的空间
                  children: [
                    _buildImageChoice("assets/fitness_app/breakfast.png"),
                    _buildImageChoice("assets/fitness_app/lunch.png"),
                    _buildImageChoice("assets/fitness_app/dinner.png"),
                    _buildImageChoice("assets/fitness_app/snack.png"),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // 获取输入的数据
                String mealName = selectedMealType!;
                String mealItems = mealsController.text;  // 用户输入的菜品
                String imagePath = selectedImage;  // 选中的图片路径

                if (mealName.isNotEmpty && mealItems.isNotEmpty && imagePath.isNotEmpty) {
                  List<String> mealList = mealItems.split(',');

                  // 更新数据，添加新的饮食记录
                  setState(() {
                    mealsListData.add(MealsListData(
                      titleTxt: mealName,  // 使用选择的餐品名称
                      meals: mealList,  // 使用用户输入的菜品列表
                      kacl: 500,  // 可以根据用户输入卡路里或者其他方式处理
                      startColor: "#FF8C00",
                      endColor: "#FF6347",
                      imagePath: imagePath,  // 使用选择的图片路径
                    ));
                  });

                  Navigator.pop(context);
                } else {
                  // 如果数据不完整，给出提示
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("请填写所有内容")));
                }
              },
              child: Text("确认"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildImageChoice(String imagePath) {
    // 判断当前图片是否选中
    bool isSelected = selectedImage == imagePath;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedImage = imagePath; // 更新选中的图片
        });
      },
      child: Container(
        child: Image.asset(
          imagePath,
          width: 80,
          height: 80,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
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
            child: Container(
              height: 216,
              width: double.infinity,
              child: ListView.builder(
                padding: const EdgeInsets.only(
                    top: 0, bottom: 0, right: 16, left: 16),
                itemCount: mealsListData.length + 1,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  if (index == mealsListData.length) {
                    return GestureDetector(
                      onTap: _addMealRecord,  // 点击添加饮食记录
                      child: Container(
                        width: 130,
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            '添加饮食',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  }
                  final int count =
                  mealsListData.length > 10 ? 10 : mealsListData.length;
                  final Animation<double> animation =
                  Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                          parent: animationController!,
                          curve: Interval((1 / count) * index, 1.0,
                              curve: Curves.fastOutSlowIn)));
                  animationController?.forward();

                  return MealsView(
                    mealsListData: mealsListData[index],
                    animation: animation,
                    animationController: animationController!,
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class MealsView extends StatelessWidget {
  const MealsView(
      {Key? key, this.mealsListData, this.animationController, this.animation})
      : super(key: key);

  final MealsListData? mealsListData;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                100 * (1.0 - animation!.value), 0.0, 0.0),
            child: SizedBox(
              width: 130,
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 32, left: 8, right: 8, bottom: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: HexColor(mealsListData!.endColor)
                                  .withOpacity(0.6),
                              offset: const Offset(1.1, 4.0),
                              blurRadius: 8.0),
                        ],
                        gradient: LinearGradient(
                          colors: <HexColor>[
                            HexColor(mealsListData!.startColor),
                            HexColor(mealsListData!.endColor),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(8.0),
                          bottomLeft: Radius.circular(8.0),
                          topLeft: Radius.circular(8.0),
                          topRight: Radius.circular(54.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 54, left: 16, right: 16, bottom: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              mealsListData!.titleTxt,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: FitnessAppTheme.fontName,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                letterSpacing: 0.2,
                                color: FitnessAppTheme.white,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                const EdgeInsets.only(top: 8, bottom: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[

                                    // Meals for that specific day
                                    Text(
                                      mealsListData!.meals!.join('\n'),
                                      style: TextStyle(
                                        fontFamily: FitnessAppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 10,
                                        letterSpacing: 0.2,
                                        color: FitnessAppTheme.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            mealsListData?.kacl != 0
                                ? Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[

                                // Display calories
                                Text(
                                  mealsListData!.kacl.toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: FitnessAppTheme.fontName,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 24,
                                    letterSpacing: 0.2,
                                    color: FitnessAppTheme.white,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 4, bottom: 3),
                                  child: Text(
                                    'kcal',
                                    style: TextStyle(
                                      fontFamily:
                                      FitnessAppTheme.fontName,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                      letterSpacing: 0.2,
                                      color: FitnessAppTheme.white,
                                    ),
                                  ),
                                ),
                              ],
                            )
                                : Container(
                              decoration: BoxDecoration(
                                color: FitnessAppTheme.nearlyWhite,
                                shape: BoxShape.circle,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: FitnessAppTheme.nearlyBlack
                                          .withOpacity(0.4),
                                      offset: Offset(8.0, 8.0),
                                      blurRadius: 8.0),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Icon(
                                  Icons.add,
                                  color: HexColor(mealsListData!.endColor),
                                  size: 24,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        color: FitnessAppTheme.nearlyWhite.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 8,
                    child: SizedBox(
                      width: 80,
                      height: 80,
                      child: Image.asset(mealsListData!.imagePath),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
