import 'package:intl/intl.dart';

import '../../data/models/order.dart';
import '../../data/shop_labels.dart';

String formatOrderDate(String isoString, String lang) {
  final date = DateTime.tryParse(isoString);
  if (date == null) return isoString;
  final locale = lang == 'es' ? 'es_US' : 'en_US';
  return DateFormat.yMMMd(locale).add_jm().format(date.toLocal());
}

OrderStatusInfo orderStatusInfo(Order order, String lang) {
  final provider = order.payment?.provider;
  if (provider == 'demo') {
    return OrderStatusInfo(
      label: ShopLabels.orderStatusDemo(lang),
      description: ShopLabels.orderStatusDemoDesc(lang),
      isDemo: true,
    );
  }
  return OrderStatusInfo(
    label: lang == 'es' ? 'Confirmado' : 'Confirmed',
    description: lang == 'es'
        ? 'Su pedido está siendo preparado.'
        : 'Your order is being prepared.',
    isDemo: false,
  );
}

class OrderStatusInfo {
  final String label;
  final String description;
  final bool isDemo;

  const OrderStatusInfo({
    required this.label,
    required this.description,
    required this.isDemo,
  });
}
