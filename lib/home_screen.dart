import 'dart:math';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<int> numbers = [];
  int luckyNumber = 0;
  String resultMessage = '';
  Set<int> clickedNumbers = {};
  int attemptsLeft = 3;
  bool _gameOver = false;

  @override
  void initState() {
    super.initState();
    generateLuckyNumbers();
  }

  void generateLuckyNumbers() {
    numbers = List.generate(99, (index) => index + 1);
    numbers.shuffle(Random());

    numbers = numbers.sublist(0, 10);

    luckyNumber = numbers[Random().nextInt(10)];

    attemptsLeft = 3;

    clickedNumbers.clear();
    resultMessage = '';

    setState(() {});
  }

  void checkLuckyNumber(int clickedNumber) {
    if (attemptsLeft > 0) {
      setState(() {
        clickedNumbers.add(clickedNumber);
        attemptsLeft--;

        if (clickedNumber == luckyNumber) {
          resultMessage =
              'Congratulations! $clickedNumber is your lucky number!';
          _gameOver = true;
          _showResultDialog(
            "Congratulations",
            "You found the lucky number!",
            "assets/images/2.jpg",
          );
        } else {
          resultMessage =
              'Better luck next time! $clickedNumber is not the lucky number.';
        }
      });
    }

    if (attemptsLeft == 0 && !_gameOver) {
      resultMessage =
          'Game Over! You have no attempts left. The lucky number was $luckyNumber.';

      _showResultDialog(
        "Game Over",
        "You didn't find the lucky number. The lucky number was $luckyNumber.",
        "assets/images/3.png",
      );
    }
  }

  void restartGame() {
    generateLuckyNumbers();
    setState(() {
      _gameOver = false;
    });
  }

  void _showResultDialog(String title, String message, String imagePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(imagePath),
              Text(message),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                if (_gameOver) {
                  restartGame();
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/1.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 230, bottom: 90, top: 10),
                child: InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Lucky Number: $luckyNumber',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        duration: const Duration(seconds: 2),
                        backgroundColor: Colors.white60,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        behavior: SnackBarBehavior.floating,
                        margin: const EdgeInsets.all(20),
                      ),
                    );
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white60),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: Colors.black87,
                          size: 18,
                        ),
                        SizedBox(width: 5),
                        Text(
                          ' Hint',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Text(
                attemptsLeft == 3
                    ? 'You have 3 attempts'
                    : 'Attempts Left: $attemptsLeft',
                style: const TextStyle(fontSize: 18, color: Colors.red),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  resultMessage,
                  style: const TextStyle(fontSize: 18, color: Colors.black87),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: List.generate(
                    (numbers.length / 3).ceil(),
                    (rowIndex) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (colIndex) {
                          int index = rowIndex * 3 + colIndex;
                          if (index < numbers.length) {
                            int number = numbers[index];
                            bool isClicked = clickedNumbers.contains(number);

                            ButtonStyle buttonStyle = ElevatedButton.styleFrom(
                              backgroundColor:
                                  isClicked ? Colors.red : Colors.white60,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            );

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 5),
                              child: ElevatedButton(
                                onPressed: isClicked || attemptsLeft == 0
                                    ? null
                                    : () => checkLuckyNumber(number),
                                style: buttonStyle,
                                child: Text(
                                  '$number',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87, // Text color
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return const SizedBox(width: 0);
                          }
                        }),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: restartGame,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  backgroundColor: Colors.white60,
                ),
                child: const Text(
                  'Restart Game',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

/*
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final int _luckyNumber = 5;
  int _attempts = 3;
  bool _gameOver = false;
  String _message = "Pick a number!";
   Set<int> _pressedNumbers = {};

  void _handleGuess(int guessedNumber) {
    if (_gameOver || _pressedNumbers.contains(guessedNumber)) return;

    setState(() {
      _pressedNumbers.add(guessedNumber);

      if (guessedNumber == _luckyNumber) {
        _message = "Congratulations! You found the lucky number!";
        _gameOver = true;
        _showResultDialog("Congratulations", "You found the lucky number!",
            "assets/images/2.jpg");
      } else {
        _attempts -= 1;
        if (_attempts == 0) {
          _message = "Game Over! The lucky number was $_luckyNumber.";
          _gameOver = true;
          _showResultDialog(
              "Oops!",
              "You've used all your attempts. The lucky number was $_luckyNumber.",
              "assets/images/3.png");
        } else {
          _message = "Try again! You have $_attempts attempts left.";
        }
      }
    });
  }

  void _showResultDialog(String title, String content, String image) {
    Get.defaultDialog(
      title: title,
      content: Column(
        children: [
          Image.asset(
            image,
            height: 100,
            width: 100,
          ),
          const SizedBox(height: 10),
          Text(
            content,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
      confirm: TextButton(
        child: const Text("Restart"),
        onPressed: () {
          Get.back();
          _restartGame();
        },
      ),
      cancel: TextButton(
        child: const Text("Ok"),
        onPressed: () {
          Get.back();
        },
      ),
    );
  }

  void _restartGame() {
    setState(() {
      _attempts = 3;
      _gameOver = false;
      _message = "Pick a number!";
      _pressedNumbers.clear();
    });
  }

  Widget _buildNumberButton(int number) {
    return GestureDetector(
      onTap:
      _pressedNumbers.contains(number) ? null : () => _handleGuess(number),
      child: Container(
        height: 70,
        width: 70,
        color: _pressedNumbers.contains(number) ? Colors.red : Colors.white70,
        child: Center(
          child: Text(
            "$number",
            style: const TextStyle(fontSize: 30, color: Color(0xffc8807e)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/1.png"), fit: BoxFit.fitHeight),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 4.0,
                sigmaY: 4.0,
              ),
              child: Container(
                color: Colors.black,
              ),
            ),
            Text(
              _message,
              style: GoogleFonts.pacifico(
                  textStyle: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  )),
              // style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNumberButton(1),
                      _buildNumberButton(2),
                      _buildNumberButton(3),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNumberButton(4),
                      _buildNumberButton(5),
                      _buildNumberButton(6),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNumberButton(7),
                      _buildNumberButton(8),
                      _buildNumberButton(9),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildNumberButton(10),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _gameOver
                  ? () {
                _restartGame();
              }
                  : null,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white70),
              child: const Text(
                "Restart Game",
                style: TextStyle(color:  Color(0xffc8807e)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/
