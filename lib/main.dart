import 'package:flutter/material.dart';
import 'package:flutter_stripe_payment/pages/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: HomePage(),
      // initialRoute: '/home',
      // routes: {
      //   '/home': (context) => HomePage(),
      //   '/existing-cards': (context) => ExistingCardsPage()
      // },
    );
  }
}
