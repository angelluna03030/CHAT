import 'package:chat/src/pages/home.dart';
import 'package:chat/src/pages/status.dart';
import 'package:chat/src/services/socket_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SocketService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CHAT',
        initialRoute: "home",
        routes: {
          "home": (_) => HomePage(),
          "status": (_) => StatusPage(),
        },
      ),
    );
  }
}
