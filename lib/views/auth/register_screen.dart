import 'package:flutter/material.dart';
 
class AppColors {
  static const teal = Color(0xFF16A085);
  static const textDark = Color(0xFF111827);
  static const label = Color(0xFF374151);
  static const gray = Color(0xFF6B7280);
  static const border = Color(0xFFE5E7EB);
  static const fill = Color(0xFFF9FAFB);
  static const checkBorder = Color(0xFFD1D5DB);
}
 
class RegisterScreen extends StatefulWidget {
  /// Called when the user taps "Back" or "Sign in".
  final VoidCallback onGoToLogin;
 
  /// Called when the user taps "Create Account".
  final VoidCallback onCreateAccount;
 
  const RegisterScreen({
    super.key,
    required this.onGoToLogin,
    required this.onCreateAccount,
  });
 
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}
 
class _RegisterScreenState extends State<RegisterScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _agreed = false;
 
  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              GestureDetector(
                onTap: widget.onGoToLogin,
                behavior: HitTestBehavior.opaque,
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back, size: 20, color: AppColors.teal),
                    SizedBox(width: 8),
                    Text(
                      'Back',
                      style: TextStyle(
                        color: AppColors.teal,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
 
              const Text(
                'Create account',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Join FoodLense to scan smarter',
                style: TextStyle(fontSize: 15, color: AppColors.gray),
              ),
              const SizedBox(height: 32),
 
              // Fields
              _Field(
                label: 'Full name',
                placeholder: 'Heshan Perera',
                controller: _nameCtrl,
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 16),
              _Field(
                label: 'Email address',
                placeholder: 'you@example.com',
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              _Field(
                label: 'Password',
                placeholder: 'Min. 8 characters',
                controller: _passCtrl,
                obscure: true,
              ),
              const SizedBox(height: 16),
              _Field(
                label: 'Confirm password',
                placeholder: 'Re-enter password',
                controller: _confirmCtrl,
                obscure: true,
              ),
 
              // Terms checkbox
              const SizedBox(height: 24),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => setState(() => _agreed = !_agreed),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: 20,
                      height: 20,
                      margin: const EdgeInsets.only(top: 1),
                      decoration: BoxDecoration(
                        color: _agreed ? AppColors.teal : Colors.transparent,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color:
                              _agreed ? AppColors.teal : AppColors.checkBorder,
                          width: 2,
                        ),
                      ),
                      child: _agreed
                          ? const Icon(Icons.check, size: 13, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text.rich(
                        const TextSpan(
                          style: TextStyle(
                            color: AppColors.gray,
                            fontSize: 13,
                            height: 1.6,
                          ),
                          children: [
                            TextSpan(text: 'I agree to the '),
                            TextSpan(
                              text: 'Terms of Service',
                              style: TextStyle(
                                color: AppColors.teal,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
                                color: AppColors.teal,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
 
              // Create account button
              const SizedBox(height: 24),
              _PressableScale(
                onTap: widget.onCreateAccount,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.teal,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.teal.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Create Account',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
 
              // Sign in link
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(color: AppColors.gray, fontSize: 14),
                  ),
                  GestureDetector(
                    onTap: widget.onGoToLogin,
                    child: const Text(
                      'Sign in',
                      style: TextStyle(
                        color: AppColors.teal,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
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
 
/// Labeled text field that highlights (teal border, white fill) on focus.
class _Field extends StatefulWidget {
  final String label;
  final String placeholder;
  final TextEditingController controller;
  final bool obscure;
  final TextInputType? keyboardType;
 
  const _Field({
    required this.label,
    required this.placeholder,
    required this.controller,
    this.obscure = false,
    this.keyboardType,
  });
 
  @override
  State<_Field> createState() => _FieldState();
}
 
class _FieldState extends State<_Field> {
  final _focus = FocusNode();
 
  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() {}));
  }
 
  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    final focused = _focus.hasFocus;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            color: AppColors.label,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: focused ? Colors.white : AppColors.fill,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: focused ? AppColors.teal : AppColors.border,
            ),
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focus,
            obscureText: widget.obscure,
            keyboardType: widget.keyboardType,
            cursorColor: AppColors.teal,
            style: const TextStyle(fontSize: 14, color: AppColors.textDark),
            decoration: InputDecoration(
              hintText: widget.placeholder,
              hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}
 
/// Scales down slightly while pressed (like active:scale-[0.98]).
class _PressableScale extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
 
  const _PressableScale({required this.child, required this.onTap});
 
  @override
  State<_PressableScale> createState() => _PressableScaleState();
}
 
class _PressableScaleState extends State<_PressableScale> {
  bool _pressed = false;
 
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: widget.child,
      ),
    );
  }
}
 