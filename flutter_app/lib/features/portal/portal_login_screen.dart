import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../config/theme.dart';
import '../../core/widgets/content_page_scaffold.dart';
import '../../data/nav_labels.dart';
import '../../data/portal_api.dart';
import '../../data/portal_labels.dart';
import '../../providers/language_provider.dart';
import '../../providers/portal_auth_provider.dart';

String formatPortalPhone(String value) {
  final raw = value.replaceAll(RegExp(r'\D'), '');
  final digits = raw.length <= 10 ? raw : raw.substring(0, 10);
  if (digits.length <= 3) return digits;
  if (digits.length <= 6) return '(${digits.substring(0, 3)}) ${digits.substring(3)}';
  return '(${digits.substring(0, 3)}) ${digits.substring(3, 6)}-${digits.substring(6)}';
}

class PortalLoginScreen extends StatefulWidget {
  const PortalLoginScreen({super.key});

  @override
  State<PortalLoginScreen> createState() => _PortalLoginScreenState();
}

class _PortalLoginScreenState extends State<PortalLoginScreen> {
  var _step = _LoginStep.phone;
  final _phoneController = TextEditingController();
  final _codeDigits = List<String>.filled(6, '');
  final _codeFocus = List<FocusNode>.generate(6, (_) => FocusNode());
  String _error = '';
  bool _loading = false;
  int _resendCooldown = 0;

  @override
  void dispose() {
    _phoneController.dispose();
    for (final node in _codeFocus) {
      node.dispose();
    }
    super.dispose();
  }

  String get _phone => _phoneController.text;
  bool get _phoneValid => _phone.replaceAll(RegExp(r'\D'), '').length == 10;
  String get _code => _codeDigits.join();

  Future<void> _sendCode() async {
    final lang = context.read<LanguageProvider>().locale.languageCode;
    if (!_phoneValid) {
      setState(() => _error = PortalLabels.invalidPhone.forLang(lang));
      return;
    }
    setState(() {
      _error = '';
      _loading = true;
    });
    try {
      await PortalApi.requestOtp(_phone);
      if (!mounted) return;
      setState(() {
        _step = _LoginStep.code;
        _resendCooldown = 30;
        _loading = false;
      });
      _tickCooldown();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _codeFocus.first.requestFocus();
      });
    } catch (err) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = err.toString().replaceFirst('PortalApiException: ', '');
      });
    }
  }

  void _tickCooldown() {
    Future.doWhile(() async {
      await Future<void>.delayed(const Duration(seconds: 1));
      if (!mounted || _resendCooldown <= 0) return false;
      setState(() => _resendCooldown -= 1);
      return _resendCooldown > 0;
    });
  }

  Future<void> _verify() async {
    final lang = context.read<LanguageProvider>().locale.languageCode;
    if (_code.length != 6) {
      setState(() => _error = PortalLabels.invalidCode.forLang(lang));
      return;
    }
    setState(() {
      _error = '';
      _loading = true;
    });
    try {
      await context.read<PortalAuthProvider>().login(_phone, _code);
      if (!mounted) return;
      context.go('/more/portal');
    } catch (err) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = err.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().locale.languageCode;

    return ContentPageScaffold(
      title: PortalLabels.loginTitle.forLang(lang),
      lead: PortalLabels.loginSubtitle.forLang(lang),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: _step == _LoginStep.phone ? _phoneForm(lang) : _codeForm(lang),
          ),
        ),
        TextButton(
          onPressed: () => context.go('/more/patient-portal'),
          child: Text('← ${NavLabels.patientPortal.forLang(lang)}'),
        ),
      ],
    );
  }

  Widget _phoneForm(String lang) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(PortalLabels.phoneLabel.forLang(lang), style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 6),
        Text(PortalLabels.phoneHelp.forLang(lang)),
        const SizedBox(height: 16),
        TextField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          inputFormatters: [_PhoneInputFormatter()],
          decoration: InputDecoration(
            labelText: PortalLabels.phoneLabel.forLang(lang),
            hintText: PortalLabels.phonePlaceholder.forLang(lang),
          ),
          onChanged: (_) {
            setState(() {
              if (_error.isNotEmpty) _error = '';
            });
          },
        ),
        if (_error.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(_error, style: const TextStyle(color: Color(0xFF991B1B))),
        ],
        const SizedBox(height: 16),
        FilledButton(
          onPressed: _loading || !_phoneValid ? null : _sendCode,
          style: FilledButton.styleFrom(backgroundColor: AppColors.accent),
          child: Text(
            _loading ? PortalLabels.sending.forLang(lang) : PortalLabels.sendCode.forLang(lang),
          ),
        ),
      ],
    );
  }

  Widget _codeForm(String lang) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(PortalLabels.verifyTitle.forLang(lang), style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 6),
        Text(PortalLabels.verifySubtitle(lang, _phone)),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            const gap = 6.0;
            final boxWidth = ((constraints.maxWidth - gap * 5) / 6).clamp(32.0, 44.0);
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(6, (index) {
                return Padding(
                  padding: EdgeInsets.only(left: index == 0 ? 0 : gap),
                  child: SizedBox(
                    width: boxWidth,
                    child: TextField(
                      focusNode: _codeFocus[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        counterText: '',
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 0),
                      ),
                      onChanged: (value) {
                        final digit = value.replaceAll(RegExp(r'\D'), '');
                        setState(() {
                          _codeDigits[index] =
                              digit.isEmpty ? '' : digit.substring(digit.length - 1);
                        });
                        if (digit.isEmpty && index > 0) {
                          _codeFocus[index - 1].requestFocus();
                        } else if (digit.isNotEmpty && index < 5) {
                          _codeFocus[index + 1].requestFocus();
                        }
                      },
                      onSubmitted: (_) {
                        if (_code.length == 6) _verify();
                      },
                    ),
                  ),
                );
              }),
            );
          },
        ),
        if (_error.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(_error, style: const TextStyle(color: Color(0xFF991B1B))),
        ],
        const SizedBox(height: 16),
        FilledButton(
          onPressed: _loading ? null : _verify,
          style: FilledButton.styleFrom(backgroundColor: AppColors.accent),
          child: Text(
            _loading ? PortalLabels.verifying.forLang(lang) : PortalLabels.verify.forLang(lang),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 0,
          children: [
            TextButton(
              onPressed: () {
                setState(() {
                  _step = _LoginStep.phone;
                  _codeDigits.fillRange(0, 6, '');
                  _error = '';
                });
              },
              child: Text(PortalLabels.changeNumber.forLang(lang)),
            ),
            TextButton(
              onPressed: _resendCooldown > 0 || _loading ? null : _sendCode,
              child: Text(
                _resendCooldown > 0
                    ? PortalLabels.resendIn(lang, _resendCooldown)
                    : PortalLabels.resend.forLang(lang),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

enum _LoginStep { phone, code }

class _PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final formatted = formatPortalPhone(newValue.text);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
