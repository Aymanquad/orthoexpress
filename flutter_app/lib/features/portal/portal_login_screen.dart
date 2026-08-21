import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../config/theme.dart';
import '../../core/widgets/content_page_scaffold.dart';
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

String friendlyAuthError(Object err, String lang) {
  final raw = err.toString()
      .replaceFirst('PortalApiException: ', '')
      .replaceFirst('Exception: ', '')
      .trim();
  final lower = raw.toLowerCase();
  if (lower.contains('connect') ||
      lower.contains('reach') ||
      lower.contains('timeout') ||
      lower.contains('socket')) {
    return PortalLabels.apiUnavailable.forLang(lang);
  }
  if (lower.contains('code') ||
      lower.contains('otp') ||
      lower.contains('invalid') ||
      lower.contains('expired') ||
      lower.contains('verif')) {
    return PortalLabels.invalidCodeRetry.forLang(lang);
  }
  if (raw.isEmpty) return PortalLabels.genericError.forLang(lang);
  return raw;
}

Future<bool> confirmSignOut(BuildContext context, String lang) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(PortalLabels.logoutConfirmTitle.forLang(lang)),
      content: Text(PortalLabels.logoutConfirmBody.forLang(lang)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: Text(PortalLabels.logoutConfirmNo.forLang(lang)),
        ),
        FilledButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          style: FilledButton.styleFrom(backgroundColor: AppColors.accent),
          child: Text(PortalLabels.logoutConfirmYes.forLang(lang)),
        ),
      ],
    ),
  );
  return result == true;
}

void showSignedInSnackBar(BuildContext context, String lang, {String? firstName}) {
  final message = (firstName != null && firstName.trim().isNotEmpty)
      ? PortalLabels.welcomeBackNamed(lang, firstName.trim())
      : PortalLabels.welcomeBack.forLang(lang);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
    ),
  );
}

class PortalLoginScreen extends StatefulWidget {
  const PortalLoginScreen({super.key});

  @override
  State<PortalLoginScreen> createState() => _PortalLoginScreenState();
}

