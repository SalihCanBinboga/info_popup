import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: InfoPopupPage(),
    );
  }
}

class InfoPopupPage extends StatelessWidget {
  const InfoPopupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: const Text('Info Popup Example'),
        ),
      ),
    );
  }
}
