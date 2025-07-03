import 'dart:convert';
import 'package:absenkuy_app/component/kelas_card.dart';
import 'package:absenkuy_app/data/api.dart';
import 'package:absenkuy_app/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:timelines_plus/timelines_plus.dart';
import 'package:intl/intl.dart';

class RiwayatSiswaPage extends StatefulWidget {
  const RiwayatSiswaPage({super.key});

  @override
  State<RiwayatSiswaPage> createState() => _RiwayatSiswaPageState();
}

class _RiwayatSiswaPageState extends State<RiwayatSiswaPage> {
  List<dynamic> absenList = [];
  String namaSiswa = '';
  String kelasSiswa = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAbsensiSaya();
  }

  Future<void> fetchAbsensiSaya() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final nama = prefs.getString('name') ?? 'Siswa';

    if (token == null) return;

    final response = await http.get(
      Uri.parse('${Api.baseUrl}/laporan/saya'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> absensi = data['absensi'];

      if (absensi.isNotEmpty) {
        if (!mounted) return;
        setState(() {
          absenList = absensi;
          namaSiswa = nama;
          kelasSiswa = absensi.first['kelas']['nama_kelas'];
          isLoading = false;
        });
      } else {
        setState(() {
          namaSiswa = nama;
          isLoading = false;
        });
      }
    } else {
      setState(() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna.primary50,
      appBar: AppBar(
        backgroundColor: Warna.primary50,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "Riwayat Siswa",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body:
          SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Skeletonizer(
                  enabled: isLoading,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Kartu info siswa
                      Skeleton.leaf(
                        child: KelasCard(
                          title: namaSiswa,
                          idKelas:
                              kelasSiswa.isNotEmpty
                                  ? kelasSiswa
                                  : 'Belum ada kelas',
                          showTrailing: false,
                        ),
                      ),
                      const SizedBox(height: 32),
                  
                      // Timeline
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                        child:
                            absenList.isEmpty
                                ? const Center(
                                  child: Text("Belum ada riwayat absensi."),
                                )
                                : FixedTimeline.tileBuilder(
                                  builder: TimelineTileBuilder.connectedFromStyle(
                                    contentsAlign: ContentsAlign.alternating,
                                    itemCount: absenList.length,
                      
                                    contentsBuilder: (context, index) {
                                      final item = absenList[index];
                                      final status = item['status'];
                                      final color = getStatusColor(status);
                                      final kelas = item['kelas']['nama_kelas'];
                                      final tanggal = item['tanggal'];
                                      final time = DateFormat.Hm().format(
                                        DateTime.parse(item['createdAt']),
                                      );
                      
                                      return Card(
                                        color: Colors.transparent,
                                        elevation: 0,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                index % 2 == 0
                                                    ? CrossAxisAlignment.start
                                                    : CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                '${status[0].toUpperCase()}${status.substring(1).toLowerCase()}', //artinya index 0 atau huruf pertama besar, selanjutnya akan kecil bwang
                                                style: TextStyle(
                                                  color: color,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(kelas),
                                              const SizedBox(height: 4),
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Icon(
                                                    Icons.access_time,
                                                    size: 16,
                                                    color: Colors.grey,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Flexible(
                                                    child: Text(
                                                      '$time - ${DateFormat('dd MMMM yyyy').format(DateTime.parse(tanggal))}',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                      
                                    connectorStyleBuilder:
                                        (_, __) => ConnectorStyle.solidLine,
                                    indicatorStyleBuilder:
                                        (_, __) => IndicatorStyle.outlined,
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
