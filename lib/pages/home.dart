import 'package:flutter/material.dart';
import 'package:flutter_stripe_payment/pages/existing.dart';
import 'package:flutter_stripe_payment/pages/new.dart';
import 'package:flutter_stripe_payment/pages/existing.dart';
import 'package:flutter_stripe_payment/services/payment-service.dart';
import 'package:progress_dialog/progress_dialog.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  //ExistingStripeService existingStripeService = ExistingStripeService();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController amtController = TextEditingController();

  @override
  void initState() {
    super.initState();
    StripeService.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          'Home',
        )),
        //actions: [],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(hintText: 'Email'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: amtController,
                decoration: InputDecoration(hintText: 'Amount'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => NewCard(
                              amount: amtController.text,
                              email: emailController.text,
                            )));
                  },
                  child: Text('New card')),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ExistingCardsPage(
                                amount: amtController.text,
                              )),
                    );
                  },
                  child: Text('Existing card')),
            ),
          ],
        ),
      ),
    );
  }
}
