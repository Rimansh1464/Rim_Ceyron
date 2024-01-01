import 'package:collection/collection.dart';

import 'currencies.dart';
import 'currency.dart';

class CurrencyService {
  final List<Currencys> _currencies;

  CurrencyService()
      : _currencies = currencies
            .map((currency) => Currencys.from(json: currency))
            .toList();

  ///Return list with all currencies
  List<Currencys> getAll() {
    return _currencies;
  }

  ///Returns the first currency that mach the given code.
  Currencys? findByCode(String? code) {
    final uppercaseCode = code?.toUpperCase();
    return _currencies
        .firstWhereOrNull((currency) => currency.code == uppercaseCode);
  }

  ///Returns the first currency that mach the given name.
  Currencys? findByName(String? name) {
    return _currencies.firstWhereOrNull((currency) => currency.name == name);
  }

  ///Returns the first currency that mach the given number.
  Currencys? findByNumber(int? number) {
    return _currencies
        .firstWhereOrNull((currency) => currency.number == number);
  }

  ///Returns a list with all the currencies that mach the given codes list.
  List<Currencys> findCurrenciesByCode(List<String> codes) {
    final List<String> _codes =
        codes.map((code) => code.toUpperCase()).toList();
    final List<Currencys> currencies = [];
    for (final code in _codes) {
      final Currencys? currency = findByCode(code);
      if (currency != null) {
        currencies.add(currency);
      }
    }
    return currencies;
  }
}
