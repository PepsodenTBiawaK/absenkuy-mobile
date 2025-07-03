import 'dart:convert';
import 'package:absenkuy_app/component/header_section.dart';
import 'package:absenkuy_app/component/kelas_card.dart';
import 'package:absenkuy_app/data/api.dart';
import 'package:absenkuy_app/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  List<Map<String, dynamic>> kelasList = [];
  List<Map<String, dynamic>> riwayatList = [];
  int? selectedKelasId;
  String? selectedKelasNama;
  bool isLoading = false;
  bool isKelasLoading = true;

  @override
  void initState() {
    super.initState();
    fetchKelasGuru();
  }

  Future<void> fetchKelasGuru() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) return;

    final response = await http.get(
      Uri.parse(Api.kelasGuru),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      if (!mounted) return;
      setState(() {
        kelasList = data.cast<Map<String, dynamic>>();
        isKelasLoading = false;
      });
    } else {
      setState(() {
        isKelasLoading = false;
      });
    }
  }

  Future<void> fetchRiwayat(int kelasId, String kelasNama) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) return;

    if (!mounted) return;
    setState(() {
      selectedKelasId = kelasId;
      selectedKelasNama = kelasNama;
      isLoading = true;
    });

    final response = await http.get(
      Uri.parse(Api.riwayatByKelas(kelasId)),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> result = jsonDecode(response.body);
      if (!mounted) return;
      setState(() {
        riwayatList = List<Map<String, dynamic>>.from(result['absensi']);
        isLoading = false;
      });
    } else {
      setState(() {
        riwayatList = [];
        isLoading = false;
      });
    }
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'hadir':
        return Warna.succes600;
      case 'izin':
        return Warna.warning600;
      case 'sakit':
        return Warna.primary600;
      case 'alpa':
      default:
        return Warna.error600;
    }
  }

  Color getStatusBackground(String status) {
    switch (status.toLowerCase()) {
      case 'hadir':
        return Warna.succes200;
      case 'izin':
        return Warna.warning200;
      case 'sakit':
        return Warna.primary200;
      case 'alpa':
      default:
        return Warna.error200;
    }
  }

  Future<void> _refreshData() async {
    await fetchKelasGuru();
    if (selectedKelasId != null && selectedKelasNama != null) {
      await fetchRiwayat(selectedKelasId!, selectedKelasNama!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna.primary50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Warna.primary50,
        automaticallyImplyLeading: false,
        title: const Text(
          'Riwayat Siswa',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Skeletonizer(
          enabled: isLoading || isKelasLoading,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
                  Skeleton.leaf(
                    child: KelasCard(
                      title: selectedKelasNama ?? "Pilih Kelas",
                      idKelas: selectedKelasId != null
                          ? "ID Kelas : $selectedKelasId"
                          : "",
                      mode: KelasCardMode.showDropdown,
                      dropdownItems: isKelasLoading
                          ? []
                          : kelasList.map((kelas) {
                              return {
                                'title': kelas['nama_kelas'],
                                'subtitle': 'ID: ${kelas['id']}',
                                'onTap': () => fetchRiwayat(
                                      kelas['id'],
                                      kelas['nama_kelas'],
                                    ),
                              };
                            }).toList(),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Skeleton.keep(child: Header(title: "Nama Siswa")),
                  const SizedBox(height: 16),
                  if (isLoading)
                    Skeleton.leaf(
                      child: Column(
                        children: List.generate(5, (index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 22,
                              vertical: 6,
                            ),
                            child: Container(
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        }),
                      ),
                    )
                  else if (riwayatList.isEmpty)
                    Skeleton.keep(
                      child: const Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text('Belum ada data absensi'),
                      ),
                    )
                  else
                    ...riwayatList.map((data) {
                      final nama = data['siswa']['nama_siswa'];
                      final tanggal = data['tanggal'];
                      final status = data['status'];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 6,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 22,
                            vertical: 18,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.calendar_today,
                                        color: Warna.black400,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        DateFormat('dd MMMM yyyy')
                                            .format(DateTime.parse(tanggal)),
                                        style: const TextStyle(
                                          color: Warna.black400,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    nama,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Warna.primary600,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: getStatusBackground(status),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Text(
                                  status[0].toUpperCase() +
                                      status.substring(1).toLowerCase(),
                                  style: TextStyle(
                                    color: getStatusColor(status),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
