import 'package:flutter/material.dart';
import  'package:intl/intl.dart';
import 'package:hw4_stockbrowser/objects/stocks.dart';
import 'package:provider/provider.dart';
import 'package:hw4_stockbrowser/providers/favoriteList.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
    Icon customIcon = const Icon(Icons.search);
    Widget customSearchBar = const Text('Stock');
    String formattedDate = DateFormat.MMMMd().format(DateTime.now());
    // final items = context.watch<FavoriteList>().list;


    @override
    void initState() {
      super.initState();
      //retrieve favorite stocks

    }

    // const purple = const Color('9121a6');
    @override

    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: customSearchBar,
          centerTitle: true,
          backgroundColor: Colors.purple[600],
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/search');
                },
                icon: Icon(Icons.search))
          ],

        ),

        body: Padding(
          padding:EdgeInsets.only(left:20.0,right:20.0),
          child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: EdgeInsets.only(top:15),
                child: Text("STOCK WATCH", style: TextStyle(fontSize: 25,fontWeight:FontWeight.bold,color: Colors.white),),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                child: Text("$formattedDate", style: TextStyle(fontSize: 25,fontWeight:FontWeight.bold, color: Colors.white),),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,

              child: Container(
                  padding: EdgeInsets.only(top: 30.0,bottom: 20.0),
                child: Text("Favorites", style: TextStyle(fontSize: 18,color: Colors.white),)
              ),
            ),
            Align(
              alignment: Alignment.center,
                child:Column(
                  children: <Widget>[ context.watch<FavoriteList>().count == 0 ?
                  Column(
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.only(top: 3.0,bottom: 3.0),
                            decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(color: Colors.white, width: 2)))
                        ),
                        SizedBox(width:20, height:15),
                        Text("Empty",  style: TextStyle(fontSize: 21,fontWeight:FontWeight.bold,color: Colors.white))]) :
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    padding: const EdgeInsets.all(3.0),
                    shrinkWrap: true,
                    itemCount: context.watch<FavoriteList>().count,
                    itemBuilder: (context, index) {
                      final item = context.watch<FavoriteList>().list[index];
                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.only(top: 3.0,bottom: 3.0),
                                decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Colors.white, width: 2)))
                            ),
                        Dismissible(
                        // Each Dismissible must contain a Key. Keys allow Flutter to
                        // uniquely identify widgets.
                          key: Key(item.ticker),
                          // Provide a function that tells the app
                          // what to do after an item has been swiped away.
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (DismissDirection direction) async {
                            return await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: Colors.grey[800],
                                  title: const Text("Delete Confirmation",style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold,color: Colors.white) ),
                                  content: Text(
                                      "Are you sure you want to delete this item?",style: TextStyle(fontSize: 15,color: Colors.white)),
                                  actions: <Widget>[
                                    FlatButton(
                                      onPressed: () => {
                                        context.read<FavoriteList>().removeStock(context.read<FavoriteList>().list[index]),
                                        Navigator.of(context).pop(true),
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                      SnackBar(backgroundColor:Colors.white,
                                        duration: const Duration(milliseconds: 3000),
                                      padding:EdgeInsets.only(left:22.0,top: 12.0,bottom: 30.0),
                                      content: Text('${item.ticker} was removed from watchlist',
                                          style: TextStyle(fontSize: 15,color: Colors.grey[850])), ))
                                },
                                      child: Text("Delete",style: TextStyle(fontSize: 15,fontWeight:FontWeight.bold,color: Colors.white)),

                                    ),
                                    FlatButton(
                                      onPressed: () => Navigator.of(context).pop(false),
                                      child: const Text("Cancel", style: TextStyle(fontSize: 15,fontWeight:FontWeight.bold,color: Colors.white)),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          // Show a red background as the item is swiped away.
                          background: Container(
                              color: Colors.red,
                              height:5,
                              child:Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [Icon(Icons.delete, color: Colors.white),],)
                              ),
                          child:
                                ListTile(
                                  title: Text(item.ticker, style: TextStyle(fontSize: 15,color: Colors.white)),
                                  subtitle: Text(item.company_name, style: TextStyle(fontSize: 15,color: Colors.white)),
                                  onTap: () {
                                    Navigator.pushNamed(context, '/stockinfo', arguments: {'symbol': item.ticker.toUpperCase()});},
                                ),
                      )]);},
                  ),
                  ]
              ),

            ),
          ],
        ))
      );
  }
}

