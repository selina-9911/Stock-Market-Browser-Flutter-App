import 'package:flutter/material.dart';
import 'package:hw4_stockbrowser/objects/stocks.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hw4_stockbrowser/providers/favoriteList.dart';

class Stockinfo extends StatefulWidget {

  Stockinfo({Key?key}) :super(key:key);

  @override
  _StockinfoState createState() => _StockinfoState();
}

class _StockinfoState extends State<Stockinfo> {
  bool isNoInfo = true;
  Map userdata = {};
  String symbol="";
  late Stock instance ;
  bool isFavorite = false;
  bool isNotAvailable = false;

  _launchURL() async {
    var url = instance.website;
    await launchUrl(Uri.parse(url));
  }

  void getResult() async {
    try {
      userdata = ModalRoute.of(context)!.settings.arguments as Map;
      symbol = userdata['symbol'];
      instance = Stock(ticker: symbol );
      await instance.getInfo();
      if (instance.current_price == "") {
        isNotAvailable = true;
      }
      if (context.read<FavoriteList>().list.any((item) => item.ticker == instance.ticker)) {
        int idx = context.read<FavoriteList>().list.indexOf(instance);
        setState(() {
          isNoInfo = false;
          isFavorite = true;
        });
      } else {
        setState(() {
          isNoInfo = false;
        });
      }
      // setState(() {
      //       isNoInfo = false;
      //     });
    }
    catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds:2), () {
      getResult();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Details'),
        centerTitle: true,
        backgroundColor: Colors.grey[900],
        actions: [
          IconButton(
              onPressed: () {
                isFavorite? instance.isFavorite = false : instance.isFavorite = true ;
                setState(() {
                  isFavorite = instance.isFavorite;
                });
                if (isFavorite) {
                  context.read<FavoriteList>().addStock(instance);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                      SnackBar(backgroundColor:Colors.white,
                        padding:EdgeInsets.only(left:22.0,top: 12.0,bottom: 30.0),
                        content: Text('${instance.ticker} was added to watchlist',
                            style: TextStyle(fontSize: 15,color: Colors.grey[850])), ));

                } else {
                  int idx = context.read<FavoriteList>().list.indexWhere((item) => item.ticker == instance.ticker);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                      SnackBar(backgroundColor:Colors.white,
                          duration: const Duration(milliseconds: 2000),
                        padding:EdgeInsets.only(left:22.0,top: 12.0,bottom: 30.0),
                        content: Text('${instance.ticker} was removed from watchlist',
                            style: TextStyle(fontSize: 15,color: Colors.grey[850])), ));
                  context.read<FavoriteList>().removeStock(context.read<FavoriteList>().list[idx]);
                }
                // Text('${context.watch<FavoriteList>().list}');
              },
              icon: isFavorite? Icon(Icons.star) : Icon(Icons.star_border),
          )
        ],
      ),
        body:
        isNoInfo ? Center( child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.deepPurple[300]),)) :
            isNotAvailable ?  Center( child:Text("Failed to fetch stock data", style: TextStyle(fontSize: 22, color:Colors.white))) :
        Column(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.only(top: 20.0, left:20.0),
                  child: Row(
                    children: <Widget>[
                      Text(instance.ticker, style: TextStyle(fontSize: 20, color:Colors.white)),
                      SizedBox(width:20, height:10),
                      Text(instance.company_name, style: TextStyle(fontSize: 20,color:Colors.grey)),
                    ]
                  ),

                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Row(
                      children: <Widget>[
                        Text(instance.current_price, style: TextStyle(fontSize: 20,color:Colors.white)),
                        SizedBox(width:20, height:60),
                        instance.price_change.substring(0, 1) != "-" ?
                        Text("+" + instance.price_change, style: TextStyle(fontSize: 20,color:Colors.green)) :
                        Text(instance.price_change, style: TextStyle(fontSize: 20,color:Colors.redAccent)),
                      ]
                  ),

                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Text("Stats", style: TextStyle(fontSize: 20,color:Colors.white),),
                ),
              ),

              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.only(top: 5.0, left:20.0),
                  child: Row(
                      children: <Widget>[
                    Align(
                    alignment: Alignment.center,
                      child: Container(
                        child: Column(
                            children: <Widget>[
                              Text("Open", style: TextStyle(fontSize: 18,color:Colors.white)),
                              SizedBox(width:20, height:3),
                              Text("Low", style: TextStyle(fontSize: 18,color:Colors.white)),
                            ]
                        ),

                      ),
                    ),
                        SizedBox(width:30, height:3),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            child: Column(
                                children: <Widget>[
                                  Text(instance.open_price, style: TextStyle(fontSize: 18,color:Colors.grey)),
                                  SizedBox(width:20, height:5),
                                  Text(instance.low_price, style: TextStyle(fontSize: 18,color:Colors.grey)),
                                ]
                            ),

                          ),
                        ),
                        SizedBox(width:30, height:3),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            child: Column(
                                children: <Widget>[
                                  Text("High", style: TextStyle(fontSize: 18,color:Colors.white)),
                                  SizedBox(width:20, height:5),
                                  Text("Prev", style: TextStyle(fontSize: 18,color:Colors.white)),
                                ]
                            ),

                          ),
                        ),
                        SizedBox(width:30, height:3),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            child: Column(
                                children: <Widget>[
                                  Text(instance.high_price, style: TextStyle(fontSize: 18,color:Colors.grey)),
                                  SizedBox(width:20, height:5),
                                  Text(instance.close_price, style: TextStyle(fontSize: 18,color:Colors.grey)),
                                ]
                            ),

                          ),
                        ),
                      ]
                  ),
                ),
              ),
              SizedBox(width:20, height:5),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.only(top: 10.0, left:20.0),
                  child: Text("About", style: TextStyle(fontSize: 20,color:Colors.white),),
                ),
              ),
              SizedBox(width:20, height:5),
              Align(
                alignment: Alignment.topLeft,
                child: Row(
                    children: <Widget>[
                      Align(
                        child: Container(
                          padding: EdgeInsets.only(left:20.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Start date", style: TextStyle(fontSize: 15,color:Colors.white)),
                                SizedBox(width:20, height:3),
                                Text("Industry", style: TextStyle(fontSize: 15,color:Colors.white)),
                                SizedBox(width:20, height:3),
                                Text("Website", style: TextStyle(fontSize: 15,color:Colors.white)),
                                SizedBox(width:20, height:3),
                                Text("Exchange", style: TextStyle(fontSize: 15,color:Colors.white)),
                                SizedBox(width:20, height:3),
                                Text("Market Cap", style: TextStyle(fontSize: 15,color:Colors.white)),
                              ]
                          ),

                        ),
                      ),
                      SizedBox(width:30, height:60),
                      Align(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(instance.ipo, style: TextStyle(fontSize: 15,color:Colors.grey)),
                                SizedBox(width:20, height:3),
                                Text(instance.industry, style: TextStyle(fontSize: 15,color:Colors.grey)),
                                SizedBox(width:20, height:3),
                                InkWell(
                                    onTap: () {
                                      _launchURL();//action
                                    },
                                    child: Text(
                                      instance.website,
                                      style: TextStyle(color:Colors.blue[900]),
                                    ),
                                  ),
                                SizedBox(width:20, height:3),
                                Text(instance.exchange, style: TextStyle(fontSize: 15,color:Colors.grey)),
                                SizedBox(width:20, height:3),
                                Text(instance.market_cap, style: TextStyle(fontSize: 15,color:Colors.grey)),
                              ]
                          ),


                      ),

                    ]
                ),
              ),


        ]
      )
    );
  }
}