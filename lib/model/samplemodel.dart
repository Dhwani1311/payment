class SampleCard {
  String id;
  String cvc;
  String number;
  String exp_month;
  String exp_year;

  SampleCard({this.id, this.cvc, this.exp_month, this.exp_year});

  SampleCard.fromJSon(Map<String, dynamic> toJson) {
    id = toJson['id'];
    // cvc = toJson['cvc'];
    exp_month = toJson['exp_month'].toString();
    exp_year = toJson['exp_year'].toString();
    number = toJson['last4'];
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "cvc": cvc,
        "last4": number,
        "exp_month": exp_month,
        "exp_year": exp_year,
      };
}

class SampleModel {
  SampleModel.fromJSon(dynamic toJson) {
    if (toJson.isNotEmpty) {
      toJson
          .forEach((element) => listOfSample.add(SampleCard.fromJSon(element)));
    }
  }

  List<SampleCard> listOfSample = [];
}

class APIResponseModel {
  final String message;
  final dynamic response;
  final int statusCode;
  final bool success;

  const APIResponseModel(
      {this.message, this.response, this.statusCode, this.success});
}
