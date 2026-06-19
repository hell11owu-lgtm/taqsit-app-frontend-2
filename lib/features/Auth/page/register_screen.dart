import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:installment/features/Auth/bloc/auth_bloc.dart';
import 'package:installment/features/Auth/bloc/auth_event.dart';
import 'package:installment/features/Auth/bloc/auth_state.dart';
// import 'package:installment/features/Auth/bloc/auth_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  // متحكمات النصوص لجمع البيانات
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _billingController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _billingController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        RegisterEvent(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          billingAccount: _billingController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            // الانتقال لصفحة تسجيل الدخول أو الرئيسية بعد النجاح
            context.go('/login');
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              /// ================= BACKGROUND GRADIENT =================
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFF8F6F1), Color(0xFFEDE7DA)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),

              /// ================= SOFT GLOW CIRCLES =================
              Positioned(
                top: -100,
                right: -100,
                child: Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFF4C95D).withOpacity(0.25),
                  ),
                ),
              ),

              Positioned(
                bottom: -120,
                left: -120,
                child: Container(
                  width: 350,
                  height: 350,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.4),
                  ),
                ),
              ),

              /// ================= CONTENT =================
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: _buildCard(state),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCard(AuthState state) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 40),

              _buildTextField(
                controller: _nameController,
                label: "الاسم الكامل",
                icon: Icons.person_outline,
                iconColor: Colors.blue,
              ),
              const SizedBox(height: 20),

              _buildTextField(
                controller: _emailController,
                label: "البريد الإلكتروني",
                icon: Icons.email_outlined,
                iconColor: Colors.redAccent,
              ),
              const SizedBox(height: 20),

              _buildTextField(
                controller: _phoneController,
                label: "رقم الهاتف",
                icon: Icons.phone_outlined,
                iconColor: Colors.green,
              ),
              const SizedBox(height: 20),

              _buildTextField(
                controller: _billingController,
                label: "الحساب البنكي",
                icon: Icons.account_balance_outlined,
                iconColor: Color(0xFFF59E0B),
              ),
              const SizedBox(height: 20),

              _buildTextField(
                controller: _passwordController,
                label: "كلمة المرور",
                icon: Icons.lock_outline,
                iconColor: Colors.indigo,
                isPassword: true,
              ),
              const SizedBox(height: 20),

              _buildTextField(
                controller: _confirmPasswordController,
                label: "تأكيد كلمة المرور",
                icon: Icons.lock_outline,
                iconColor: Colors.indigo,
                isPassword: true,
              ),

              const SizedBox(height: 40),

              _buildButton(state),

              const SizedBox(height: 20),

              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "إنشاء حساب",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          "ابدأ تجربة التقسيط بسهولة",
          style: TextStyle(color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildButton(AuthState state) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF4C95D),
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        onPressed: state is AuthLoading ? null : _submitForm,
        child: state is AuthLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.black,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                "إنشاء الحساب",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    Color iconColor = const Color(0xFF94A3B8),
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword && !_isPasswordVisible,
      style: const TextStyle(color: Color(0xFF0F172A)),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: iconColor),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: iconColor,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Color(0xFFF4C95D)),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("لديك حساب؟ ", style: TextStyle(color: Color(0xFF64748B))),
        TextButton(
          onPressed: () {
            // هكذا نقوم بالانتقال لصفحة أخرى
            context.go('/login');
          },
          child: const Text(
            "تسجيل الدخول",
            style: TextStyle(
              color: Color(0xFF2563EB),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
