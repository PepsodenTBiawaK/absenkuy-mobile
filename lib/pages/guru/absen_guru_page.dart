import 'dart:convert';
import 'package:absenkuy_app/component/header_section.dart';
import 'package:absenkuy_app/component/kelas_card.dart';
import 'package:absenkuy_app/component/siswa_card.dart';
import 'package:absenkuy_app/data/api.dart';
import 'package:absenkuy_app/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AbsenPage extends StatefulWidget {
  final bool showBackButton;
  final int? kelasId;
  final String? kelasNama;

  const AbsenPage({
    super.key,
    this.showBackButton = false,
    this.kelasId,
    this.kelasNama,
  });

  @override
  State<AbsenPage> createState() => _AbsenPageState();
}

class _AbsenPageState extends State<AbsenPage> {
  List<Map<String, dynamic>> kelasList = [];
  int? selectedKelasId;
  String? selectedKelasNama;
  List<Map<String, dynamic>> siswaList = [];
  Map<int, String> statusMap = {};
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchKelasGuru();

    if (widget.kelasId != null && widget.kelasNama != null) {
      fetchSiswaByKelas(widget.kelasId!, widget.kelasNama!);
    }
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
      });
    }
  }

  Future<void> fetchSiswaByKelas(int kelasId, String kelasNama) async {
    if (!mounted) return;
    setState(() {
      selectedKelasId = kelasId;
      selectedKelasNama = kelasNama;
      siswaList = [];
      statusMap = {};
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) return;

    final response = await http.get(
      Uri.parse(Api.siswaByKelas(kelasId)),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      setState(() {
        siswaList = data.cast<Map<String, dynamic>>();
      });
    }
  }

  Future<void> submitAbsensi() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null || selectedKelasId == null) return;

    final tanggal = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final absensi =
        siswaList.map((siswa) {
          final status = statusMap[siswa['id']];
          return {
            'siswa_id': siswa['id'],
            'status': _convertStatus(status ?? 'A'),
          };
        }).toList();

    final body = jsonEncode({
      'kelas_id': selectedKelasId,
      'tanggal': tanggal,
      'absensi': absensi,
    });

    // print(
    //   jsonEncode({
    //     'kelas_id': selectedKelasId,
    //     'tanggal': tanggal,
    //     'absensi': absensi,
    //   }),
    // );

    setState(() => isLoading = true);

    final response = await http.post(
      Uri.parse(Api.absensi),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    setState(() => isLoading = false);

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Absensi berhasil dikirim')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengirim absensi: ${response.body}')),
      );
    }
  }

  String _convertStatus(String value) {
    switch (value) {
      case 'H':
        return 'hadir';
      case 'S':
        return 'sakit';
      case 'I':
        return 'izin';
      case 'A':
      default:
        return 'alpa';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna.primary50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Warna.primary50,
        automaticallyImplyLeading: widget.showBackButton,
        title: const Text(
          'Absensi Siswa',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 22),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Warna.primary50,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color.fromARGB(
                                        32,
                                        113,
                                        153,
                                        210,
                                      ),
                                      blurRadius: 10,
                                      offset: const Offset(0, 2),
                                      spreadRadius: 3,
                                      blurStyle: BlurStyle.normal,
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      color: Warna.black600,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      DateFormat(
                                        'dd MMMM yyyy',
                                      ).format(DateTime.now()),
                                      style: const TextStyle(
                                        color: Warna.black600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      KelasCard(
                        title: selectedKelasNama ?? 'Pilih Kelas',
                        idKelas:
                            selectedKelasId != null
                                ? 'ID Kelas: $selectedKelasId'
                                : '',
                        mode: KelasCardMode.showDropdown,
                        dropdownItems:
                            kelasList.map((kelas) {
                              return {
                                'title': kelas['nama_kelas'],
                                'subtitle': 'ID: ${kelas['id']}',
                                'onTap':
                                    () => fetchSiswaByKelas(
                                      kelas['id'],
                                      kelas['nama_kelas'],
                                    ),
                              };
                            }).toList(),
                      ),
                      const SizedBox(height: 32),
                      Header(title: "Nama Siswa"),
                      const SizedBox(height: 22),
                      ...siswaList.map(
                        (siswa) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: SiswaCard(
                            name: siswa['nama_siswa'],
                            selectedValue: statusMap[siswa['id']] ?? 'A',
                            onChanged: (status) {
                              setState(() {
                                statusMap[siswa['id']] = status;
                              });
                            },
                          ),
                        ),
                      ),

                      if (selectedKelasId != null && siswaList.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 22),
                          child: ElevatedButton(
                            onPressed: submitAbsensi,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Warna.primary600,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Submit',
                              style: TextStyle(color: Warna.black100),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
    );
  }
}
