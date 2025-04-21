import 'package:flutter/material.dart';

class BodyInfoView extends StatefulWidget {
  final AnimationController animationController;

  const BodyInfoView({Key? key, required this.animationController}) : super(key: key);

  @override
  State<BodyInfoView> createState() => _BodyInfoViewState();
}

class _BodyInfoViewState extends State<BodyInfoView> {
  final _formKey = GlobalKey<FormState>();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final slideIn = Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0)).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: Interval(0.8, 1.0, curve: Curves.easeOut),
      ),
    );

    final slideOut = Tween<Offset>(begin: Offset(0, 0), end: Offset(-1, 0)).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: Interval(1.0, 1.0, curve: Curves.easeIn),
      ),
    );

    return SlideTransition(
      position: slideIn,
      child: SlideTransition(
        position: slideOut,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Personal Info", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: heightController,
                      decoration: InputDecoration(labelText: 'Height (cm)'),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: weightController,
                      decoration: InputDecoration(labelText: 'Weight (kg)'),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: ageController,
                      decoration: InputDecoration(labelText: 'Age'),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          print('Height: ${heightController.text}');
                          print('Weight: ${weightController.text}');
                          print('Age: ${ageController.text}');
                          // 你也可以触发跳转下一页动画
                          // widget.animationController.animateTo(1.0);
                        }
                      },
                      child: Text("Submit"),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
