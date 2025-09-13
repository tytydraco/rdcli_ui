import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/// The RDCLI App.
class MyApp extends StatelessWidget {
  /// Creates a new [MyApp].
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RDCLI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Container(),
    );
  }
}
