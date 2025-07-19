import 'package:flutter/material.dart';
import 'dart:async';

import 'package:root_plus/root_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController controller = TextEditingController();
  bool hasRoot = false;
  String results = "";

  @override
  void initState() {
    super.initState();
    check();
  }

  Future<void> check() async {
    hasRoot = await RootPlus.requestRootAccess();
    try {
      String result = await RootPlus.executeRootCommand(
        "echo Hello\necho World\npm list packages",
      );
      results = result;
      setState(() {});
    } on RootCommandException catch (e) {
      results = e.message;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin example app')),
        body: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: controller, maxLines: null),
              ElevatedButton(
                onPressed: () async {
                  try {
                    String result = await RootPlus.executeRootCommand(
                      controller.text,
                    );
                    results = result;
                    setState(() {});
                  } on RootCommandException catch (e) {
                    results = e.message;
                    setState(() {});
                  }
                },
                child: Text("Run"),
              ),
              Text(results),
            ],
          ),
        ),
      ),
    );
  }
}
