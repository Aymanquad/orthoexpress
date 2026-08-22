import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../config/theme.dart';
import '../../core/widgets/content_page_scaffold.dart';
import '../../providers/workplace_auth_provider.dart';

class WorkplaceLoginScreen extends StatefulWidget {
  const WorkplaceLoginScreen({super.key});

  @override
  State<WorkplaceLoginScreen> createState() => _WorkplaceLoginScreenState();
}

class _WorkplaceLoginScreenState extends State<WorkplaceLoginScreen> {
  final _email = TextEditingController(text: 'admin@orthoexpress.com');
  final _password = TextEditingController(text: 'admin123');
  bool _obscure = true;
  bool _loading = false;
  String _error = '';

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _loading = true;
      _error = '';
    });
    try {
      await context.read<WorkplaceAuthProvider>().login(_email.text, _password.text);
      if (!mounted) return;
      final home = context.read<WorkplaceAuthProvider>().user?.workplaceHome ?? '/more/admin';
      context.go(home);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ContentPageScaffold(
      title: 'Workplace sign in',
      lead: 'Admin and staff access for practice operations.',
      children: [
        TextField(
          controller: _email,
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          decoration: const InputDecoration(
            labelText: 'Email',
            prefixIcon: Icon(Icons.email_outlined),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _password,
          obscureText: _obscure,
          onSubmitted: (_) => _submit(),
          decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: const Icon(Icons.lock_outline_rounded),
            suffixIcon: IconButton(
              onPressed: () => setState(() => _obscure = !_obscure),
              icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Demo admin: admin@orthoexpress.com / admin123',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
        ),
        if (_error.isNotEmpty) ...[
          const SizedBox(height: 10),
          Text(_error, style: TextStyle(color: Colors.red.shade700, fontSize: 13)),
        ],
        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: _loading ? null : _submit,
            style: FilledButton.styleFrom(backgroundColor: AppColors.accent),
            child: Text(_loading ? 'Signing in…' : 'Sign in'),
          ),
        ),
      ],
    );
  }
}
