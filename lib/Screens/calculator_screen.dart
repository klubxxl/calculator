import 'dart:math';

import 'package:calculator/Constants/colors.dart';
import 'package:calculator/Widgets/button_widget.dart';
import 'package:flutter/material.dart';

class Calculator extends StatelessWidget {
  Calculator({Key? key}) : super(key: key);

  ValueNotifier<String> calculatorDisplay = ValueNotifier('0');
  ValueNotifier<bool> darkMode = ValueNotifier(false);
  double result = 0;
  double? lastVal;
  String lastType = '+';
  bool isPositive = true,
      isFloat = false,
      isResult = false,
      symbolBlocker = false;

  void _calculation(String type, BuildContext context) {
    if (type != '/' &&
        type != '*' &&
        type != '-' &&
        type != '+' &&
        type != '=') {
      symbolBlocker = false;
    }

    switch (type) {
      case '+/-':
        if (calculatorDisplay.value != '+' &&
            calculatorDisplay.value != '-' &&
            calculatorDisplay.value != '/' &&
            calculatorDisplay.value != '*') {
          isResult = false;
          calculatorDisplay.value = isPositive
              ? '-' + calculatorDisplay.value
              : calculatorDisplay.value.substring(1);
          isPositive = !isPositive;
        }
        break;
      case '=':
        if (symbolBlocker == false) {
          _setResult();
          calculatorDisplay.value = result.toString();

          int len = calculatorDisplay.value.length;
          if (calculatorDisplay.value[len - 1] == '0' &&
              calculatorDisplay.value[len - 2] == '.') {
            calculatorDisplay.value =
                calculatorDisplay.value.substring(0, len - 2);
          }

          isFloat = true;
          isPositive = result >= 0;
          isResult = true;
          result = 0;
          lastType = '+';
        }

        break;
      case 'CE':
        if (symbolBlocker == false) {
          isResult = false;
          int len = calculatorDisplay.value.length;
          if (calculatorDisplay.value[len - 1] == '.') {
            isFloat = false;
          }
          if (len > 1) {
            calculatorDisplay.value =
                calculatorDisplay.value.substring(0, len - 1);
          } else {
            calculatorDisplay.value = '0';
          }
          symbolBlocker = true;
        } else {
          result = 0;
          _clearDisplay('0');
        }
        break;
      case 'C':
        result = 0;
        _clearDisplay('0');
        break;
      case '+':
        if (symbolBlocker == false) {
          _setResult();
          lastType = '+';
          _clearDisplay('+');
          symbolBlocker = true;
        }
        break;
      case '-':
        if (symbolBlocker == false) {
          _setResult();
          lastType = '-';
          _clearDisplay('-');
          symbolBlocker = true;
        }
        break;
      case '*':
        if (symbolBlocker == false) {
          _setResult();
          lastType = '*';
          _clearDisplay('*');
          symbolBlocker = true;
        }
        break;
      case '/':
        if (symbolBlocker == false) {
          _setResult();
          final power = pow(10, 14);
          result = (result * power).round() / power;
          lastType = '/';
          _clearDisplay('/');
          symbolBlocker = true;
        }
        break;
      case '.':
        if (!isFloat) {
          calculatorDisplay.value = calculatorDisplay.value + '.';
          isFloat = true;
        }
        break;
      default:
        if (isResult) {
          isResult = false;
          isPositive = true;
          isFloat = false;
          calculatorDisplay.value = type;
        } else if (calculatorDisplay.value == '0' ||
            calculatorDisplay.value == '00' ||
            calculatorDisplay.value == '-' ||
            calculatorDisplay.value == '+' ||
            calculatorDisplay.value == '*' ||
            calculatorDisplay.value == '/') {
          if (type != '00') {
            calculatorDisplay.value = type;
          } else {
            calculatorDisplay.value = '0';
          }
        } else if (calculatorDisplay.value.length <= 20) {
          calculatorDisplay.value = calculatorDisplay.value + type;
        } else {
          showDialog(
              context: context,
              builder: (ctx) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      'Number is too long!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                );
              });
        }
        break;
    }
  }

  void _clearDisplay(String newDisplayValue) {
    calculatorDisplay.value = newDisplayValue;
    isFloat = false;
    isPositive = true;
    isResult = false;
  }

  void _setResult() {
    double val = double.parse(calculatorDisplay.value);
    switch (lastType) {
      case '+':
        result += val;
        break;
      case '-':
        result -= val;
        break;
      case '/':
        result = result / val;
        break;
      case '*':
        result *= val;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return ValueListenableBuilder(
      valueListenable: darkMode,
      builder: (BuildContext ctx, bool value, Widget? child) {
        return Scaffold(
            backgroundColor: value
                ? AppColors.backgroundDarkColor
                : AppColors.backgroundColor,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(30),
              child: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: SizedBox(
                        height: 30,
                        child: IconButton(
                          onPressed: () {
                            darkMode.value = !darkMode.value;
                          },
                          icon: value
                              ? const Icon(
                                  Icons.nightlight_round,
                                  color: AppColors.primaryColor,
                                )
                              : const Icon(Icons.wb_sunny_outlined),
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          enableFeedback: false,
                        )),
                  ),
                ],
              ),
            ),
            body: child);
      },
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  elevation: 3,
                  color: AppColors.cardColor,
                  child: SizedBox(
                      height: min(160, _height - _width * 6 / 4),
                      width: _width - 30,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: SizedBox(
                              width: _width - 40,
                              child: FittedBox(
                                  child: ValueListenableBuilder<String>(
                                valueListenable: calculatorDisplay,
                                builder: (context, value, _) => Text(
                                  calculatorDisplay.value,
                                  style: const TextStyle(
                                      fontSize: 80, color: AppColors.onColor),
                                ),
                              )),
                            )),
                      )),
                ),
                SizedBox(
                  width: _width - 20,
                  height: (_width - 20) * 5 / 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircularCalculatorButton(
                            '+/-',
                            _calculation,
                            color: AppColors.secondaryColor,
                          ),
                          CircularCalculatorButton('=', _calculation,
                              color: AppColors.secondaryColor),
                          CircularCalculatorButton('CE', _calculation,
                              color: Colors.red.withGreen(120)),
                          CircularCalculatorButton(
                            'C',
                            _calculation,
                            color: Colors.red,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircularCalculatorButton('1', _calculation),
                          CircularCalculatorButton('2', _calculation),
                          CircularCalculatorButton('3', _calculation),
                          CircularCalculatorButton('+', _calculation,
                              color: AppColors.secondaryColor),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircularCalculatorButton('4', _calculation),
                          CircularCalculatorButton('5', _calculation),
                          CircularCalculatorButton('6', _calculation),
                          CircularCalculatorButton('-', _calculation,
                              color: AppColors.secondaryColor),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircularCalculatorButton('7', _calculation),
                          CircularCalculatorButton('8', _calculation),
                          CircularCalculatorButton('9', _calculation),
                          CircularCalculatorButton('*', _calculation,
                              color: AppColors.secondaryColor),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircularCalculatorButton('00', _calculation),
                          CircularCalculatorButton('0', _calculation),
                          CircularCalculatorButton('.', _calculation),
                          CircularCalculatorButton('/', _calculation,
                              color: AppColors.secondaryColor),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
