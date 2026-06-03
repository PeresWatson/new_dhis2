// lib/features/auth/presentation/screens/login_screen.dart

import 'package:flutter/material.dart';
import '../controllers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  final AuthProvider provider;
  final VoidCallback onLoginSuccess; // Callback to route to Dashboard after auth

  const LoginScreen({
    Key? key,
    required this.provider,
    required this.onLoginSuccess,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _serverController = TextEditingController(text: 'https://play.dhis2.org/demo');
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.provider.addListener(_refreshUi);
  }

  @override
  void dispose() {
    widget.provider.removeListener(_refreshUi);
    _serverController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _refreshUi() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final authState = widget.provider;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Branding Header Asset Elements
                const Icon(
                  Icons.analytics_rounded, 
                  size: 80, 
                  color: Color(0xFF1D5288), // DHIS2 Brand Corporate Blue
                ),
                const SizedBox(height: 12),
                const Text(
                  'DHIS2 Mobile Dashboard',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1D5288)),
                ),
                const Text(
                  'Analytics & Decision Support',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 40),

                // Error Feedback Alert Banner
                if (authState.errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      authState.errorMessage!,
                      style: TextStyle(color: Colors.red.shade800, fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // 2. Server Instance URL Input
                _buildInputLabel('Server URL Instance'),
                TextFormField(
                  controller: _serverController,
                  keyboardType: TextInputType.url,
                  decoration: _buildInputDecoration('e.g., https://play.dhis2.org/demo', Icons.dns_outlined),
                  validator: (val) => (val == null || val.isEmpty) ? 'Please configure your server URL' : null,
                ),
                const SizedBox(height: 16),

                // 3. Username Field Input
                _buildInputLabel('Username'),
                TextFormField(
                  controller: _usernameController,
                  keyboardType: TextInputType.text,
                  decoration: _buildInputDecoration('Enter your system username', Icons.person_outline),
                  validator: (val) => (val == null || val.isEmpty) ? 'Username parameter required' : null,
                ),
                const SizedBox(height: 16),

                // 4. Password Field Input
                _buildInputLabel('Password'),
                TextFormField(
                  controller: _passwordController,
                  obscureText: authState.obscurePassword,
                  decoration: _buildInputDecoration('Enter account security password', Icons.lock_outline_rounded).copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        authState.obscurePassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                        color: const Color(0xFF1D5288),
                        size: 20,
                      ),
                      onPressed: () => authState.togglePasswordVisibility(),
                    ),
                  ),
                  validator: (val) => (val == null || val.isEmpty) ? 'Password parameter required' : null,
                ),
                const SizedBox(height: 32),

                // 5. Submit Sign-In Action Component Button
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: authState.isLoading
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              final success = await authState.login(
                                serverUrl: _serverController.text,
                                username: _usernameController.text,
                                password: _passwordController.text,
                              );
                              if (success) {
                                widget.onLoginSuccess();
                              }
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1D5288),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: authState.isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                          )
                        : const Text(
                            'SIGN IN TO DASHBOARD',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Footer Version Tracking metadata
                const Text(
                  'v2.41 • Secure System Framework Platform',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, color: Colors.grey, letterSpacing: 0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String text) {
    return Padding(
  padding: const EdgeInsets.only(bottom: 6.0, left: 2.0),
  child: Text(
    "Your Title Here",
    style: const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 13,
      color: Color(0xFF2D3748),
    ),
  ),
);
  }

  InputDecoration _buildInputDecoration(String hint, IconData prefixIcon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
      prefixIcon: Icon(prefixIcon, color: const Color(0xFF1D5288), size: 20),
      contentPadding: const EdgeInsets.symmetric(vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF1D5288), width: 1.5)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.red.shade300)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.red.shade400, width: 1.5)),
    );
  }
}