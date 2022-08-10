import 'dart:convert';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter/material.dart';
import 'package:fourth_app_coincap/pages/detailspage.dart';
import 'package:fourth_app_coincap/services/http_service.dart';
import 'package:get_it/get_it.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomepageState();
}

class _HomepageState extends State<StatefulWidget> {
  double? _deviceHeight, _deviceWidth;

  String? dropdownValue = "bitcoin";

  HTTPService? _http;

  @override
  void initState() {
    super.initState();
    _http = GetIt.instance.get<HTTPService>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              selectedCoin(),
              DataWidgets(
                coin: dropdownValue,
                http: _http,
                deviceHeight: _deviceHeight!,
                deviceWidth: _deviceWidth!,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget selectedCoin() {
    var items = <String>["bitcoin", "ethereum", "tether", "cardano", "ripple"]
        .map<DropdownMenuItem<String>>(
      (String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      },
    ).toList();

    return DropdownButton(
      value: dropdownValue,
      items: items,
      onChanged: (String? value) {
        setState(() {
          dropdownValue = value;
        });
      },
      dropdownColor: const Color.fromRGBO(83, 88, 206, 1.0),
      iconSize: 30,
      icon: const Icon(
        Icons.arrow_drop_down_sharp,
        color: Colors.white,
      ),
      underline: Container(),
    );
  }
}

class DataWidgets extends StatelessWidget {
  final HTTPService? http;
  final double deviceHeight, deviceWidth;
  final String? coin;
  const DataWidgets({
    Key? key,
    required this.http,
    required this.deviceHeight,
    required this.deviceWidth,
    required this.coin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: http!.get("/coins/$coin"),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          Map data = jsonDecode(snapshot.data.toString());
          num price = data["market_data"]["current_price"]["inr"];
          num percent = data["market_data"]["price_change_percentage_24h"];
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onDoubleTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return DetailsPage(
                          dataList: data["market_data"]["current_price"],
                        );
                      },
                    ),
                  );
                },
                child: CoinImage(
                  imgURL: data["image"]["large"],
                  deviceHeight: deviceHeight,
                  deviceWidth: deviceWidth,
                ),
              ),
              CurrentPriceWidget(rate: price),
              PercentageChange(change: percent),
              DescriptionCard(
                description: data["description"]["en"],
                deviceHeight: deviceHeight,
                deviceWidth: deviceWidth,
              )
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
      },
    );
  }
}

class CurrentPriceWidget extends StatelessWidget {
  final num rate;
  const CurrentPriceWidget({Key? key, required this.rate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      "${rate.toStringAsFixed(2)} INR",
      style: const TextStyle(
        color: Colors.white,
        fontSize: 28,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

class PercentageChange extends StatelessWidget {
  final num change;
  const PercentageChange({Key? key, required this.change}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      "${change.toString()} %",
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w300,
      ),
    );
  }
}

class CoinImage extends StatelessWidget {
  final String imgURL;
  final double deviceHeight, deviceWidth;

  const CoinImage({
    Key? key,
    required this.imgURL,
    required this.deviceHeight,
    required this.deviceWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: deviceHeight * 0.16,
      width: deviceWidth * 0.16,
      padding: EdgeInsets.symmetric(
        vertical: deviceHeight * 0.04,
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(imgURL),
        ),
      ),
    );
  }
}

class DescriptionCard extends StatelessWidget {
  final String description;
  final double deviceHeight, deviceWidth;

  const DescriptionCard({
    Key? key,
    required this.description,
    required this.deviceHeight,
    required this.deviceWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: deviceHeight * 0.48,
      width: deviceWidth * 0.88,
      margin: EdgeInsets.symmetric(
        vertical: deviceHeight * 0.04,
      ),
      padding: EdgeInsets.symmetric(
        vertical: deviceHeight * 0.01,
        horizontal: deviceHeight * 0.01,
      ),
      color: const Color.fromRGBO(
        83,
        88,
        206,
        0.5,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const ClampingScrollPhysics(),
        child: Html(
          data: description,
          style: {
            "*": Style(color: Colors.white),
            "a": Style(color: Colors.orange[600]),
          },
        ),
      ),
    );
  }
}
