import 'package:absenkuy_app/component/header_section.dart';
import 'package:absenkuy_app/pages/login_page.dart';
import 'package:absenkuy_app/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna.primary50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
        title: const Text(
          'Profil',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Tombol Logout
            GestureDetector(
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => LoginPage()),
                  (route) => false,
                );
              },
              child: Container(
                padding: const EdgeInsets.all(22),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 24,
                  ),
                  decoration: BoxDecoration(
                    color: Warna.error100,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(25, 113, 153, 210),
                        blurRadius: 12,
                        offset: const Offset(0, 1),
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: Warna.error600),
                      const SizedBox(width: 12),
                      Text(
                        "Keluar",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Warna.error600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32,),
            // Header
            Header(title: "Tim AbsenKuy"),
            const SizedBox(height: 8),

            // List Nama
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                children: [
                  _buildNamaBox("Fadilah Aprianto"),
                  const SizedBox(height: 12),
                  _buildNamaBox("Mariyati Ulfah"),
                  const SizedBox(height: 12),
                  _buildNamaBox("Nanda Eza Amenthys R.S."),
                  const SizedBox(height: 12),
                  _buildNamaBox("Tina Melina"),
                  const SizedBox(height: 12),
                  _buildNamaBox("Via Olga Pangaribuan"),

                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildNamaBox(String nama) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(20, 0, 0, 0),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ), 
      child: Row(
        children: [
          const Icon(Icons.person_outline, color: Colors.grey),
          const SizedBox(width: 12),
          Text(
            nama,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
