import 'package:absenkuy_app/utils/color.dart';
import 'package:flutter/material.dart';

class Profil extends StatefulWidget {
  final String nama;
  final VoidCallback? onTap;

  const Profil({super.key, required this.nama, this.onTap});
  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.centerRight,
          children: [
            Positioned(
              right: 27,
              child: Container(
                padding: const EdgeInsets.only(
                  left: 12,
                  right: 27,
                  top: 8,
                  bottom: 8,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Warna.primary50,
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(25, 113, 153, 210),
                      blurRadius: 10,
                      offset: const Offset(0, 1),
                      spreadRadius: 2,
                      blurStyle: BlurStyle.normal,
                    ),
                  ],
                ),
                child: Text(
                  widget.nama,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            // IconButton
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Warna.primary50,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Warna.primary400),
              ),
              child: Icon(Icons.person_rounded, size: 22),
            ),
          ],
        ),
      ),
    );
  }
}
