import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hw4_stockbrowser/objects/stocks.dart';

class Search extends StatefulWidget {

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController controller = TextEditingController();
  var url = "";
  List<dynamic> results = [];
  var trueSymbol;
  bool isSearch = false;

  void getResult() async {
    try {
      final response = await Future.delayed(const Duration(seconds:5), () => http.get(Uri.parse(
          'https://finnhub.io/api/v1/search?q=$url&token=c9ma342ad3i9qg80qcn0')));
      Map data = jsonDecode(response.body);
      if (mounted) {
        setState(() {
          isSearch = false;
          results =
              data['result'].map((result) => result['displaySymbol'] + ' | ' +
                  result["description"]).toList();
        });
      }
    }
    catch (e) {
      print(e);
    }
  }

  void findSymbol(String s ){
    final index = s.indexOf("|");
    trueSymbol = s.substring(0, index - 1);
  }
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(

      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey),
        title: TextField(
          cursorColor: Colors.deepPurple[300],
          controller: controller,
          onChanged: (titleText) {
            setState(() {
              url = titleText;
              isSearch = true;
          });
            getResult();
            },
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintStyle: TextStyle(color:Colors.grey[500]),
            hintText: "Search",
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
          ),
        ),
          backgroundColor: (Colors.grey[900]),
          actions: [
          IconButton(
              onPressed: () {
                controller.clear();
                setState(() {
                  url = "";
                });
              } ,

              icon: Icon(Icons.clear))
        ],

      ),
      body: Center(
        child:
        url == "" ? Text('No suggestions found!', style: TextStyle(fontSize: 22,color: Colors.white),) :
        (isSearch) ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.deepPurple[300]),) :
        ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(results[index], style: TextStyle(fontSize: 18,color: Colors.white, fontWeight:FontWeight.bold)),
                onTap: () {
                findSymbol(results[index]);
                Navigator.pushReplacementNamed(context, '/stockinfo',arguments: {'symbol': trueSymbol.toUpperCase()});},
            );
          },
        ),
      ),

    );
  }
}