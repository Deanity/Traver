import 'package:flutter_test/flutter_test.dart';
import 'package:traver/core/utils/formatters.dart';

void main() {
  group('Formatters.price', () {
    test('formats USD with dollar sign and dot decimal', () {
      expect(Formatters.price(245), '\$245.00');
      expect(Formatters.price(745.5), '\$745.50');
    });

    test('uses thousands separator', () {
      expect(Formatters.price(1234.5), '\$1,234.50');
    });

    test('formats zero', () {
      expect(Formatters.price(0), '\$0.00');
    });
  });
}
