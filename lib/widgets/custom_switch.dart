import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_seoul/utils/assets.dart';
import 'package:flutter_seoul/utils/colors.dart';

class CustomSwitch extends HookWidget {
  const CustomSwitch({super.key, required this.animationController});
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    var circleAnimation = useAnimation(EdgeInsetsTween(
      begin: const EdgeInsets.only(left: 0),
      end: const EdgeInsets.only(left: 46),
    ).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut)));

    var colorAnimation = useAnimation(ColorTween(
      begin: AppColors.text.primary,
      end: AppColors.text.basic,
    ).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut)));

    var colorAnimation2 = useAnimation(ColorTween(
      begin: AppColors.text.basic,
      end: AppColors.text.primary,
    ).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut)));

    return GestureDetector(
      onTap: () {
        if (animationController.isCompleted) {
          animationController.reverse();
        } else {
          animationController.forward();
        }
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        width: 94,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.role.primary,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 150),
              left: circleAnimation.left,
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.role.primary,
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
            ),
            Positioned(
              left: 10,
              child: Image(
                color: colorAnimation,
                width: 16,
                height: 16,
                image: Assets.dooboolab,
              ),
            ),
            Positioned(
              right: 10,
              child: Image(
                color: colorAnimation2,
                width: 16,
                height: 16,
                image: Assets.dooboolabLogo,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
