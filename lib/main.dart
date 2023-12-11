import 'package:calculadora_responsive/pages/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator App',
      debugShowCheckedModeBanner: false,
      //Tema oscuro por defecto
      theme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}
