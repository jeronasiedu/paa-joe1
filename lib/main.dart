import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plant_disease/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plant Disease Detector',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.green,
          appBarTheme: const AppBarTheme(
            elevation: 0,
            centerTitle: true,
          ),
          textTheme: GoogleFonts.mulishTextTheme(
            Theme.of(context).textTheme,
          )
          // useMaterial3: true,
          ),
      home: const HomePage(),
    );
  }
}
