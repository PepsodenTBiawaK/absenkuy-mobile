import 'package:absenkuy_app/pages/guru/absen_guru_page.dart';
import 'package:absenkuy_app/pages/guru/home_guru_page.dart';
import 'package:absenkuy_app/pages/guru/riwayat_guru_page.dart';
import 'package:absenkuy_app/utils/color.dart';
// import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DashboardGuru extends StatefulWidget {
  const DashboardGuru({super.key});
  @override
  State<DashboardGuru> createState() => _DashboardGuruState();
}

class _DashboardGuruState extends State<DashboardGuru> {
  // List Gambar Carousel
  final List<String> gambarList = [
    'assets/carousel/carousel1.jpg',
    'assets/carousel/carousel2.jpg',
    'assets/carousel/carousel3.jpg',
    'assets/carousel/carousel4.jpg',
    'assets/carousel/carousel5.jpg',
  ];


  int _selectedIndex = 0;// untuk bottom navigation bar
  final List<Widget> _pages = [
    HomePageGuru(),
    AbsenPage(),
    RiwayatPage(),
    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna.primary50,
      // appBar: AppBar(
      //   title: const Text('Dashboard Guru'),
      // ),    
      body:_pages[_selectedIndex], // Menampilkan halaman sesuai index yang dipilih 
      // Bottom Navigation Bar
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          BottomAppBar(
            height: 90,
            elevation: 10,
            color: Colors.transparent,
    
            //Pembungkus Bottom Navigation
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(25, 113, 153, 210),
                    blurRadius: 12,
                    offset: const Offset(1, 1),
                    spreadRadius: 2,
                    blurStyle: BlurStyle.normal, // Normal blur style
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Tombol kiri
                  GestureDetector(
                    onTap: () {
                      // Implement action for the left button
                      // print("Absen tapped");
                      setState(() => _selectedIndex = 1);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color:
                            _selectedIndex == 1
                                ? Warna.primary200
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.checklist,
                            color:
                                _selectedIndex == 1
                                    ? Warna.primary600
                                    : Warna.black400,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Absen',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color:
                                  _selectedIndex == 1
                                      ? Warna.primary600
                                      : Warna.black400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
    
                  // Spacer tengah kosong (untuk icon tengah)
                  // const SizedBox(width: 48),
                  Spacer(),
    
                  // Tombol kanan
                  GestureDetector(
                    onTap: () {
                      // Implement action for the right button
                      // print("Riwayat tapped");
                      setState(() => _selectedIndex = 2);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color:
                            _selectedIndex == 2
                                ? Warna.primary200
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Riwayat',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color:
                                  _selectedIndex == 2
                                      ? Warna.primary600
                                      : Warna.black400,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.history,
                            color:
                                _selectedIndex == 2
                                    ? Warna.primary600
                                    : Warna.black400,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    
          // Icon tengah
          Positioned(
            bottom: 52,
            child: GestureDetector(
                    onTap: () {
                      // Implement action for the center icon
                      // print("Center icon tapped");
                      setState(() => _selectedIndex = 0);
                    },
              child: Container(
                clipBehavior: Clip.antiAlias,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _selectedIndex == 0 
                    ? Warna.primary200
                    : const Color.fromARGB(120, 234, 230, 225),
                    width: 7,
                  ),
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(17, 2, 82, 186),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/icon_launcher.png', // Ganti sesuai path logomu
                    height: 54,
                    width: 54,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
