/*
 * @Author: iptoday wangdong1221@outlook.com
 * @Date: 2024-08-22 15:48:54
 * @LastEditors: iptoday wangdong1221@outlook.com
 * @LastEditTime: 2024-08-23 20:47:22
 * @FilePath: /timing/lib/home.dart
 * 
 * Copyright (c) 2024 by iptoday wangdong1221@outlook.com, All Rights Reserved.
 */

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:timing/date_util.dart';
import 'package:timing/timer_util.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  bool isRunning = false;
  final List<String> logs = [];

  final TimerUtil timerUtil = TimerUtil();

  ScrollController controller = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    timerUtil.setOnTimerTickCallback((ms) {
      if (ms ~/ 1000 == 0) {
        launchUrlString(
          'stripcamy://app?tester=1',
          mode: LaunchMode.externalApplication,
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            MaterialButton(
              onPressed: () {
                isRunning = !isRunning;
                log(isRunning ? '开启任务' : '停止任务');
                setState(() {});
                if (isRunning) {
                  registerTask(true);
                } else {
                  timerUtil.cancel();
                }
              },
              child: Container(
                height: 66,
                alignment: Alignment.center,
                color: isRunning ? Colors.red : Colors.green,
                child: Text(
                  isRunning ? '停止任务' : '开启任务',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: controller,
                padding: const EdgeInsets.all(16),
                itemCount: logs.length,
                itemBuilder: (_, index) {
                  return Container(
                    alignment: Alignment.centerLeft,
                    height: 44,
                    child: Text(
                      logs[index],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      log('关闭应用');
      registerTask();
    } else if (state == AppLifecycleState.paused) {
      log('打开应用');
    }
  }

  Future<void> registerTask([bool isFirst = false]) async {
    if (!isRunning) {
      return;
    }
    int ms = isFirst ? 15 * 1000 : (Random().nextInt(3) + 2) * 60 * 60 * 1000;
    DateTime nextTime = DateTime.now().add(Duration(milliseconds: ms));
    log('任务将在${DateUtil.formatDate(nextTime, format: 'MM/dd HH:mm:ss')}执行');
    timerUtil
      ..cancel()
      ..setInterval(1000)
      ..setTotalTime(ms)
      ..startCountDown();
  }

  void log(String val) {
    logs.add('${DateUtil.formatDate(
      DateTime.now(),
      format: 'MM/dd HH:mm:ss',
    )}: $val');
    setState(() {});
    if (logs.length > 15) {
      controller.animateTo(
        controller.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
