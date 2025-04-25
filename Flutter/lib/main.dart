import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() => runApp(const PlantLeafApp());

class PlantLeafApp extends StatelessWidget {
  const PlantLeafApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Green Shield',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Roboto', primarySwatch: Colors.green),
      home: const HomeScreen(),
    );
  }
}
