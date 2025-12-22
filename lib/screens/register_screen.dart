import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pure_plate/utility/validation.dart';
import 'package:pure_plate/providers/auth_provider.dart';
import 'package:pure_plate/providers/user_profile_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isPasswordVisible = false;
  String? uploadedImagePath;
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();  // ← ADDED
  final _ageController = TextEditingController();   // ← ADDED
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final userProfileProvider = context.read<UserProfileProvider>();

    await authProvider.register(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (!mounted) return;

    if (authProvider.errorMessage != null) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Registration Failed'),
          content: Text(authProvider.errorMessage!),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // Create user profile with name and age
      final user = authProvider.user;
      if (user != null) {
        await userProfileProvider.createProfile(
          uid: user.uid,
          email: user.email ?? '',
          name: _nameController.text.trim(),
          age: int.tryParse(_ageController.text.trim()) ?? 25,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Color(0xFF2D6A4F),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[900],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Join PurePlate today.",
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(height: 30),

                Center(
                  child: GestureDetector(
                    onTap: () {
                      setState(() => uploadedImagePath = "selected");
                    },
                    child: Stack(
                      children: [
                        Hero(
                          tag: 'profile-pic',
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: const Color(0xFFE8F5E9),
                            child: Icon(
                              uploadedImagePath == null
                                  ? Icons.person_rounded
                                  : Icons.check_rounded,
                              size: 50,
                              color: const Color(0xFF2D6A4F),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Color(0xFF2D6A4F),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Name Field (Full Width)
                      TextFormField(
                        controller: _nameController,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: "Name",
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: Validation.validateNotEmpty,
                      ),
                      const SizedBox(height: 16),

                      // Age Field
                      TextFormField(
                        controller: _ageController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: "Age",
                          prefixIcon: Icon(Icons.cake_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your age';
                          }
                          final age = int.tryParse(value);
                          if (age == null || age < 13 || age > 120) {
                            return 'Please enter a valid age (13-120)';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: "Email",
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        validator: Validation.validateEmail,
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          labelText: "Password",
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          errorMaxLines: 2,
                        ),
                        validator: Validation.validatePassword,
                      ),
                      const SizedBox(height: 32),

                      ElevatedButton(
                        onPressed: authProvider.isLoading ? null : _handleRegister,
                        child: authProvider.isLoading
                            ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                            : const Text("SIGN UP"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}