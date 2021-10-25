// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:flutter/material.dart';
import 'creation_pages/landing_page.dart';
import 'creation_pages/result_page.dart';
import 'present_pages/present_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uri = Uri.dataFromString(window.location.href);
    Map<String, String> params = uri.queryParameters;
    final giftId = params['id'];

    if (giftId == null) {
      return const CreationPage();
    }

    return MaterialApp(
        title: 'Loading..',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: PresentPage(giftId));
  }
}

class CreationPage extends StatelessWidget {
  const CreationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Birthday Card',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (ctx) => const LandingPage(),
        '/result': (ctx) => const ResultPage(),
      },
    );
  }
}
