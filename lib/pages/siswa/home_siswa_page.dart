import 'dart:convert';
import 'package:absenkuy_app/component/carousel_card.dart';
import 'package:absenkuy_app/component/header_section.dart';
import 'package:absenkuy_app/component/pengumuman_section.dart';
import 'package:absenkuy_app/component/profil_section.dart';
import 'package:absenkuy_app/component/rekap_card.dart';
import 'package:absenkuy_app/data/api.dart';
import 'package:absenkuy_app/pages/logout_page.dart';
import 'package:absenkuy_app/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomePageSiswa extends StatefulWidget {
  const HomePageSiswa({super.key});

  @override
  State<HomePageSiswa> createState() => _HomePageSiswaState();
}

class _HomePageSiswaState extends State<HomePageSiswa> {
  final List<String> listGambar = [
    'assets/carousel/carousel1.jpg',
    'assets/carousel/carousel2.jpg',
    'assets/carousel/carousel3.jpg',
    'assets/carousel/carousel4.jpg',
    'assets/carousel/carousel5.jpg',
  ];

  bool isLoading = true;
  Map<String, int> rekap = {'hadir': 0, 'sakit': 0, 'izin': 0, 'alpa': 0};
  String userName = 'Siswa';

  @override
  void initState() {
    super.initState();
    fetchRekapAbsensi();
  }

  Future<void> fetchRekapAbsensi() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final name = prefs.getString('name') ?? 'Siswa';
    userName = name;

    if (token == null) return;

    final response = await http.get(
      Uri.parse(Api.laporanSiswa),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List absensi = data['absensi'];

      final Map<String, int> tempRekap = {
        'hadir': 0,
        'sakit': 0,
        'izin': 0,
        'alpa': 0,
      };

      for (var absen in absensi) {
        final status = absen['status'];
        if (tempRekap.containsKey(status)) {
          tempRekap[status] = tempRekap[status]! + 1;
        }
      }

      if (!mounted) return;
      setState(() {
        rekap = tempRekap;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
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
            child: Column(
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 8,
                      ),
                      child: const Text(
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
          
                // Carousel
                CarouselCard(gambarList: listGambar),
                const SizedBox(height: 32),
          
                // Rekap
                Skeletonizer(
                  enabled: isLoading,
                  child: Column(
                    children: [
                      Skeleton.keep(child: Header(title: "Rekap Absensi")),
                      const SizedBox(height: 22),
                      
                        RekapCard(title: "Hadir", number: "${rekap['hadir']}"),
                        const SizedBox(height: 12),
                        RekapCard(
                          title: "Sakit",
                          number: "${rekap['sakit']}",
                          bgColor: Warna.primary200,
                          color: Warna.primary600,
                        ),
                        const SizedBox(height: 12),
                        RekapCard(
                          title: "Izin",
                          number: "${rekap['izin']}",
                          bgColor: Warna.warning200,
                          color: Warna.warning600,
                        ),
                        const SizedBox(height: 12),
                        RekapCard(
                          title: "Alpa",
                          number: "${rekap['alpa']}",
                          bgColor: Warna.error200,
                          color: Warna.error600,
                        ),
                      ]
                    ,
                  ),
                ),
                const SizedBox(height: 32),
          
                // Pengumuman
                PengumumanSection(
                  title: "Pengumuman",
                  gambarList: listGambar,
                ),

                const SizedBox(height: 32,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
