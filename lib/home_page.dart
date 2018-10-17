import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttercrypto/data/cryptov2_data.dart';
import 'package:fluttercrypto/modules/crypto_presenter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> implements CryptoListViewContract {
  CryptoListPresenter _presenter;
  List<Data> _currencies;
  bool _isLoading;
  final List<MaterialColor> _colors = [Colors.blue, Colors.indigo, Colors.red];

  _HomePageState() {
    _presenter = new CryptoListPresenter(this);
  }

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _presenter.loadCurrencies();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Crypto App"),
          elevation: defaultTargetPlatform == TargetPlatform.iOS ? 0.0 : 5.0,
        ),
        body: _isLoading
            ? new Center(
                child: new CircularProgressIndicator(),
              )
            : _cryptoWidget());
  }

  Widget _cryptoWidget() {
    return new Container(
        child: new Column(
      children: <Widget>[
        new Flexible(
          child: new ListView.builder(
            itemCount: _currencies.length,
            itemBuilder: (BuildContext context, int index) {
              final Data currency = _currencies[index];
              final MaterialColor color = _colors[index % _colors.length];

              return _getListItemUi(currency, color, index);
            },
          ),
        )
      ],
    ));
  }

  ListTile _getListItemUi(Data currency, MaterialColor color, int index) {
    return new ListTile(
      leading: new CircleAvatar(
        backgroundColor: color,
        child: new Text(currency.name[0]),
      ),
      title: new Text(currency.name,
          style: new TextStyle(fontWeight: FontWeight.bold)),
      subtitle: _getSubtitleText(currency.quotes.uSD.price.toString(),
          currency.quotes.uSD.percentChange1h.toString()),
      isThreeLine: true,
    );
  }

  Widget _getSubtitleText(String priceUSD, String percentageChange) {
    TextSpan priceTextWidget = new TextSpan(
        text: "\$$priceUSD\n", style: new TextStyle(color: Colors.black));
    String percentageChangeText = "1 hour: $percentageChange%";
    TextSpan percentageChangeTextWidget;

    if (double.parse(percentageChange) > 0) {
      percentageChangeTextWidget = new TextSpan(
          text: percentageChangeText,
          style: new TextStyle(color: Colors.green));
    } else {
      percentageChangeTextWidget = new TextSpan(
          text: percentageChangeText, style: new TextStyle(color: Colors.red));
    }

    return new RichText(
        text: new TextSpan(
            children: [priceTextWidget, percentageChangeTextWidget]));
  }

  @override
  void onLoadCryptoComplete(CryptoV2 items) {
    // TODO: implement onLoadCryptoComplete

    setState(() {
      _currencies = items.data;
      _isLoading = false;
    });
  }

  @override
  void onLoadCryptoError(String error) {
    print(error);
  }
}
