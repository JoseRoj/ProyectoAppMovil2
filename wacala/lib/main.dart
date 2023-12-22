import 'package:flutter/material.dart';
import 'package:wacala/pages/comment.dart';
import 'package:wacala/pages/detalle.dart';
import 'package:wacala/pages/image.dart';
import 'package:wacala/pages/login.dart';
import 'package:wacala/pages/new.dart';
import 'package:wacala/pages/wacalas.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        Login.route: (context) => const Login(),
        Wacalas.route: (context) => const Wacalas(),
        newWacala.route: (context) => const newWacala(),
        commentPage.route: (context) => const commentPage(),
        ImageWacala.route: (context) => const ImageWacala(),
      },
      home: const Login(),
    );
  }
}
