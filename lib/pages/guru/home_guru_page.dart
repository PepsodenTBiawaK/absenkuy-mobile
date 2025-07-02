import 'dart:convert';
import 'package:absenkuy_app/component/carousel_card.dart';
import 'package:absenkuy_app/component/header_section.dart';
import 'package:absenkuy_app/component/kelas_card.dart';
import 'package:absenkuy_app/component/pengumuman_section.dart';
import 'package:absenkuy_app/component/profil_section.dart';
import 'package:absenkuy_app/data/api.dart';
import 'package:absenkuy_app/pages/guru/absen_guru_page.dart';
import 'package:absenkuy_app/pages/logout_page.dart';
import 'package:absenkuy_app/pages/siswa/info_siswa_page.dart';
import 'package:absenkuy_app/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomePageGuru extends StatefulWidget {
  const HomePageGuru({super.key});

  @override
  State<HomePageGuru> createState() => _HomePageGuruState();
}

class _HomePageGuruState extends State<HomePageGuru> {
  String userName = '';
  String? token;

  final List<String> listGambar = [
    'assets/carousel/carousel1.jpg',
    'assets/carousel/carousel2.jpg',
    'assets/carousel/carousel3.jpg',
    'assets/carousel/carousel4.jpg',
    'assets/carousel/carousel5.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('name') ?? 'User';
    final savedToken = prefs.getString('token');
    setState(() {
      userName = name;
      token = savedToken;
    });
  }

  Future<List<Map<String, dynamic>>> fetchKelasGuru(String token) async {
    final response = await http.get(
      Uri.parse(Api.kelasGuru),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Gagal memuat data kelas yang diampu');
    }
  }

  Future<void> _refreshData() async {
    setState(() {}); // Memicu build ulang FutureBuilder
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna.primary50,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 8,
                      ),
                      child: Text(
                        "Selamat Datang 👋",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    Profil(
                      nama: userName,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ProfilPage()),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                CarouselCard(gambarList: listGambar),
                const SizedBox(height: 32),

                // Kelas yang Diampu
                Column(
                  children: [
                    Header(title: "Kelas di Ampu"),
                    const SizedBox(height: 22),
                    if (token == null)
                      const CircularProgressIndicator()
                    else
                      FutureBuilder<List<Map<String, dynamic>>>(
                        future: fetchKelasGuru(token!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Terjadi kesalahan: ${snapshot.error}');
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Text('Tidak ada data kelas');
                          }

                          final kelasList = snapshot.data!;
                          return Column(
                            spacing: 12,
                            children:
                                kelasList
                                    .map(
                                      (kelas) => KelasCard(
                                        title: kelas['nama_kelas'],
                                        idKelas: 'ID Kelas: ${kelas['id']}',
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (_) => AbsenPage(
                                                    showBackButton: true,
                                                    kelasId: kelas['id'],
                                                    kelasNama:
                                                        kelas['nama_kelas'],
                                                  ),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                    .toList(),
                          );
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 32),
                PengumumanSection(
                  title: "Pengumuman",
                  gambarList: listGambar,
                  onViewAll: () {
                    print("Lihat Semua Pengumuman");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => InfoSiswaPage(showBackButton: true),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
