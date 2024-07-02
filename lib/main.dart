import 'package:chat/src/pages/home.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CHAT',
      initialRoute: "home",
      routes: {
        "home" :(_) => HomePages()
      },
    );
  }
}