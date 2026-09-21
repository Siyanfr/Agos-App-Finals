import 'package:flutter/material.dart';
import '../theme.dart';
import '../services/auth_service.dart';
import '../widgets/primary_button.dart';
import '../widgets/text_input_field.dart';
import 'citizen/citizen_dashboard_screen.dart';
import 'authority/authority_dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final appUser = await _authService.signIn(
        _usernameController.text.trim(),
        _passwordController.text,
      );

      if (!mounted) return;

      if (appUser.role == 'authority') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const AuthorityDashboardScreen(),
          ),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const CitizenDashboardScreen(),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Invalid credentials. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceTint,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.shield_outlined,
                    color: AppColors.primary,
                    size: 32,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                const Text(
                  'AGOS',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                const Text(
                  'Welcome to AGOS',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppSpacing.xs),
                const Text(
                  'Report illegally parked vehicles in your community.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: AppSpacing.lg),

                TextInputField(
                  label: '',
                  hint: 'Username',
                  controller: _usernameController,
                  leadingIcon: Icons.person_outline,
                ),
                const SizedBox(height: AppSpacing.md),

                TextInputField(
                  label: '',
                  hint: 'Password',
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  leadingIcon: Icons.lock_outline,
                  trailingIcon: _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  onTrailingIconTap: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),

                if (_errorMessage != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: AppColors.error, fontSize: 13),
                  ),
                ],

                const SizedBox(height: AppSpacing.lg),

                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    label: 'Login',
                    icon: Icons.arrow_forward,
                    isLoading: _isLoading,
                    onPressed: _handleLogin,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.account_balance_outlined,
                        size: 14, color: Colors.grey),
                    SizedBox(width: AppSpacing.xs),
                    Text(
                      'UNOFFICIAL UTILITY OF ANGELES CITY',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}