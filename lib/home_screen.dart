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
  int cycle = 0;
  int repeat = 5;
  double progress = 0.0;
  int restTime = 3000000;
  bool isRest = false;
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

  void onPressResetButton() {
    if (isRunning) timer.cancel();
    setState(() {
      cycle = 0;
      progress = 0.0;
      isRest = false;
      isRunning = false;
      totalSeconds = widget.defaultTime;
      restTime = 3000000;
    });
  }

  void onTick(Timer timer) {
    if (totalSeconds == 0) {
      if (cycle == repeat) {
        setState(() {
          progress = 0.0;
          isRest = false;
          isRunning = false;
          totalSeconds = widget.defaultTime;
        });
        timer.cancel();
      } else {
        // 휴식 중이면 다시 일하러 가여함
        setState(() {
          progress = 0.0;
        });
        if (isRest) {
          totalSeconds = widget.defaultTime;
          isRest = false;
          cycle++;
        } else {
          isRest = true;
          totalSeconds = restTime;
        }
      }
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
      body: Column(
        children: [
          const Spacer(
            flex: 1,
          ),
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
                    backgroundColor: isRest ? Colors.blue : Colors.green[300],
                  ),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          isRest ? "Rest" : "Work",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                              color: isRest ? Colors.blue : Colors.green[300]),
                        ),
                        Text(
                          format(totalSeconds),
                          style: const TextStyle(
                              fontSize: 50, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "$cycle / $repeat",
                          style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                      ])
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 80,
          ),
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 100,
                      ),
                      Expanded(
                          child: SingleChildScrollView(
                        child: Column(children: [
                          Container(
                              margin: const EdgeInsets.all(10),
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  _showTextInputDialog(context);
                                },
                                child: Row(
                                  children: [
                                    Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        child: Icon(Icons.work,
                                            color: Colors.green[300],
                                            size: 30)),
                                    const Text(
                                      "Work",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800),
                                    ),
                                    const Spacer(flex: 1),
                                    Text(
                                      format(widget.defaultTime),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.green[300]),
                                    ),
                                    const SizedBox(width: 10),
                                  ],
                                ),
                              )),
                          Container(
                              margin: const EdgeInsets.all(10),
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  showRestDialog(context);
                                },
                                child: Row(
                                  children: [
                                    Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        child: Icon(Icons.water_drop_sharp,
                                            color: Colors.blue[300], size: 30)),
                                    const Text(
                                      "Rest",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800),
                                    ),
                                    const Spacer(flex: 1),
                                    Text(
                                      format(restTime),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.blue[300]),
                                    ),
                                    const SizedBox(width: 10),
                                  ],
                                ),
                              )),
                          Container(
                              margin: const EdgeInsets.all(10),
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  showRepeatDialog(context);
                                },
                                child: Row(
                                  children: [
                                    Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        child: Icon(Icons.repeat,
                                            color: Colors.red[300], size: 30)),
                                    const Text(
                                      "Repeat",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800),
                                    ),
                                    const Spacer(flex: 1),
                                    Text(
                                      "$repeat",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.red[300]),
                                    ),
                                    const SizedBox(width: 10),
                                  ],
                                ),
                              )),
                        ]),
                      ))
                    ],
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, -45),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                        padding: const EdgeInsets.all(10),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.amber,
                          child: IconButton(
                              color: Colors.green[900],
                              iconSize: 80,
                              onPressed: isRunning
                                  ? onPressPauseButton
                                  : onPressStartButton,
                              icon: isRunning
                                  ? const Icon(Icons.pause)
                                  : const Icon(Icons.play_arrow)),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                        padding: const EdgeInsets.all(10),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.amber,
                          child: IconButton(
                              color: Colors.green[900],
                              iconSize: 80,
                              onPressed: onResetButton,
                              icon: const Icon(Icons.restore_outlined)),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                        padding: const EdgeInsets.all(10),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.amber,
                          child: IconButton(
                              color: Colors.green[900],
                              iconSize: 80,
                              onPressed: () async {
                                onPressResetButton();
                              },
                              icon: const Icon(Icons.restore_from_trash)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  final _textHourFieldController = TextEditingController();
  final _textMinuateFieldController = TextEditingController();
  final _textRepeatFieldController = TextEditingController();
  final _textRestHourFieldController = TextEditingController();
  final _textRestMinuateFieldController = TextEditingController();

  Future<String?> showRepeatDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
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
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Repeat",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.black)),
                  const SizedBox(width: 30),
                  Expanded(
                    child: TextField(
                      maxLength: 2,
                      controller: _textRepeatFieldController,
                      decoration: const InputDecoration(
                          alignLabelWithHint: true,
                          hintStyle: TextStyle(fontSize: 15),
                          hintText: "Input Repeat!"),
                    ),
                  )
                ],
              ),
            ]),
            actions: <Widget>[
              ElevatedButton(
                child: const Text("Cancle"),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                  child: const Text('OK'),
                  onPressed: () => {
                        if (_textRepeatFieldController.text != "")
                          {
                            setRepeat(_textRepeatFieldController.text),
                            Navigator.pop(
                                context, _textRepeatFieldController.text)
                          }
                        else
                          Navigator.pop(
                              context, _textRepeatFieldController.text)
                      }),
            ],
          );
        });
  }

  void setRepeat(String value) {
    setState(() {
      repeat = int.parse(value);
    });
  }

  Future<String?> showRestDialog(BuildContext context) async {
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
                          controller: _textRestHourFieldController,
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
                      controller: _textRestMinuateFieldController,
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
                        if (_textRestHourFieldController.text != "" &&
                            _textRestMinuateFieldController.text != "")
                          {
                            setRest((int.parse(
                                            _textRestHourFieldController.text) *
                                        60 +
                                    int.parse(
                                        _textRestMinuateFieldController.text)) *
                                1000000)
                          },
                        Navigator.pop(
                            context, _textRestHourFieldController.text),
                        onResetButton()
                      }),
            ],
          );
        });
  }

  void setRest(int value) {
    setState(() {
      restTime = value;
    });
  }

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
