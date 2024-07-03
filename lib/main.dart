import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class CryptoModel {
  final String name;
  final String symbol;
  final double priceUSD;

  CryptoModel({
    required this.name,
    required this.symbol,
    required this.priceUSD,
  });

  factory CryptoModel.fromJson(Map<String, dynamic> json) {
    return CryptoModel(
      name: json['name'],
      symbol: json['symbol'],
      priceUSD: double.parse(json['price_usd']),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto Prices',
      theme: ThemeData(
        primaryColor: Colors.white, 
        scaffoldBackgroundColor: Colors.white, 
        primarySwatch: Colors.blue,
      ),
      home: CryptoListWidget(),
    );
  }
}

class CryptoListWidget extends StatefulWidget {
  @override
  _CryptoListWidgetState createState() => _CryptoListWidgetState();
}

class _CryptoListWidgetState extends State<CryptoListWidget> {
  late Future<List<CryptoModel>> futureCryptoPrices;

  @override
  void initState() {
    super.initState();
    futureCryptoPrices = fetchCryptoPrices();
  }

  Future<List<CryptoModel>> fetchCryptoPrices() async {
    final response = await http.get(Uri.parse('https://api.coinlore.net/api/tickers/'));

    if (response.statusCode == 200) {
      List<CryptoModel> cryptoPrices = [];
      var data = json.decode(response.body);
      var coins = data['data'];

      for (var coin in coins) {
        cryptoPrices.add(CryptoModel.fromJson(coin));
      }

      return cryptoPrices;
    } else {
      throw Exception('Failed to load crypto prices');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0), 
        child: AppBar(
          backgroundColor: Colors.lightBlueAccent, 
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  
                },
                child: Text(
                  'Crypto',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () {
                  
                },
                child: Text(
                  'Spot',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () {
                  
                },
                child: Text(
                  'Futures',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () {
                  
                },
                child: Text(
                  'Options',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          PreferredSize(
            preferredSize: Size.fromHeight(40.0),
            child: AppBar(
              backgroundColor: Colors.black,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      'Name',
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Text(
                      'Last Price',
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: FutureBuilder<List<CryptoModel>>(
                future: futureCryptoPrices,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.data![index].name,
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Text(snapshot.data![index].symbol),
                                  ],
                                ),
                              ),
                              Text(
                                '\$${snapshot.data![index].priceUSD.toStringAsFixed(2)}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('${snapshot.error}'),
                    );
                  }

                  return CircularProgressIndicator();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
