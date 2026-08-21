import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../data/models/order.dart';
import '../../data/portal_api.dart';
import '../../core/shop/checkout_logic.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/responsive_page.dart';
import '../../data/products.dart';
import '../../data/shop_labels.dart';
import '../../data/portal_labels.dart';
import '../../providers/cart_provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/portal_auth_provider.dart';
import '../../providers/orders_provider.dart';
import '../portal/portal_login_screen.dart' show formatPortalPhone;
import 'widgets/order_summary_panel.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _form = CheckoutFormData();
  final _errors = <String, String>{};
  bool _processing = false;

  late final Map<String, TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = {
      'firstName': TextEditingController(),
      'lastName': TextEditingController(),
      'email': TextEditingController(),
      'phone': TextEditingController(),
      'address': TextEditingController(),
      'city': TextEditingController(),
      'state': TextEditingController(),
      'zip': TextEditingController(),
      'cardNumber': TextEditingController(),
      'cardName': TextEditingController(),
      'expiry': TextEditingController(),
      'cvv': TextEditingController(),
    };
    WidgetsBinding.instance.addPostFrameCallback((_) => _prefillFromProfile());
  }

  void _prefillFromProfile() {
    if (!mounted) return;
    final patient = context.read<PortalAuthProvider>().patient;
    if (patient == null) return;

    final first = patient.firstName?.trim() ?? '';
    final last = patient.lastName?.trim() ?? '';
    if (first.isNotEmpty) _controllers['firstName']!.text = first;
    if (last.isNotEmpty) _controllers['lastName']!.text = last;
    if (patient.phone.isNotEmpty) {
      _controllers['phone']!.text = formatPortalPhone(patient.phone);
    }
    final email = patient.email?.trim() ?? '';
    if (email.isNotEmpty) _controllers['email']!.text = email;
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _syncFormFromControllers() {
    _form.firstName = _controllers['firstName']!.text;
    _form.lastName = _controllers['lastName']!.text;
    _form.email = _controllers['email']!.text;
    _form.phone = _controllers['phone']!.text;
    _form.address = _controllers['address']!.text;
    _form.city = _controllers['city']!.text;
    _form.state = _controllers['state']!.text;
    _form.zip = _controllers['zip']!.text;
    _form.cardNumber = _controllers['cardNumber']!.text;
    _form.cardName = _controllers['cardName']!.text;
    _form.expiry = _controllers['expiry']!.text;
    _form.cvv = _controllers['cvv']!.text;
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().locale.languageCode;
    final cart = context.watch<CartProvider>();
    final lines = cart.cartLines;
    final totals = calculateOrderTotals(cart.subtotal);

    if (lines.isEmpty) {
      return EmptyState(
        icon: Icons.shopping_bag_outlined,
        title: ShopLabels.cartEmptyCheckout(lang),
        actionLabel: ShopLabels.goToShop(lang),
        onAction: () => context.go('/shop'),
      );
    }

    final formSection = _buildForm(lang);
    final summary = OrderSummaryPanel(lines: lines, totals: totals, lang: lang);
    final submitButton = FilledButton(
      onPressed: _processing ? null : () => _submit(lang, cart, totals),
      child: _processing
          ? Text(ShopLabels.processing(lang))
          : Text(ShopLabels.completeDemoOrder(lang, formatPrice(totals.total))),
    );

    if (context.isTablet) {
      return SingleChildScrollView(
        child: ResponsivePage(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                ShopLabels.demoNote(lang),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: formSection),
                  const SizedBox(width: 24),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [summary, const SizedBox(height: 16), submitButton],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: ResponsivePage(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    ShopLabels.demoNote(lang),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 20),
                  formSection,
                  const SizedBox(height: 20),
                  summary,
                  const SizedBox(height: 88),
                ],
              ),
            ),
          ),
        ),
        Material(
          color: AppColors.bgWhite,
          elevation: 8,
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: submitButton,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForm(String lang) {
    final patient = context.watch<PortalAuthProvider>().patient;
    final signedIn = patient != null;
    final lockedPhone = signedIn && (patient.phone).isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(ShopLabels.shippingInfo(lang), style: Theme.of(context).textTheme.titleLarge),
        if (signedIn) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.verified_user_outlined, color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    patient.phone.isEmpty
                        ? PortalLabels.signedInAs.forLang(lang)
                        : '${PortalLabels.signedInAs.forLang(lang)} · ${formatPortalPhone(patient.phone)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: _fieldGrid([
              _field('firstName', lang),
              _field('lastName', lang),
              _field('email', lang, keyboard: TextInputType.emailAddress),
              _field('phone', lang, keyboard: TextInputType.phone, readOnly: lockedPhone),
              _field('address', lang, fullWidth: true),
              _field('city', lang),
              _field('state', lang),
              _field('zip', lang),
            ]),
          ),
        ),
        const SizedBox(height: 24),
        Text(ShopLabels.paymentInfo(lang), style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          lang == 'es' ? 'Pago de demostración (sin cargo real)' : 'Demo Payment (no real charge)',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: _fieldGrid([
              _field('cardNumber', lang, onChanged: _onCardChanged),
              _field('cardName', lang),
              _field('expiry', lang, onChanged: _onExpiryChanged),
              _field('cvv', lang, obscure: true, digitsOnly: true),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _fieldGrid(List<Widget> fields) {
    if (context.isPhone) {
      return Column(
        children: fields
            .map((f) => Padding(padding: const EdgeInsets.only(bottom: 12), child: f))
            .toList(),
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = (constraints.maxWidth - 12) / 2;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: fields.map((f) => SizedBox(width: width, child: f)).toList(),
        );
      },
    );
  }

  Widget _field(
    String name,
    String lang, {
    TextInputType? keyboard,
    bool fullWidth = false,
    bool obscure = false,
    bool digitsOnly = false,
    bool readOnly = false,
    void Function(String)? onChanged,
  }) {
    final label = ShopLabels.fieldLabels[name]?.forLang(lang) ?? name;
    return TextField(
      controller: _controllers[name],
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        errorText: _errors[name],
        border: const OutlineInputBorder(),
      ),
      keyboardType: keyboard,
      obscureText: obscure,
      inputFormatters: digitsOnly ? [FilteringTextInputFormatter.digitsOnly] : null,
      onChanged: (v) {
        _errors.remove(name);
        onChanged?.call(v);
      },
    );
  }

  void _onCardChanged(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    final clipped = digits.length > 16 ? digits.substring(0, 16) : digits;
    final formatted = clipped.replaceAllMapped(RegExp(r'.{4}'), (m) => '${m.group(0)} ').trim();
    if (formatted != _controllers['cardNumber']!.text) {
      _controllers['cardNumber']!.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }

  void _onExpiryChanged(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    final clipped = digits.length > 4 ? digits.substring(0, 4) : digits;
    final formatted = clipped.length > 2
        ? '${clipped.substring(0, 2)}/${clipped.substring(2)}'
        : clipped;
    if (formatted != _controllers['expiry']!.text) {
      _controllers['expiry']!.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }

  Future<void> _submit(String lang, CartProvider cart, OrderTotals totals) async {
    _syncFormFromControllers();
    setState(() {
      _processing = true;
      _errors.clear();
    });

    final result = await processDemoCheckout(
      formData: _form,
      cartLines: cart.cartLines,
      totals: totals,
      lang: lang,
    );

    if (!mounted) return;
    setState(() => _processing = false);

    if (!result.success) {
      if (result.fieldErrors != null && result.fieldErrors!.isNotEmpty) {
        setState(() => _errors.addAll(result.fieldErrors!));
        return;
      }
      context.push('/shop/order-failure', extra: result.errorMessage);
      return;
    }

    final order = result.order!;
    await context.read<OrdersProvider>().saveOrder(order);
    try {
      await PortalApi.saveOrder(order);
    } catch (_) {
      // Local order remains the source of truth if the API is down.
    }
    await cart.clearCart();
    if (!mounted) return;
    context.go('/shop/order-success/${order.id}');
  }
}
