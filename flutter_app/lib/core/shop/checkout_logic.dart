import 'dart:math';

import '../../data/models/order.dart';
import '../../providers/cart_provider.dart';

const double shippingRate = 5.99;
const double taxRate = 0.08;

class CheckoutFormData {
  String firstName = '';
  String lastName = '';
  String email = '';
  String phone = '';
  String address = '';
  String city = '';
  String state = '';
  String zip = '';
  String cardNumber = '';
  String cardName = '';
  String expiry = '';
  String cvv = '';
}

OrderTotals calculateOrderTotals(double subtotal) {
  final shipping = subtotal > 0 ? shippingRate : 0.0;
  final tax = subtotal * taxRate;
  return OrderTotals(
    subtotal: subtotal,
    shipping: shipping,
    tax: tax,
    total: subtotal + shipping + tax,
  );
}

Map<String, String> validateCheckoutForm(CheckoutFormData data, String lang) {
  final errors = <String, String>{};
  final es = lang == 'es';

  void req(String field, String value, String en, String esMsg) {
    if (value.trim().isEmpty) errors[field] = es ? esMsg : en;
  }

  req('firstName', data.firstName, 'First name is required', 'El nombre es obligatorio');
  req('lastName', data.lastName, 'Last name is required', 'El apellido es obligatorio');

  if (data.email.trim().isEmpty) {
    errors['email'] = es ? 'El correo es obligatorio' : 'Email is required';
  } else if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(data.email.trim())) {
    errors['email'] = es ? 'Correo electrónico inválido' : 'Invalid email address';
  }

  if (data.phone.trim().isEmpty) {
    errors['phone'] = es ? 'El teléfono es obligatorio' : 'Phone is required';
  } else if (!RegExp(r'^[\d\s\-+().]{7,}$').hasMatch(data.phone.trim())) {
    errors['phone'] = es ? 'Teléfono inválido' : 'Invalid phone number';
  }

  req('address', data.address, 'Address is required', 'La dirección es obligatoria');
  req('city', data.city, 'City is required', 'La ciudad es obligatoria');
  req('state', data.state, 'State is required', 'El estado es obligatorio');

  if (data.zip.trim().isEmpty) {
    errors['zip'] = es ? 'El código postal es obligatorio' : 'ZIP code is required';
  } else if (!RegExp(r'^[A-Za-z0-9][A-Za-z0-9\s-]{2,11}[A-Za-z0-9]$')
      .hasMatch(data.zip.trim())) {
    errors['zip'] = es ? 'Código postal inválido' : 'Invalid ZIP / postal code';
  }

  final cardDigits = data.cardNumber.replaceAll(RegExp(r'\s'), '');
  if (cardDigits.isEmpty) {
    errors['cardNumber'] = es ? 'Número de tarjeta obligatorio' : 'Card number is required';
  } else if (!RegExp(r'^\d{13,19}$').hasMatch(cardDigits)) {
    errors['cardNumber'] = es ? 'Número de tarjeta inválido' : 'Invalid card number';
  }

  req('cardName', data.cardName, 'Name on card is required', 'Nombre en la tarjeta obligatorio');

  if (data.expiry.trim().isEmpty) {
    errors['expiry'] = es ? 'Vencimiento obligatorio' : 'Expiry is required';
  } else if (!RegExp(r'^(0[1-9]|1[0-2])/\d{2}$').hasMatch(data.expiry.trim())) {
    errors['expiry'] = es ? 'Vencimiento inválido (MM/YY)' : 'Invalid expiry (MM/YY)';
  }

  if (data.cvv.trim().isEmpty) {
    errors['cvv'] = es ? 'CVV obligatorio' : 'CVV is required';
  } else if (!RegExp(r'^\d{3,4}$').hasMatch(data.cvv.trim())) {
    errors['cvv'] = es ? 'CVV inválido' : 'Invalid CVV';
  }

  return errors;
}

String _cardBrand(String cardNumber) {
  if (cardNumber.startsWith('4')) return 'Visa';
  if (cardNumber.startsWith('5')) return 'Mastercard';
  if (cardNumber.startsWith('3')) return 'Amex';
  return 'Card';
}

String _generateOrderId() {
  final stamp = DateTime.now().millisecondsSinceEpoch.toRadixString(36).toUpperCase();
  final random = Random().nextInt(0xFFFF).toRadixString(36).toUpperCase().padLeft(4, '0');
  return 'OE-$stamp-$random';
}

OrderCustomer _customerFromForm(CheckoutFormData data) => OrderCustomer(
      firstName: data.firstName.trim(),
      lastName: data.lastName.trim(),
      email: data.email.trim(),
      phone: data.phone.trim(),
      address: data.address.trim(),
      city: data.city.trim(),
      state: data.state.trim(),
      zip: data.zip.trim(),
    );

List<OrderLineItem> _orderItemsFromCart(List<CartLine> lines) => lines
    .map(
      (line) => OrderLineItem(
        productId: line.product.id,
        name: line.product.name,
        price: line.product.price,
        quantity: line.item.quantity,
        lineTotal: line.lineTotal,
        imagePath: line.product.imagePath,
      ),
    )
    .toList();

/// Demo checkout — mirrors web `processDemoPayment`.
class CheckoutResult {
  final bool success;
  final Order? order;
  final Map<String, String>? fieldErrors;
  final String? errorMessage;

  const CheckoutResult({
    required this.success,
    this.order,
    this.fieldErrors,
    this.errorMessage,
  });
}

Future<CheckoutResult> processDemoCheckout({
  required CheckoutFormData formData,
  required List<CartLine> cartLines,
  required OrderTotals totals,
  required String lang,
}) async {
  if (cartLines.isEmpty) {
    return CheckoutResult(
      success: false,
      errorMessage: lang == 'es' ? 'Su carrito está vacío.' : 'Your cart is empty.',
    );
  }

  final errors = validateCheckoutForm(formData, lang);
  if (errors.isNotEmpty) {
    return CheckoutResult(success: false, fieldErrors: errors);
  }

  await Future<void>.delayed(const Duration(milliseconds: 1200));

  final cardDigits = formData.cardNumber.replaceAll(RegExp(r'\s'), '');
  if (cardDigits.endsWith('0000')) {
    return CheckoutResult(
      success: false,
      errorMessage: lang == 'es'
          ? 'El pago fue rechazado. Verifique los datos de su tarjeta.'
          : 'Payment was declined. Please check your card details or try a different card.',
    );
  }

  final order = Order(
    id: _generateOrderId(),
    createdAt: DateTime.now().toIso8601String(),
    status: 'confirmed',
    customer: _customerFromForm(formData),
    items: _orderItemsFromCart(cartLines),
    totals: totals,
    payment: OrderPayment(
      provider: 'demo',
      status: 'succeeded',
      last4: cardDigits.length >= 4 ? cardDigits.substring(cardDigits.length - 4) : null,
      brand: _cardBrand(cardDigits),
    ),
    lang: lang,
  );

  return CheckoutResult(success: true, order: order);
}