class _PortalLoginScreenState extends State<PortalLoginScreen> {
  var _step = _LoginStep.phone;
  final _phoneController = TextEditingController();
  final _phoneFocus = FocusNode();
  final _codeControllers = List.generate(6, (_) => TextEditingController());
  final _codeFocus = List.generate(6, (_) => FocusNode());
  String _error = '';
  bool _loading = false;
  int _resendCooldown = 0;
  bool _autoVerifying = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final last = context.read<PortalAuthProvider>().lastPhone;
      if (last != null && last.isNotEmpty && _phoneController.text.isEmpty) {
        _phoneController.text = formatPortalPhone(last);
        setState(() {});
      }
      _phoneFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneFocus.dispose();
    for (final c in _codeControllers) {
      c.dispose();
    }
    for (final node in _codeFocus) {
      node.dispose();
    }
    super.dispose();
  }

  String get _phone => _phoneController.text;
  bool get _phoneValid => _phone.replaceAll(RegExp(r'\D'), '').length == 10;
  String get _code => _codeControllers.map((c) => c.text).join();

  void _clearCode() {
    for (final c in _codeControllers) {
      c.clear();
    }
  }

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(PortalLabels.codeSent.forLang(lang)),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _codeFocus.first.requestFocus();
      });
    } catch (err) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = friendlyAuthError(err, lang);
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

  Future<void> _verify({bool fromAuto = false}) async {
    final lang = context.read<LanguageProvider>().locale.languageCode;
    if (_code.length != 6) {
      if (!fromAuto) {
        setState(() => _error = PortalLabels.invalidCode.forLang(lang));
      }
      return;
    }
    if (_loading || _autoVerifying) return;
    setState(() {
      _error = '';
      _loading = true;
      if (fromAuto) _autoVerifying = true;
    });
    try {
      final patient = await context.read<PortalAuthProvider>().login(_phone, _code);
      if (!mounted) return;
      showSignedInSnackBar(
        context,
        lang,
        firstName: patient.displayFirstName,
      );
      context.go('/home');
    } catch (err) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _autoVerifying = false;
        _error = friendlyAuthError(err, lang);
      });
      _clearCode();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _codeFocus.first.requestFocus();
      });
    }
  }

  void _onCodeChanged(int index, String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');

    // Paste / SMS autofill of full code into any box.
    if (digits.length > 1) {
      final pasted = digits.length > 6 ? digits.substring(0, 6) : digits;
      for (var i = 0; i < 6; i++) {
        _codeControllers[i].text = i < pasted.length ? pasted[i] : '';
      }
      setState(() {
        if (_error.isNotEmpty) _error = '';
      });
      if (pasted.length == 6) {
        FocusScope.of(context).unfocus();
        _verify(fromAuto: true);
      } else {
        _codeFocus[pasted.length.clamp(0, 5)].requestFocus();
      }
      return;
    }

    final digit = digits.isEmpty ? '' : digits.substring(digits.length - 1);
    if (_codeControllers[index].text != digit) {
      _codeControllers[index].text = digit;
      _codeControllers[index].selection = TextSelection.collapsed(offset: digit.length);
    }
    setState(() {
      if (_error.isNotEmpty) _error = '';
    });

    if (digit.isEmpty && index > 0) {
      _codeFocus[index - 1].requestFocus();
    } else if (digit.isNotEmpty && index < 5) {
      _codeFocus[index + 1].requestFocus();
    } else if (digit.isNotEmpty && index == 5 && _code.length == 6) {
      FocusScope.of(context).unfocus();
      _verify(fromAuto: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().locale.languageCode;
    // Do not call context.go() here when already signed in — this screen can
    // stay mounted under StatefulShellRoute.indexedStack and would yank the
    // user back to Home from Account / Talk to a doctor. Router redirect handles it.

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
        const SizedBox(height: 12),
        Text(
          PortalLabels.privacyNote.forLang(lang),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textMuted,
                height: 1.4,
              ),
        ),
        const SizedBox(height: 8),
        Center(
          child: TextButton(
            onPressed: _loading ? null : () => context.go('/home'),
            child: Text(PortalLabels.continueAsGuest.forLang(lang)),
          ),
        ),
      ],
    );
  }

  Widget _phoneForm(String lang) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(PortalLabels.phoneHelp.forLang(lang)),
        const SizedBox(height: 16),
        TextField(
          controller: _phoneController,
          focusNode: _phoneFocus,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.telephoneNumber],
          inputFormatters: [_PhoneInputFormatter()],
          decoration: InputDecoration(
            labelText: PortalLabels.phoneLabel.forLang(lang),
            hintText: PortalLabels.phonePlaceholder.forLang(lang),
            prefixIcon: const Icon(Icons.phone_iphone_rounded),
          ),
          onChanged: (_) {
            setState(() {
              if (_error.isNotEmpty) _error = '';
            });
          },
          onSubmitted: (_) {
            if (_phoneValid && !_loading) _sendCode();
          },
        ),
        if (_error.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            _error,
            style: const TextStyle(color: Color(0xFF991B1B), fontWeight: FontWeight.w600),
          ),
        ],
        const SizedBox(height: 16),
        FilledButton(
          onPressed: _loading || !_phoneValid ? null : _sendCode,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.accent,
            minimumSize: const Size.fromHeight(48),
          ),
          child: _loading
              ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : Text(PortalLabels.sendCode.forLang(lang)),
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
            const gap = 4.0;
            final approx = (constraints.maxWidth - gap * 5) / 6;
            final fontSize = approx < 34 ? 15.0 : (approx < 40 ? 17.0 : 18.0);
            return Row(
              children: List.generate(6, (index) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: index == 0 ? 0 : gap),
                    child: TextField(
                      controller: _codeControllers[index],
                      focusNode: _codeFocus[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      textInputAction:
                          index == 5 ? TextInputAction.done : TextInputAction.next,
                      autofillHints: index == 0
                          ? const [AutofillHints.oneTimeCode]
                          : null,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: fontSize,
                            letterSpacing: 0,
                          ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6),
                      ],
                      decoration: const InputDecoration(
                        counterText: '',
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 0),
                      ),
                      onChanged: (value) => _onCodeChanged(index, value),
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
          Text(
            _error,
            style: const TextStyle(color: Color(0xFF991B1B), fontWeight: FontWeight.w600),
          ),
        ],
        const SizedBox(height: 16),
        FilledButton(
          onPressed: _loading || _code.length != 6 ? null : () => _verify(),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.accent,
            minimumSize: const Size.fromHeight(48),
          ),
          child: _loading
              ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : Text(PortalLabels.verify.forLang(lang)),
        ),
        const SizedBox(height: 8),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 0,
          children: [
            TextButton(
              onPressed: _loading
                  ? null
                  : () {
                      setState(() {
                        _step = _LoginStep.phone;
                        _clearCode();
                        _error = '';
                        _autoVerifying = false;
                      });
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) _phoneFocus.requestFocus();
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
