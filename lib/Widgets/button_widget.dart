import 'package:calculator/Constants/colors.dart';
import 'package:flutter/material.dart';

class CircularCalculatorButton extends StatelessWidget {
  CircularCalculatorButton(this.title, this.function,
      {this.color = AppColors.primaryColor, Key? key})
      : super(key: key);

  String title;
  Function function;
  Color color;

  @override
  Widget build(BuildContext context) {
    final size = (MediaQuery.of(context).size.width - 20) / 5;
    return GestureDetector(
      onTap: () => function(title, context),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(size * 0.64),
        ),
        elevation: 1,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                  color: AppColors.onPrimaryColor, fontSize: size * 0.64),
            ),
          ),
        ),
      ),
    );
  }
}
