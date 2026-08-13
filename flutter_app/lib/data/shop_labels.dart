import '../core/l10n/localized.dart';

/// Shop flow strings — from src/i18n/shop.js
class ShopLabels {
  static String demoNote(String lang) =>
      lang == 'es'
          ? 'Pago de demostración — los pedidos son simulados, no se realiza un pago real.'
          : 'Demo checkout — orders are simulated, no real payment is taken.';

  static String shippingInfo(String lang) =>
      lang == 'es' ? 'Información de envío' : 'Shipping Information';

  static String paymentInfo(String lang) => lang == 'es' ? 'Pago' : 'Payment';

  static String orderSummary(String lang) =>
      lang == 'es' ? 'Resumen del pedido' : 'Order Summary';

  static String subtotal(String lang) => lang == 'es' ? 'Subtotal' : 'Subtotal';
  static String shipping(String lang) => lang == 'es' ? 'Envío' : 'Shipping';
  static String tax(String lang) => lang == 'es' ? 'Impuesto' : 'Tax';
  static String total(String lang) => lang == 'es' ? 'Total' : 'Total';
  static String qty(String lang) => lang == 'es' ? 'Cant.' : 'Qty';

  static String processing(String lang) => lang == 'es' ? 'Procesando...' : 'Processing...';

  static String completeDemoOrder(String lang, String price) =>
      lang == 'es' ? 'Completar pedido demo — $price' : 'Complete Demo Order — $price';

  static String cartEmptyCheckout(String lang) =>
      lang == 'es'
          ? 'Su carrito está vacío. Agregue artículos antes de pagar.'
          : 'Your cart is empty. Add items before checking out.';

  static String goToShop(String lang) => lang == 'es' ? 'Ir a la tienda' : 'Go to Shop';

  static String myOrders(String lang) => lang == 'es' ? 'Mis pedidos' : 'My Orders';

  static String ordersSubtitle(String lang) =>
      lang == 'es'
          ? 'Rastree sus compras. Los pedidos demo se guardan localmente en su dispositivo.'
          : 'Track your shop purchases. Demo orders are saved locally on your device.';

  static String noOrdersYet(String lang) =>
      lang == 'es' ? 'Aún no hay pedidos' : 'No orders yet';

  static String ordersEmptyText(String lang) =>
      lang == 'es'
          ? 'Cuando complete el pago, sus pedidos aparecerán aquí con el estado actual.'
          : 'When you complete checkout, your orders will appear here with live status.';

  static String browseShop(String lang) =>
      lang == 'es' ? 'Explorar tienda' : 'Browse Shop';

  static String orderConfirmed(String lang) =>
      lang == 'es' ? '¡Pedido confirmado!' : 'Order Confirmed!';

  static String orderThankYou(String lang, String name) =>
      lang == 'es'
          ? 'Gracias, $name. Su pedido se realizó exitosamente.'
          : 'Thank you, $name. Your order has been placed successfully.';

  static String orderNotFound(String lang) =>
      lang == 'es' ? 'Pedido no encontrado' : 'Order Not Found';

  static String orderNotFoundText(String lang) =>
      lang == 'es'
          ? 'No pudimos encontrar un pedido con esa referencia.'
          : 'We could not find an order with that reference.';

  static String orderDetails(String lang) =>
      lang == 'es' ? 'Detalles del pedido' : 'Order Details';

  static String totalPaid(String lang) => lang == 'es' ? 'Total pagado' : 'Total Paid';

  static String shippingTo(String lang) => lang == 'es' ? 'Envío a' : 'Shipping to';

  static String confirmationEmail(String lang, String email) =>
      lang == 'es'
          ? 'Se enviará una confirmación a $email.'
          : 'A confirmation will be sent to $email.';

  static String paymentDemo(String lang) =>
      lang == 'es' ? 'Demo (simulado)' : 'Demo (simulated)';

  static String viewAllOrders(String lang) =>
      lang == 'es' ? 'Ver todos los pedidos' : 'View All Orders';

  static String continueShopping(String lang) =>
      lang == 'es' ? 'Seguir comprando' : 'Continue Shopping';

  static String viewReceipt(String lang) =>
      lang == 'es' ? 'Ver recibo' : 'View receipt';

  static String paymentFailedTitle(String lang) =>
      lang == 'es' ? 'Pago fallido' : 'Payment Failed';

  static String paymentFailedDefault(String lang) =>
      lang == 'es'
          ? 'No se pudo procesar su pago. Por favor intente de nuevo.'
          : 'Your payment could not be processed. Please try again.';

  static String orderHelp(String lang) =>
      lang == 'es'
          ? 'Los artículos de su carrito aún están guardados. Puede revisar su pedido e intentar de nuevo.'
          : 'Your cart items are still saved. You can review your order and try again.';

  static String tryAgain(String lang) => lang == 'es' ? 'Intentar de nuevo' : 'Try Again';
  static String backToCart(String lang) => lang == 'es' ? 'Volver al carrito' : 'Back to Cart';

  static String orderStatusDemo(String lang) =>
      lang == 'es' ? 'Confirmado (Demo)' : 'Confirmed (Demo)';

  static String orderStatusDemoDesc(String lang) =>
      lang == 'es'
          ? 'Pago simulado — no se realizó un cargo real.'
          : 'Simulated payment — no real charge was made.';

  static String item(String lang) => lang == 'es' ? 'artículo' : 'item';
  static String items(String lang) => lang == 'es' ? 'artículos' : 'items';

  static const fieldLabels = {
    'firstName': L10nString(en: 'First Name', es: 'Nombre'),
    'lastName': L10nString(en: 'Last Name', es: 'Apellido'),
    'email': L10nString(en: 'Email', es: 'Correo'),
    'phone': L10nString(en: 'Phone', es: 'Teléfono'),
    'address': L10nString(en: 'Street Address', es: 'Dirección'),
    'city': L10nString(en: 'City', es: 'Ciudad'),
    'state': L10nString(en: 'State', es: 'Estado'),
    'zip': L10nString(en: 'ZIP / Postal Code', es: 'Código postal'),
    'cardNumber': L10nString(en: 'Card Number', es: 'Número de tarjeta'),
    'cardName': L10nString(en: 'Name on Card', es: 'Nombre en la tarjeta'),
    'expiry': L10nString(en: 'Expiry (MM/YY)', es: 'Vencimiento (MM/AA)'),
    'cvv': L10nString(en: 'CVV', es: 'CVV'),
  };
}
