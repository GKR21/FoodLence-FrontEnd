import 'package:flutter/material.dart';

const _teal = Color(0xFF16A085);
const _ink = Color(0xFF111827);
const _gray500 = Color(0xFF6B7280);
const _gray400 = Color(0xFF9CA3AF);
const _gray700 = Color(0xFF374151);
const _border = Color(0xFFE5E7EB);
const _fieldBg = Color(0xFFF9FAFB);

class LoginScreen extends StatefulWidget {
  final VoidCallback? onSignIn;
  final VoidCallback? onCreateAccount;
  final VoidCallback? onForgotPassword;
  final VoidCallback? onGoogleSignIn;

  const LoginScreen({
    super.key,
    this.onSignIn,
    this.onCreateAccount,
    this.onForgotPassword,
    this.onGoogleSignIn,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController(text: 'heshan@example.com');
  final _pwCtrl = TextEditingController();
  bool _showPw = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _pwCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _teal,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: SizedBox(
                        width: 22,
                        height: 22,
                        child: CustomPaint(painter: _LogoPainter()),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'FoodLense',
                    style: TextStyle(
                      color: _ink,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              const Text(
                'Welcome back',
                style: TextStyle(
                  color: _ink,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Sign in to your account',
                style: TextStyle(color: _gray500, fontSize: 15),
              ),
              const SizedBox(height: 32),

              // Google button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: widget.onGoogleSignIn ?? () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: _border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    foregroundColor: _ink,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      _GoogleG(),
                      SizedBox(width: 12),
                      Text(
                        'Continue with Google',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _ink,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Divider
              Row(
                children: const [
                  Expanded(child: Divider(color: _border, height: 1)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'or',
                      style: TextStyle(
                        color: _gray400,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: _border, height: 1)),
                ],
              ),
              const SizedBox(height: 24),

              // Email
              const _Label('Email'),
              const SizedBox(height: 6),
              _Field(
                controller: _emailCtrl,
                hint: 'you@example.com',
                icon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              // Password
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const _Label('Password'),
                  GestureDetector(
                    onTap: widget.onForgotPassword,
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(
                        color: _teal,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              _Field(
                controller: _pwCtrl,
                hint: '••••••••',
                icon: Icons.lock_outline_rounded,
                obscure: !_showPw,
                trailing: GestureDetector(
                  onTap: () => setState(() => _showPw = !_showPw),
                  child: Icon(
                    _showPw
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 18,
                    color: _gray400,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Sign in
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: _teal.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: widget.onSignIn ?? () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _teal,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Sign In',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(color: _gray500, fontSize: 14),
                  ),
                  GestureDetector(
                    onTap: widget.onCreateAccount,
                    child: const Text(
                      'Create account',
                      style: TextStyle(
                        color: _teal,
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

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(
          color: _gray700,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      );
}

/// Text field that highlights its border and background on focus.
class _Field extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscure;
  final Widget? trailing;
  final TextInputType? keyboardType;

  const _Field({
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.trailing,
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: focused ? Colors.white : _fieldBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: focused ? _teal : _border),
      ),
      child: Row(
        children: [
          Icon(widget.icon, size: 18, color: _gray400),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: _focus,
              obscureText: widget.obscure,
              keyboardType: widget.keyboardType,
              style: const TextStyle(color: _ink, fontSize: 14),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: widget.hint,
                hintStyle: const TextStyle(color: _gray400),
              ),
            ),
          ),
          if (widget.trailing != null) widget.trailing!,
        ],
      ),
    );
  }
}

/// Camera-lens style logo: ring, centre dot and four tick marks.
class _LogoPainter extends CustomPainter {
  const _LogoPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 52;
    final c = Offset(26 * s, 26 * s);
    final stroke = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5 * s
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(c, 20 * s, stroke);
    canvas.drawCircle(c, 3 * s, Paint()..color = Colors.white);

    canvas.drawLine(Offset(26 * s, 6 * s), Offset(26 * s, 10 * s), stroke);
    canvas.drawLine(Offset(26 * s, 42 * s), Offset(26 * s, 46 * s), stroke);
    canvas.drawLine(Offset(6 * s, 26 * s), Offset(10 * s, 26 * s), stroke);
    canvas.drawLine(Offset(42 * s, 26 * s), Offset(46 * s, 26 * s), stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Simple multicolour "G" so no image asset or SVG package is needed.
/// Swap for an SvgPicture (flutter_svg) or an asset image if you want the
/// exact Google logo.
class _GoogleG extends StatelessWidget {
  const _GoogleG();

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (rect) => const LinearGradient(
        colors: [
          Color(0xFFEA4335),
          Color(0xFFFBBC05),
          Color(0xFF34A853),
          Color(0xFF4285F4),
        ],
        stops: [0.0, 0.35, 0.65, 1.0],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(rect),
      child: const Text(
        'G',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w800,
          height: 1,
        ),
      ),
    );
  }
}