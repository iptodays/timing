/*
 * @Author: iptoday wangdong1221@outlook.com
 * @Date: 2024-08-23 20:23:24
 * @LastEditors: iptoday wangdong1221@outlook.com
 * @LastEditTime: 2024-08-23 20:38:58
 * @FilePath: /timing/lib/main.dart
 * 
 * Copyright (c) 2024 by iptoday wangdong1221@outlook.com, All Rights Reserved.
 */
import 'package:flutter/material.dart';
import 'package:keep_screen_on/keep_screen_on.dart';
import 'package:timing/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  KeepScreenOn.turnOn();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timing',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
