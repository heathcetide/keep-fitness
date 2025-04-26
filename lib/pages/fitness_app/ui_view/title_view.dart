import 'package:demo_project/pages/fitness_app/fitness_app_theme.dart';
import 'package:flutter/material.dart';

class TitleView extends StatelessWidget {
  final String titleTxt;
  final String subTxt;
  final AnimationController animationController;
  final Animation<double>? animation;
  final VoidCallback? onTap;

  const TitleView({
    Key? key,
    this.titleTxt = "",
    this.subTxt = "",
    required this.animationController,
    this.animation,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.only(left: 24, right: 24),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      titleTxt,
                      style: TextStyle(
                        fontFamily: 'WorkSans',
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        letterSpacing: 0.5,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    onTap: onTap,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        subTxt,
                        style: TextStyle(
                          fontFamily: 'WorkSans',
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                          letterSpacing: 0.5,
                          color: Colors.grey,
                        ),
                      ),
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
