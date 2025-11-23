import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
    ));
    runApp(const MyApp());
}

class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'PurePlate Auth',
            theme: ThemeData(
                primaryColor: const Color(0xFF2D6A4F),
                scaffoldBackgroundColor: const Color(0xFFF7F9F7),
                fontFamily: 'Roboto',
                colorScheme: ColorScheme.fromSwatch().copyWith(
                    primary: const Color(0xFF2D6A4F),
                    secondary: const Color(0xFFD8F3DC),
                ),
                inputDecorationTheme: InputDecorationTheme(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFF2D6A4F), width: 1.5),
                    ),
                    prefixIconColor: const Color(0xFF2D6A4F),
                    suffixIconColor: Colors.grey,
                    labelStyle: TextStyle(color: Colors.grey[600]),
                ),
                elevatedButtonTheme: ElevatedButtonThemeData(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2D6A4F),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                        ),
                    ),
                ),
                outlinedButtonTheme: OutlinedButtonThemeData(
                    style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF2D6A4F),
                        side: const BorderSide(color: Color(0xFF2D6A4F), width: 1.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                ),
            ),
            routes: {
                '/': (context) => const LoginScreen(),
                '/register': (context) => const RegisterScreen(),
                '/home': (context) => const HomeScreen(),
                '/reset': (context) => const ResetPasswordScreen(),
            },
        );
    }
}

class LoginScreen extends StatefulWidget {
    const LoginScreen({super.key});

    @override
    State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    bool _isPasswordVisible = false;
    bool _isLoading = false;

    Future<void> _handleLogin() async {
        FocusScope.of(context).unfocus();

        setState(() => _isLoading = true);

        await Future.delayed(const Duration(seconds: 2));

        if (mounted) {
            setState(() => _isLoading = false);
            Navigator.pushReplacementNamed(context, '/home');
        }
    }

    @override
    Widget build(BuildContext context) {
        return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
                body: SafeArea(
                    child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                                const SizedBox(height: 40),
                                Center(
                                    child: Hero(
                                        tag: 'auth-icon',
                                        child: Container(
                                            padding: const EdgeInsets.all(20),
                                            decoration: const BoxDecoration(
                                                color: Color(0xFFD8F3DC),
                                                shape: BoxShape.circle,
                                            ),
                                            child: const Icon(Icons.lock_open_rounded, color: Color(0xFF2D6A4F), size: 48),
                                        ),
                                    ),
                                ),
                                const SizedBox(height: 30),

                                Text(
                                    "Welcome Back",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueGrey[900],
                                    ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                    "Sign in to continue your healthy journey",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                                ),
                                const SizedBox(height: 40),

                                TextField(
                                    controller: emailCtrl,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    decoration: const InputDecoration(
                                        labelText: "Email",
                                        prefixIcon: Icon(Icons.email_outlined),
                                    ),
                                ),
                                const SizedBox(height: 20),

                                TextField(
                                    controller: passCtrl,
                                    obscureText: !_isPasswordVisible,
                                    textInputAction: TextInputAction.done,
                                    decoration: InputDecoration(
                                        labelText: "Password",
                                        prefixIcon: const Icon(Icons.lock_outline),
                                        suffixIcon: IconButton(
                                            icon: Icon(
                                                _isPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                            ),
                                            onPressed: () {
                                                setState(() {
                                                    _isPasswordVisible = !_isPasswordVisible;
                                                });
                                            },
                                        ),
                                    ),
                                ),

                                Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                        onPressed: () => Navigator.pushNamed(context, '/reset'),
                                        child: const Text(
                                            "Forgot Password?",
                                            style: TextStyle(color: Color(0xFF2D6A4F), fontWeight: FontWeight.bold),
                                        ),
                                    ),
                                ),

                                const SizedBox(height: 24),

