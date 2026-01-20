import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:win_rakant/providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  bool loading = false;
  String? error;

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  String? _validateEmail(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return 'Email is required';
    if (!s.contains('@')) return 'Enter a valid email';
    return null;
  }

  String? _validatePassword(String? v) {
    final s = (v ?? '');
    if (s.isEmpty) return 'Password is required';
    if (s.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  Future<void> _signIn() async {
    setState(() {
      error = null;
    });

    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);
    try {
      await ref
          .read(authServiceProvider)
          .signIn(email: emailCtrl.text.trim(), password: passCtrl.text);
      // main.dart هينقل تلقائي لما session تتعمل ✅
    } catch (e) {
      if (!mounted) return;
      setState(() => error = e.toString());
    } finally {
      if (!mounted) return;
      setState(() => loading = false);
    }
  }

  Future<void> _signUp() async {
    setState(() {
      error = null;
    });

    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);
    try {
      await ref
          .read(authServiceProvider)
          .signUp(email: emailCtrl.text.trim(), password: passCtrl.text);

      // ✅ رسالة واضحة بعد التسجيل
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('✅ تم إضافة السيارة')));
    } catch (e) {
      if (!mounted) return;
      setState(() => error = e.toString());
    } finally {
      if (!mounted) return;
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: emailCtrl,
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
                decoration: const InputDecoration(
                  labelText: 'Email *',
                  hintText: 'name@email.com',
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: passCtrl,
                obscureText: true,
                validator: _validatePassword,
                decoration: const InputDecoration(
                  labelText: 'Password *',
                  hintText: 'Min 6 characters',
                ),
              ),
              const SizedBox(height: 12),

              if (error != null)
                Text(error!, style: const TextStyle(color: Colors.red)),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: loading ? null : _signIn,
                      child: loading
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Sign In'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: loading ? null : _signUp,
                      child: const Text('Sign Up'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
