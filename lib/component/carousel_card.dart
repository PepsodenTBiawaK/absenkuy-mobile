import 'package:absenkuy_app/utils/color.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselCard extends StatefulWidget {
  final List<String> gambarList;

  const CarouselCard({super.key, required this.gambarList});
  @override
  State<CarouselCard> createState() => _CarouselCardState();
}

class _CarouselCardState extends State<CarouselCard> {
  int _current = 0; // untuk carousel slider

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 200.0,
            autoPlay: true,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
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

        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
              widget.gambarList.asMap().entries.map((entry) {
                return Container(
                  width: _current == entry.key ? 24.0 : 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color:
                        _current == entry.key
                            ? Warna.primary600
                            : Warna.secondary600,
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }
}
