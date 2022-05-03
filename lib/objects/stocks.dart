import 'package:http/http.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Stock {

  String ticker = ""; // location name for UI
  String company_name = "" ; // the time in that location
  String current_price = "" ; // url to an asset flag icon
  String price_change = "";
  String open_price = "";
  String high_price = "";
  String low_price = "";
  String close_price = "";
  String ipo = "";
  String industry = "";
  String website = "";
  String exchange = "";
  String market_cap = "";
  bool isFavorite = false;// location url for api endpoint

  Stock({ required this.ticker  });

  Future<void> getInfo() async {
    // make the request
    try {
      print('getting stock data...');
      final response = await Future.delayed(const Duration(seconds: 2), () =>
          http.get(Uri.parse(
              'https://finnhub.io/api/v1/stock/profile2?symbol=$ticker&token=c9ma342ad3i9qg80qcn0')));
      final response2 = await Future.delayed(const Duration(seconds: 2), () =>
          http.get(Uri.parse(
              'https://finnhub.io/api/v1/quote?symbol=$ticker&token=c9ma342ad3i9qg80qcn0')));
      Map data = await jsonDecode(response.body);
      Map data2 = await jsonDecode(response2.body);
      if (data2['c'] == null ) {
        print("its null");
      } else {
        company_name = await data['name'];
        current_price = await data2['c'].toString(); // url to an asset flag icon
        price_change = await data2['d'].toString();
        open_price = await data2['o'].toString();
        high_price = await data2['h'].toString();
        low_price = await data2['l'].toString();
        close_price = await data2['pc'].toString();
        ipo = await data['ipo'];
        industry = await data['finnhubIndustry'];
        website = await data['weburl'];
        exchange = await data["exchange"];
        market_cap = await data["marketCapitalization"].toString();
        print('complete data collection');
      }
    }
    catch (e) {
      print(e);
    }
  }
}