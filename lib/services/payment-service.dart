import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe_payment/model/samplemodel.dart';
import 'package:http/http.dart' as http;
import 'package:stripe_payment/stripe_payment.dart';

class StripeService {
  final apiBase = 'https://api.stripe.com/v1';
  String cid;

  static String secret =
      'sk_test_51IYp82SJv62kyar4uOdmFGF9n5IgNv9Hzzk8y6NlrrfvAlWbQeoZHN1cyUkHbb1FAmgabjkK5frrqWuje0kqQaa500EbwEYqUq';
  static Map<String, String> headers = {
    'Authorization': 'Bearer ${StripeService.secret}',
    'Content-Type': 'application/x-www-form-urlencoded'
  };

  static init() {
    StripePayment.setOptions(StripeOptions(
        publishableKey:
            "pk_test_51IYp82SJv62kyar4piaLCAAv6Zq2itjCWClVdnExNGGo83XWfd1u1d77Z4wmgdkaKKccFzkrGPThKvspt7WT1hKj00Htks4msC",
        merchantId: "Test",
        androidPayMode: 'test'));
  }

  // static Future<StripeTransactionResponse> payViaExistingCard() async {
  //   try {
  //     CreditCard card;
  //     var paymentMethod = await StripePayment.createPaymentMethod(
  //         PaymentMethodRequest(card:  card));
  //     var paymentIntent =
  //     await StripeService.createCharges();
  //     var response = await StripePayment.confirmPaymentIntent(PaymentIntent(
  //         clientSecret: paymentIntent['client_secret'],
  //         paymentMethodId: paymentMethod.id));
  //     if (response.status == 'succeeded') {
  //       return new StripeTransactionResponse(
  //           message: 'Transaction successful', success: true);
  //     } else {
  //       return new StripeTransactionResponse(
  //           message: 'Transaction failed', success: false);
  //     }
  //   } on PlatformException catch (err) {
  //     return StripeService.getPlatformExceptionErrorResult(err);
  //   } catch (err) {
  //     return new StripeTransactionResponse(
  //         message: 'Transaction failed: ${err.toString()}', success: false);
  //   }
  // }

  // static Future<StripeTransactionResponse> payWithNewCard() async {
  //   try {
  //     var paymentMethod = await StripePayment.paymentRequestWithCardForm(
  //         CardFormPaymentRequest());
  //     var paymentIntent = await StripeService.createToken();
  //
  //     var response = await StripePayment.confirmPaymentIntent(PaymentIntent(
  //         clientSecret: paymentIntent['client_secret'],
  //         paymentMethodId: paymentMethod.id));
  //
  //     if (response.status=='successed') {
  //       return new StripeTransactionResponse(
  //           message: 'Transaction successful', success: true);
  //     } else {
  //       return new StripeTransactionResponse(
  //           message: 'Transaction failed', success: false);
  //     }
  //   } on PlatformException catch (err) {
  //     return StripeService.getPlatformExceptionErrorResult(err);
  //   } catch (err) {
  //     return new StripeTransactionResponse(
  //         message: 'Transaction failed: ${err.toString()}', success: false);
  //   }
  // }

  // static getPlatformExceptionErrorResult(err) {
  //   String message = 'Something went wrong';
  //   if (err.code == 'cancelled') {
  //     message = 'Transaction cancelled';
  //   }
  //   return new APIResponseModel(message: message, success: false);
  // }

  // static Future<Map<String, dynamic>> createPaymentIntent() async {
  //   try {
  //     Map<String, dynamic> body = {
  //       'amount': amount,
  //       'currency': currency,
  //       'payment_method_types[]': 'card'
  //     };
  //     var response = await http.post(StripeService.paymentApiUrl,
  //         body: body, headers: StripeService.headers);
  //     // return jsonDecode(response.body);
  //     return createCustomer(amount,currency);
  //   } catch (err) {
  //     print('err charging user: ${err.toString()}');
  //   }
  //   return null;
  // }

  // Future<APIResponseModel> getToken(BuildContext context) async {
  //   final response = await http.get(
  //       'https://api.stripe.com/v1/customers/cus_JD7j2GQzQKZU3c/sources/card_1IahPfSJv62kyar4GUHglp5F',
  //       headers: headers);
  //   final data = jsonDecode(response.body);
  //   if (response.statusCode == 200) {
  //     print(data);
  //     return APIResponseModel(
  //         message: 'Data Found',
  //         response: data,
  //         statusCode: response.statusCode,
  //         success: true);
  //   } else {
  //     print("No data found");
  //     return APIResponseModel(
  //         response: [],
  //         message: 'No Data Found',
  //         statusCode: response.statusCode,
  //         success: false);
  //   }
  // }

