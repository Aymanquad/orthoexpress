import 'package:flutter_test/flutter_test.dart';
import 'package:orthoexpress_app/core/shop/checkout_logic.dart';
import 'package:orthoexpress_app/data/products.dart';
import 'package:orthoexpress_app/providers/cart_provider.dart';

CartLine _sampleLine() {
  return CartLine(
    item: const CartItem(productId: 'cbd-lotion-1000', quantity: 1),
    product: const Product(
      id: 'cbd-lotion-1000',
      slug: 'cbd-lotion-1000mg',
      name: 'Test Product',
      price: 80.24,
      category: 'cbd-wellness',
      imagePath: 'assets/images/shop/cbd-lotion.jpg',
      highlights: [],
      description: 'Test',
    ),
    lineTotal: 80.24,
  );
}

CheckoutFormData _validForm() {
  final form = CheckoutFormData();
  form.firstName = 'Jane';
  form.lastName = 'Doe';
  form.email = 'jane@example.com';
  form.phone = '(432) 322-8675';
  form.address = '123 Main St';
  form.city = 'Midland';
  form.state = 'TX';
  form.zip = '79701';
  form.cardNumber = '4111 1111 1111 1111';
  form.cardName = 'Jane Doe';
  form.expiry = '12/28';
  form.cvv = '123';
  return form;
}

void main() {
  group('calculateOrderTotals', () {
    test('applies shipping and tax', () {
      final totals = calculateOrderTotals(100);
      expect(totals.subtotal, 100);
      expect(totals.shipping, shippingRate);
      expect(totals.tax, 8.0);
      expect(totals.total, 100 + shippingRate + 8.0);
    });

    test('zero subtotal has no shipping', () {
      final totals = calculateOrderTotals(0);
      expect(totals.shipping, 0);
      expect(totals.total, 0);
    });
  });

  group('processDemoCheckout', () {
    test('declines cards ending in 0000', () async {
      final form = _validForm();
      form.cardNumber = '4111 1111 1111 0000';

      final result = await processDemoCheckout(
        formData: form,
        cartLines: [_sampleLine()],
        totals: calculateOrderTotals(80.24),
        lang: 'en',
      );

      expect(result.success, isFalse);
      expect(result.errorMessage, contains('declined'));
      expect(result.order, isNull);
    });

    test('succeeds with valid demo card', () async {
      final result = await processDemoCheckout(
        formData: _validForm(),
        cartLines: [_sampleLine()],
        totals: calculateOrderTotals(80.24),
        lang: 'en',
      );

      expect(result.success, isTrue);
      expect(result.order, isNotNull);
      expect(result.order!.id.startsWith('OE-'), isTrue);
      expect(result.order!.payment?.provider, 'demo');
      expect(result.order!.payment?.status, 'succeeded');
      expect(result.order!.payment?.last4, '1111');
      expect(result.order!.items.length, 1);
    });

    test('returns field errors for empty form', () async {
      final result = await processDemoCheckout(
        formData: CheckoutFormData(),
        cartLines: [_sampleLine()],
        totals: calculateOrderTotals(80.24),
        lang: 'en',
      );

      expect(result.success, isFalse);
      expect(result.fieldErrors, isNotEmpty);
      expect(result.fieldErrors!['firstName'], isNotNull);
    });

    test('fails when cart is empty', () async {
      final result = await processDemoCheckout(
        formData: _validForm(),
        cartLines: [],
        totals: calculateOrderTotals(0),
        lang: 'en',
      );

      expect(result.success, isFalse);
      expect(result.errorMessage, contains('empty'));
    });
  });
}
