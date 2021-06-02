import 'package:flutter/material.dart';
// import 'package:credit_card/credit_card_form.dart';
// import 'package:credit_card/credit_card_model.dart';
// import 'package:credit_card/flutter_credit_card.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_stripe_payment/pages/home.dart';
import 'package:flutter_stripe_payment/services/payment-service.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:stripe_payment/stripe_payment.dart';

class NewCard extends StatefulWidget {
  final String email;
  final String amount;
  NewCard({Key key, this.email, this.amount}) : super(key: key);
  State<StatefulWidget> createState() => NewCardState();
}

class NewCardState extends State<NewCard> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  //ExistingStripeService existingStripeService = ExistingStripeService();
  StripeService stripeService = StripeService();
  //String amount;
  String cardToken;
  String custid;

  //String email;

  CreditCard card;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('New Card')),
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            CreditCardWidget(
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              showBackView: isCvvFocused,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: CreditCardForm(
                  onCreditCardModelChange: newCard,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 118.0),
              child: ElevatedButton(
                  onPressed: () async {
                    payViaNewCard(context);
                  },
                  child: Text('Pay')),
            ),
          ],
        ),
      ),
    );
  }

  payViaNewCard(BuildContext context) async {
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(message: 'Please wait...');
    await dialog.show();
    var response = await stripeService.createCard(context, expiryDate,
        cardHolderName, cardNumber, cvvCode, widget.email, widget.amount);

    await dialog.hide();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
          content: Text(response.message),
          // Text("Payment Successfully complete"),
          duration: new Duration(
              milliseconds: response.success == true ? 1200 : 3000),
        ))
        .closed
        .then((_) {
      Navigator.pop(context);
    });
  }

  void newCard(CreditCardModel card) {
    setState(() {
      cardNumber = card.cardNumber;
      expiryDate = card.expiryDate;
      cardHolderName = card.cardHolderName;
      cvvCode = card.cvvCode;
      isCvvFocused = card.isCvvFocused;
    });
  }
}
