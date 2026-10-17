import 'package:intl/intl.dart';

class Formatters {
  const Formatters._();

  static final NumberFormat _usd = NumberFormat.currency(
    locale: 'en_US',
    symbol: '\$',
    decimalDigits: 2,
  );

  static String price(double amount) => _usd.format(amount);
}
