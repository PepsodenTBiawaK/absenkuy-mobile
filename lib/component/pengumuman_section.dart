import 'package:absenkuy_app/utils/color.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class PengumumanSection extends StatefulWidget {
  final String title;
  final List<String> gambarList;
  final VoidCallback? onViewAll;

  const PengumumanSection({
    super.key,
    required this.title,
    required this.gambarList,
    this.onViewAll,
  });

  @override
  State<PengumumanSection> createState() => _PengumumanSectionState();
}

class _PengumumanSectionState extends State<PengumumanSection> {
  // int _current = 0; // Untuk mengatur indeks gambar yang sedang ditampilkan
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 22,
                // vertical: 8,
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Warna.black600,
                ),
              ),
            ),
            Spacer(),
            if (widget.onViewAll != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  // vertical: 8,
                ),
                child: TextButton(
                  onPressed: widget.onViewAll,
                  child: Text(
                    "Lihat Semua",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Warna.primary600,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 22),
        CarouselSlider(
          options: CarouselOptions(
            height: 120.0,
            viewportFraction: 0.9,
            autoPlay: true,
            
          ),
          items:
              widget.gambarList
                  .map(
                    (item) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.asset(
                          item,
                          fit: BoxFit.cover,
                          width: 1000.0,
                        ),
                      ),
                    ),
                  )
                  .toList(),
        ),
      ],
    );
  }
}
