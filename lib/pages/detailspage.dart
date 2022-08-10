import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  final Map dataList;
  const DetailsPage({Key? key, required this.dataList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List currencies = dataList.keys.toList();
    List rates = dataList.values.toList();
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          itemCount: currencies.length,
          itemBuilder: (context, index) {
            String currency = currencies[index].toString().toUpperCase();
            String exchangeRate = rates[index].toString();
            return ListTile(
              title: Text(
                "$currency: $exchangeRate",
                style: const TextStyle(color: Colors.white),
              ),
            );
          },
        ),
      ),
    );
  }
}
