import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  late int defaultTime;
  late SharedPreferences prefs;
  HomeScreen({super.key, required this.defaultTime, required this.prefs});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int totalSeconds = widget.defaultTime;
  late Timer timer;
  int total = 0;
  double progress = 0.0;
  bool isRunning = false;

  @override
  void initState() {
    totalSeconds = widget.defaultTime;
    super.initState();
  }

  String format(int seconds) {
    var duration = Duration(microseconds: seconds);
    var data = duration.toString().split(".").first.substring(
          2,
        );
    return data;
  }

  double formatProgress(int time) {
    return 1.0 - (time / widget.defaultTime);
  }

  void onTick(Timer timer) {
    if (totalSeconds == 0) {
      setState(() {
        progress = 0.0;
        total++;
        isRunning = false;
        totalSeconds = widget.defaultTime;
      });
      timer.cancel();
    } else {
      setState(() {
        totalSeconds -= 10;
        progress = formatProgress(totalSeconds);
      });
    }
  }

  void onResetButton() {
    if (isRunning) {
      timer.cancel();
      setState(() {
        isRunning = false;
        totalSeconds = widget.defaultTime;
        progress = 0.0;
      });
    } else {
      setState(() {
        totalSeconds = widget.defaultTime;
        progress = 0.0;
      });
    }
  }

  void onPressStartButton() {
    timer = Timer.periodic(const Duration(microseconds: 1), onTick);
    setState(() {
      isRunning = true;
    });
  }

  void onPressPauseButton() {
    timer.cancel();
    setState(() {
      isRunning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: SizedBox(
                  height: 300,
                  width: 300,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(
                        strokeWidth: 20,
                        value: progress,
                        color: Colors.white,
                        backgroundColor: Colors.amber,
                      ),
                      Center(
                        child: Text(
                          format(totalSeconds),
                          style: const TextStyle(
                              fontSize: 50, fontWeight: FontWeight.w500),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  IconButton(
                      iconSize: 80,
                      onPressed:
                          isRunning ? onPressPauseButton : onPressStartButton,
                      icon: isRunning
                          ? const Icon(Icons.pause)
                          : const Icon(Icons.play_arrow)),
                  const SizedBox(
                    width: 50,
                  ),
                  IconButton(
                      iconSize: 80,
                      onPressed: onResetButton,
                      icon: const Icon(Icons.restore_outlined)),
                  const SizedBox(width: 50),
                  IconButton(
                      iconSize: 80,
                      onPressed: () async {
                        await _showTextInputDialog(context);
                      },
                      icon: const Icon(Icons.settings)),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  final _textHourFieldController = TextEditingController();
  final _textMinuateFieldController = TextEditingController();

  Future<String?> _showTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              // Border 추가
              borderRadius: BorderRadius.circular(15.0),
              side: const BorderSide(color: Colors.amber, width: 5.0),
            ),
            title: const Text(
              '시간 설정',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.black),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Minuate",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Colors.black)),
                      const SizedBox(width: 30),
                      Expanded(
                        child: TextField(
                          maxLength: 2,
                          controller: _textHourFieldController,
                          decoration: const InputDecoration(
                              alignLabelWithHint: true,
                              hintStyle: TextStyle(fontSize: 15),
                              hintText: "시간(분)을 입력해주세요"),
                        ),
                      )
                    ]),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text("Seconds",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.black)),
                  const SizedBox(width: 22),
                  Expanded(
                    child: TextField(
                      maxLength: 2,
                      controller: _textMinuateFieldController,
                      decoration: const InputDecoration(
                          alignLabelWithHint: true,
                          hintStyle: TextStyle(fontSize: 15),
                          hintText: "시간(초)을 입력해주세요"),
                    ),
                  )
                ]),
              ],
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text("Cancle"),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                  child: const Text('OK'),
                  onPressed: () => {
                        if (_textHourFieldController.text != "" &&
                            _textMinuateFieldController.text != "")
                          {
                            widget.prefs.setInt(
                                "defaultTime",
                                (int.parse(_textHourFieldController.text) * 60 +
                                        int.parse(
                                            _textMinuateFieldController.text)) *
                                    1000000),
                            widget.defaultTime =
                                (int.parse(_textHourFieldController.text) * 60 +
                                        int.parse(
                                            _textMinuateFieldController.text)) *
                                    1000000,
                          },
                        Navigator.pop(context, _textHourFieldController.text),
                        onResetButton()
                      }),
            ],
          );
        });
  }
}
