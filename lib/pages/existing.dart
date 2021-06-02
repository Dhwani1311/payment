import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_stripe_payment/model/samplemodel.dart';
import 'package:flutter_stripe_payment/services/payment-service.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ExistingCardsPage extends StatefulWidget {
  final String amount;
  ExistingCardsPage({Key key, this.amount}) : super(key: key);

  ExistingCardsPageState createState() => ExistingCardsPageState();
}

class ExistingCardsPageState extends State<ExistingCardsPage> {
  SampleCard sampleCard;
  StripeService stripeService = StripeService();
  SampleModel sampleModel;
  CreditCard card;

  @override
  void initState() {
    getData();
    super.initState();
  }

  List cards = [
    {
      'cardNumber': '4242424242424242',
      'expiryDate': '04/24',
      'cardHolderName': 'ABC',
      'cvvCode': '424',
      'showBackView': false,
    },
    {
      'cardNumber': '5555555555555556',
      'expiryDate': '04/23',
      'cardHolderName': 'XYZ',
      'cvvCode': '123',
      'showBackView': false,
    }
  ];

  getData() async {
    await stripeService
        .getCards()
        .then((value) => sampleModel = value.response);
  }

  payViaExistingCard(BuildContext context, card) async {
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(message: 'Please wait...');
    await dialog.show();

    await stripeService.paywithcard(widget.amount);
    await dialog.hide();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
          content: Text("Transaction Successfully complete"),
          duration: new Duration(milliseconds: 1200),
        ))
        .closed
        .then((_) {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose existing card'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView.builder(
          //itemCount: sampleModel.listOfSample.length,
          itemCount: cards.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                payViaExistingCard(context, card);
              },
              child: CreditCardWidget(
                  cardNumber: cards[index]['cardNumber'],
                  expiryDate: cards[index]['expiryDate'],
                  cvvCode: cards[index]['cvvCode'],
                  cardHolderName: cards[index]['cardHolderName'],
                  showBackView: false
                  // cardNumber: sampleModel.listOfSample[index].number,
                  // expiryDate: sampleModel.listOfSample[index].exp_year,
                  // cvvCode: sampleModel.listOfSample[index].cvc ?? '303',
                  // showBackView: false,
                  // cardHolderName: 'Test User',
                  ),
            );
          },
        ),
      ),
    );
  }
}