                                ElevatedButton(
                                    onPressed: _isLoading ? null : _handleLogin,
                                    child: _isLoading
                                        ? const SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5)
                                    )
                                        : const Text("LOGIN"),
                                ),

                                const SizedBox(height: 20),

                                OutlinedButton(
                                    onPressed: _isLoading ? null : () => Navigator.pushNamed(context, '/register'),
                                    child: const Text("CREATE ACCOUNT"),
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

class RegisterScreen extends StatefulWidget {
    const RegisterScreen({super.key});

    @override
    State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
    bool _isPasswordVisible = false;
    bool _isLoading = false;
    String? uploadedImagePath;

    Future<void> _handleRegister() async {
        FocusScope.of(context).unfocus();
        setState(() => _isLoading = true);
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
            setState(() => _isLoading = false);
            Navigator.pushReplacementNamed(context, '/home');
        }
    }

    @override
    Widget build(BuildContext context) {
        return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
                appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leading: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF2D6A4F)),
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
                                                            uploadedImagePath == null ? Icons.person_rounded : Icons.check_rounded,
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
                                                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                                                    ),
                                                )
                                            ],
                                        ),
                                    ),
                                ),
                                const SizedBox(height: 30),

                                Row(
                                    children: [
                                        Expanded(
                                            child: TextField(
                                                textInputAction: TextInputAction.next,
                                                decoration: const InputDecoration(
                                                    labelText: "Name",
                                                    prefixIcon: Icon(Icons.person_outline),
                                                ),
                                            ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                            child: TextField(
                                                textInputAction: TextInputAction.next,
                                                decoration: const InputDecoration(
                                                    labelText: "Surname",
                                                    prefixIcon: Icon(Icons.person_outline),
                                                ),
                                            ),
                                        ),
                                    ],
                                ),
                                const SizedBox(height: 16),

                                TextField(
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    decoration: const InputDecoration(
                                        labelText: "Email",
                                        prefixIcon: Icon(Icons.email_outlined),
                                    ),
                                ),
                                const SizedBox(height: 16),

                                TextField(
                                    obscureText: !_isPasswordVisible,
                                    textInputAction: TextInputAction.done,
                                    decoration: InputDecoration(
                                        labelText: "Password",
                                        prefixIcon: const Icon(Icons.lock_outline),
                                        suffixIcon: IconButton(
                                            icon: Icon(
                                                _isPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                            ),
                                            onPressed: () {
                                                setState(() {
                                                    _isPasswordVisible = !_isPasswordVisible;
                                                });
                                            },
                                        ),
                                    ),
                                ),
                                const SizedBox(height: 32),

                                ElevatedButton(
                                    onPressed: _isLoading ? null : _handleRegister,
                                    child: _isLoading
                                        ? const SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5)
                                    )
                                        : const Text("SIGN UP"),
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

class ResetPasswordScreen extends StatefulWidget {
    const ResetPasswordScreen({super.key});

    @override
    State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
    // Kontrolörleri tanımlıyoruz
    final emailCtrl = TextEditingController();
    final codeCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();

    // Durum değişkenleri
    bool _isPasswordVisible = false;
    bool _isLoading = false;
    bool _isCodeSent = false; // Kod gönderildi mi?

    // Simüle edilmiş "Kayıtlı Kullanıcılar" listesi
    final List<String> _registeredEmails = [
        'user@gmail.com',
        'admin@pureplate.com',
        'demo@test.com'
    ];

    Future<void> _handleSendCode() async {
        FocusScope.of(context).unfocus(); // Klavyeyi kapat

        // Boş kontrolü
        if (emailCtrl.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Please enter your email address"), backgroundColor: Colors.orange),
            );
            return;
        }

        setState(() => _isLoading = true);

        // API Simülasyonu (2 saniye bekle)
        await Future.delayed(const Duration(seconds: 2));

        if (!mounted) return;

        setState(() => _isLoading = false);

