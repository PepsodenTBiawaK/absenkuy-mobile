import 'package:absenkuy_app/component/info_card.dart';
import 'package:absenkuy_app/utils/color.dart';
import 'package:absenkuy_app/utils/list_gambar.dart';
import 'package:flutter/material.dart';

class InfoSiswaPage extends StatefulWidget {
  final bool showBackButton;
  const InfoSiswaPage({super.key,this.showBackButton=false});
  @override
  State<InfoSiswaPage> createState() => _InfoSiswaPage();
}

class _InfoSiswaPage extends State<InfoSiswaPage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warna.primary50,
      appBar: AppBar(
        backgroundColor: Warna.primary50,
        elevation: 0,
        automaticallyImplyLeading: widget.showBackButton,
        title: const Text(
          "Pengumuman",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(child: InfoCardList(images: listInfo,)),
    );
  }
}
