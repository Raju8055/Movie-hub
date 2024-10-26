import 'package:flutter/material.dart';
import 'package:geeksynergy_task/company_info.dart';
import 'package:geeksynergy_task/login.dart';
import 'package:geeksynergy_task/movie.dart';
import 'package:geeksynergy_task/singup.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/signup',
      routes: {
        '/signup': (context) => SignupPage(),
        '/login': (context) => LoginPage(),
        '/movies': (context) => MoviesPage(),
        '/companyInfo': (context) => CompanyInfoPage(),
      },
    );
  }
}
