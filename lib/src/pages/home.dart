import 'package:flutter/material.dart';
class HomePages extends StatelessWidget {
  const HomePages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text('Chat' ),
        ),
        body: const Center(
          child: Text('Hola mundo'),
        ),
      );
  }
}