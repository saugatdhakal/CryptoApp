import 'package:fluttercrypto/data/crypto_data.dart';
import 'package:fluttercrypto/data/cryptov2_data.dart';
import 'package:fluttercrypto/dependency_injection.dart';

abstract class CryptoListViewContract {
  void onLoadCryptoComplete(CryptoV2 items);
  void onLoadCryptoError(String error);
}

class CryptoListPresenter {
  CryptoListViewContract _view;
  CryptoRepository _repository;

  CryptoListPresenter(this._view) {
    _repository = new Injector().cryptoRepository;
  }

  void loadCurrencies() {
    _repository
        .fetchCurrencies()
        .then((c) => _view.onLoadCryptoComplete(c))
        .catchError((onError) => _view.onLoadCryptoError(onError.toString()));
  }
}
