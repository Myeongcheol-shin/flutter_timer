import 'package:flutter/material.dart';
import 'package:flutter_timer/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<int> defaultTime;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  // This widget is the root of your application.
  Future<SharedPreferences> getData() async {
    final SharedPreferences prefs = await _prefs;
    return prefs;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomeScreen(
              defaultTime: snapshot.data!.getInt("defaultTime") ?? 60000000,
              prefs: snapshot.data!,
            );
          } else {
            return const Center(
              child: Text("Loading..."),
            );
          }
        },
      ),
    );
  }
}
