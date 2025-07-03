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
import 'package:absenkuy_app/utils/list_gambar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomePageGuru extends StatefulWidget {
  const HomePageGuru({super.key});

  @override
  State<HomePageGuru> createState() => _HomePageGuruState();
}

class _HomePageGuruState extends State<HomePageGuru> {
  String userName = 'Guru';
  String? token;
  List<Map<String, dynamic>> kelasList = [];
  bool isLoading = true;

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
    if (token != null) {
      fetchKelasGuru();
    }
  }

  Future<void> fetchKelasGuru() async {
    try {
      final response = await http.get(
        Uri.parse(Api.kelasGuru),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        if (!mounted) return;
        setState(() {
          kelasList = data.cast<Map<String, dynamic>>();
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      isLoading = true;
    });
    await fetchKelasGuru();
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
                        style: const TextStyle(fontSize: 14),
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
                CarouselCard(gambarList: listCarousel),
                const SizedBox(height: 32),

                // Kelas yang Diampu
                Skeletonizer(
                  enabled: isLoading,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Skeleton.keep(child: Header(title: "Kelas di Ampu")),
                      const SizedBox(height: 22),
                      if (isLoading)
                        Skeleton.leaf(
                          child: Column(
                            children: List.generate(3, (index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Container(
                                  height: 78,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 22),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              );
                            }),
                          ),
                        )
                      else if (kelasList.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 22),
                          child: Text('Tidak ada data kelas'),
                        )
                      else
                        Column(
                          children: kelasList.map((kelas) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: KelasCard(
                                title: kelas['nama_kelas'],
                                idKelas: 'ID Kelas: ${kelas['id']}',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => AbsenPage(
                                        showBackButton: true,
                                        kelasId: kelas['id'],
                                        kelasNama: kelas['nama_kelas'],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                PengumumanSection(
                  title: "Pengumuman",
                  gambarList: listInfo,
                  onViewAll: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => InfoSiswaPage(showBackButton: true),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
