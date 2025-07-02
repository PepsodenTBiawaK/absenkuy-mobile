import 'dart:convert';
import 'package:absenkuy_app/data/api.dart';
import 'package:absenkuy_app/pages/guru/dashboard_guru_page.dart';
import 'package:absenkuy_app/pages/siswa/dashboard_siswa_page.dart';
import 'package:absenkuy_app/utils/color.dart';
import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool isChecking = true; //Di awal app, untuk cek apakah user masih login
  bool _isLoading = false; //Saat tombol login ditekan

  void _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email dan password wajib diisi")),
      );
      return;
    }

    setState(() => _isLoading = true);

    final url = Uri.parse(Api.login);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);
        final String role = res['user']['role'];
        final String token = res['token'];
        final String name = res['user']['name'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('role', role);
        await prefs.setString('name', name);

        final now = DateTime.now().millisecondsSinceEpoch;
        await prefs.setInt('loginTime', now);

        setState(() => _isLoading = false);

        if (role == 'guru') {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => DashboardGuru()),
            (route) => false,
          );
        } else if (role == 'siswa') {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => DashboardSiswa()),
            (route) => false,
          );
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Role tidak dikenali')));
        }
      } else {
        setState(() => _isLoading = false);
        // final res = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          // SnackBar(content: Text(res['message'] ?? 'Login gagal')),
          SnackBar(content: Text('Email atau password salah')),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Terjadi kesalahan: $e")));
    }
  }

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final role = prefs.getString('role');
    final loginTime = prefs.getInt('loginTime');

    if (token != null && role != null && loginTime != null) {
      final now = DateTime.now().millisecondsSinceEpoch;
      final elapsed = now - loginTime;

      //Rumus , contoh 30 menit = 30 x 60 x 1000ms = 1.800.000
      if (elapsed > 18000000) {
        await prefs.clear();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Sesi login telah habis")));
        setState(() {
          isChecking = false; // tampilkan halaman login
        });
        return;
      }

      //Kalau gak expire sessionnya akan lanjut kesini guys
      Future.delayed(const Duration(milliseconds: 500), () {
        if (role == 'guru') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => DashboardGuru()),
          );
        } else if (role == 'siswa') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => DashboardSiswa()),
          );
        } else {
          //Hapus token jika role tidak valid
          prefs.clear();
        }
      });
    } else {
      setState(() {
        isChecking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isChecking) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      // appBar: AppBar(title: const Text("Login")),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg_login.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Center(
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              // mainAxisAlignment: MainAxisAlignment.center,
              // mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Warna.primary400, width: 1),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(32),
                            ),
                          ).blurred(
                            colorOpacity: 0.01,
                            blur: 15,
                            blurColor: Color(0xffEFF4FA),
                            borderRadius: BorderRadius.circular(32),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                            top: 66,
                            left: 22,
                            right: 22,
                            bottom: 32,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Title
                              Container(
                                padding: const EdgeInsets.only(bottom: 32),
                                child: Column(
                                  children: [
                                    Text(
                                      "Login Absensi",
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "silahkan login untukk melanjutkan",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Email Field
                              TextField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                  //Label Text
                                  label: Text(
                                    'Email',
                                    style: TextStyle(
                                      color: Warna.secondary800,
                                      fontSize: 14,
                                    ),
                                  ),
                                  //Hint Text
                                  hintText: 'Masukkan email anda',
                                  hintStyle: TextStyle(
                                    color: Warna.secondary800,
                                    fontSize: 12,
                                  ),
                                  filled: true,
                                  fillColor: Warna.primary50,
                                  //Border
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                    borderSide: BorderSide(
                                      color: Warna.primary200,
                                      width: 1,
                                    ),
                                  ),
                                  //Enable Border
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                    borderSide: BorderSide(
                                      color: Warna.primary200,
                                      width: 1,
                                    ),
                                  ),
                                  //Focused Border
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                    borderSide: BorderSide(
                                      color: Warna.primary400,
                                      width: 1,
                                    ),
                                  ),
                                  //Error Border
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                    borderSide: BorderSide(
                                      color: Warna.error600,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                style: const TextStyle(
                                  color: Warna.secondary800,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Password Field
                              TextField(
                                controller: _passwordController,
                                obscureText: !_isPasswordVisible,
                                decoration: InputDecoration(
                                  label: Text(
                                    'Password',
                                    style: TextStyle(
                                      color: Warna.secondary800,
                                      fontSize: 14,
                                    ),
                                  ),
                                  //Hint Text
                                  hintText: 'Masukkan password anda',
                                  hintStyle: TextStyle(
                                    color: Warna.secondary800,
                                    fontSize: 12,
                                  ),
                                  filled: true,
                                  fillColor: Warna.primary50,
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                    borderSide: BorderSide(
                                      color: Warna.primary200,
                                      width: 1,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                    borderSide: BorderSide(
                                      color: Warna.primary200,
                                      width: 1,
                                    ),
                                  ),
                                  //Focused Border
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                    borderSide: BorderSide(
                                      color: Warna.primary400,
                                      width: 1,
                                    ),
                                  ),
                                  //Error Border
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                    borderSide: BorderSide(
                                      color: Warna.error600,
                                      width: 1,
                                    ),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isPasswordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible =
                                            !_isPasswordVisible;
                                      });
                                    },
                                  ),
                                ),
                                style: const TextStyle(
                                  color: Warna.secondary800,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Button Login
                              if (_isLoading)
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  child: CircularProgressIndicator(),
                                )
                              else
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _login,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Warna.primary600,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 32,
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text(
                                      'Login',
                                      style: TextStyle(color: Warna.black100),
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 32),
                              // Lupa kata sandi?
                              TextButton(
                                onPressed: () {
                                  final name =
                                      _emailController.text
                                          .trim(); // atau controller nama jika ada
                                  final phoneNumber =
                                      '6289630776953'; // tanpa "+" dan awali dengan kode negara
                                  final message = Uri.encodeComponent(
                                    "Halo mimin Absenkuy, saya ingin mereset password.\nEmail saya: $name \n(Opsional)Password Baru: ",
                                  );
                                  final whatsappUrl =
                                      "https://wa.me/$phoneNumber?text=$message";

                                  // buka WhatsApp
                                  launchUrl(Uri.parse(whatsappUrl));
                                },
                                child: const Text(
                                  'Lupa Kata Sandi?',
                                  style: TextStyle(
                                    color: Warna.secondary800,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Positioned(
                  top: -50,
                  child: Image.asset(
                    'assets/logo.png',
                    width: 120,
                    height: 120,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