        // Mail kontrolü (Kullanıcının isteği üzerine logic)
        if (_registeredEmails.contains(emailCtrl.text.trim().toLowerCase())) {
            // Başarılı: Kod gönderildi
            setState(() => _isCodeSent = true);
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Verification code sent!"), backgroundColor: Colors.green),
            );
        } else {
            // Başarısız: Kullanıcı bulunamadı
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("User not found"), backgroundColor: Colors.red),
            );
        }
    }

    Future<void> _handleResetPassword() async {
        FocusScope.of(context).unfocus();
        setState(() => _isLoading = true);
        await Future.delayed(const Duration(seconds: 2));

        if (!mounted) return;

        setState(() => _isLoading = false);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Password Reset Successful")),
        );
    }

    @override
    Widget build(BuildContext context) {
        return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
                appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leading: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF2D6A4F)),
                        onPressed: () => Navigator.pop(context),
                    ),
                ),
                body: SafeArea(
                    child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                                Hero(
                                    tag: 'auth-icon',
                                    child: Container(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                                color: const Color(0xFFD8F3DC),
                                                borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: const Icon(Icons.mark_email_read_outlined, color: Color(0xFF2D6A4F), size: 30),
                                        ),
                                    ),
                                ),
                                const SizedBox(height: 20),

                                Text(
                                    "Reset Password",
                                    style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueGrey[900],
                                    ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                    _isCodeSent
                                        ? "Enter the code sent to your email."
                                        : "Enter your email to receive a verification code.",
                                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                                ),
                                const SizedBox(height: 30),

                                // 1. ADIM: E-POSTA GİRİŞİ (Her zaman görünür, kod gönderildiyse disable olur)
                                TextField(
                                    controller: emailCtrl,
                                    keyboardType: TextInputType.emailAddress,
                                    enabled: !_isCodeSent, // Kod gönderildiyse değiştirilemesin
                                    decoration: const InputDecoration(
                                        labelText: "Email Address",
                                        prefixIcon: Icon(Icons.email_outlined),
                                    ),
                                ),

                                // Kod gönderilmediyse "Send Code" butonunu göster
                                if (!_isCodeSent) ...[
                                    const SizedBox(height: 24),
                                    ElevatedButton(
                                        onPressed: _isLoading ? null : _handleSendCode,
                                        child: _isLoading
                                            ? const SizedBox(
                                            height: 24,
                                            width: 24,
                                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5)
                                        )
                                            : const Text("SEND VERIFICATION CODE"),
                                    ),
                                ],

                                // 2. ADIM: KOD VE ŞİFRE GİRİŞİ (Sadece kod gönderildiyse görünür)
                                if (_isCodeSent) ...[
                                    const SizedBox(height: 24),

                                    TextField(
                                        controller: codeCtrl,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                            labelText: "Verification Code",
                                            prefixIcon: Icon(Icons.numbers),
                                        ),
                                    ),
                                    const SizedBox(height: 16),

                                    TextField(
                                        controller: passCtrl,
                                        obscureText: !_isPasswordVisible,
                                        decoration: InputDecoration(
                                            labelText: "New Password",
                                            prefixIcon: const Icon(Icons.lock_outline),
                                            suffixIcon: IconButton(
                                                icon: Icon(_isPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                                                onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                                            ),
                                        ),
                                    ),
                                    const SizedBox(height: 16),

                                    TextField(
                                        controller: confirmCtrl,
                                        obscureText: !_isPasswordVisible,
                                        decoration: const InputDecoration(
                                            labelText: "Confirm Password",
                                            prefixIcon: Icon(Icons.lock_reset),
                                        ),
                                    ),
                                    const SizedBox(height: 32),

                                    ElevatedButton(
                                        onPressed: _isLoading ? null : _handleResetPassword,
                                        child: _isLoading
                                            ? const SizedBox(
                                            height: 24,
                                            width: 24,
                                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5)
                                        )
                                            : const Text("RESET PASSWORD"),
                                    ),
                                ],
                            ],
                        ),
                    ),
                ),
            ),
        );
    }
}

class HomeScreen extends StatelessWidget {
    const HomeScreen({super.key});

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                title: const Text(
                    "PurePlate",
                    style: TextStyle(color: Color(0xFF2D6A4F), fontWeight: FontWeight.bold),
                ),
                centerTitle: true,
                actions: [
                    IconButton(
                        onPressed: () => Navigator.pushReplacementNamed(context, '/'),
                        icon: const Icon(Icons.logout, color: Colors.grey),
                    )
                ],
            ),
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        Hero(
                            tag: 'home-icon',
                            child: Icon(Icons.restaurant_menu_rounded, size: 80, color: Colors.green.shade200),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                            "Welcome Home!",
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D6A4F),
                            ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                            "Your dashboard is coming soon.",
                            style: TextStyle(color: Colors.grey),
                        ),
                    ],
                ),
            ),
        );
    }
}