  Future<APIResponseModel> getCards() async {
    try {
      final response = await http.get(
          'https://api.stripe.com/v1/customers/cus_JD7j2GQzQKZU3c/sources',
          headers: headers);
      final data = jsonDecode(response.body);
      //SampleModel.listOfSample = data;
      if (response.statusCode == 200) {
        print(data);
        return APIResponseModel(
            message: 'Data Found',
            response: SampleModel.fromJSon(data['data']),
            statusCode: response.statusCode,
            success: true);
      } else {
        print("No data found");
        return APIResponseModel(
            response: [],
            message: 'No Data Found',
            statusCode: response.statusCode,
            success: false);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<APIResponseModel> paywithcard(String amount) async {
    try {
      final response = await http.get(
          'https://api.stripe.com/v1/customers/cus_JD7j2GQzQKZU3c/sources',
          headers: headers);
      final data = jsonDecode(response.body);
      //SampleModel.listOfSample = data;
      if (response.statusCode == 200) {
        print(data);
        var custid = data(data['customer']);
        cid = custid;
        return createCharges(custid, amount);
      } else {
        print("No data found");
        return APIResponseModel(
            response: [],
            message: 'Transaction failed',
            statusCode: response.statusCode,
            success: false);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<APIResponseModel> createCard(
      BuildContext context,
      String expireDate,
      String name,
      String number,
      String cvc,
      String email,
      String amount) async {
    var month = expireDate.split("/")[0];
    var year = expireDate.split("/")[1];

    var body = {
      "card[number]": number,
      "card[exp_month]": month,
      "card[exp_year]": year,
      "card[cvc]": cvc,
    };

    // await StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest());
    // var response1 = await StripePayment.confirmPaymentIntent(PaymentIntent(
    //   paymentMethodId: paymentMethod.id,
    // ));

    var response = await http.post('https://api.stripe.com/v1/tokens',
        body: body, headers: StripeService.headers);
    if (response.statusCode == 200 || response.statusCode == 402) {
      //print(response);
      var data = json.decode(response.body);
      var token = data['id'];
      return createCustomer(email, token, amount);
    } else {
      print("something Wrong!");
      return APIResponseModel(
          response: [],
          message: 'Transaction failed',
          statusCode: response.statusCode,
          success: false);
    }
  }

  Future<APIResponseModel> createCustomer(
      String email, String token, String amount) async {
    var body = {
      'email': email,
      'source': token,
      'description': "CustomerAddress",
    };
    var response = await http.post('https://api.stripe.com/v1/customers',
        body: body, headers: StripeService.headers);
    if (response.statusCode == 200 || response.statusCode == 400) {
      print(response);
      var data = json.decode(response.body);
      var custid = data['id'];
      cid = custid;
      return createCharges(custid, amount);
    } else {
      print("something Wrong!");
      return APIResponseModel(
          response: [],
          message: 'Transaction failed',
          statusCode: response.statusCode,
          success: false);
    }
  }

  Future<APIResponseModel> createCharges(String custid, String amount) async {
    var body = {
      'amount': amount,
      'currency': "INR",
      'customer': custid,
      'description': "My First Test Charge (created for API docs)",
    };
    var response = await http.post('https://api.stripe.com/v1/charges',
        body: body, headers: StripeService.headers);
    var data = json.decode(response.body);
    if (response.statusCode == 200 || response.statusCode == 400) {
      print(response);
      print(data);
      return APIResponseModel(
          response: data,
          message: 'Transaction Successfully complete',
          statusCode: response.statusCode,
          success: true);
    } else {
      print("something Wrong!");
      return APIResponseModel(
          response: [],
          message: 'Transaction failed',
          statusCode: response.statusCode,
          success: false);
    }
  }

  Future<APIResponseModel> deleteCard(String customerId, String cardId) async {
    var response = await http.delete(
        ' https://api.stripe.com/v1/customers/cus_JD7j2GQzQKZU3c/sources/card_1IahPfSJv62kyar4GUHglp5F',
        headers: StripeService.headers);
    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      return APIResponseModel(
          response: data,
          message: 'Data Found',
          statusCode: response.statusCode,
          success: false);
    } else {
      print("something Wrong!");
      return APIResponseModel(
          response: [],
          message: 'something Wrong!',
          statusCode: response.statusCode,
          success: false);
    }
  }
}
