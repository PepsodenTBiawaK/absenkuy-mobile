import 'package:absenkuy_app/component/radio_btn.dart';
import 'package:absenkuy_app/utils/color.dart';
import 'package:flutter/material.dart';

class SiswaCard extends StatefulWidget {
  final String name;
  final String selectedValue;
  final ValueChanged<String> onChanged;

  const SiswaCard({
    super.key,
    required this.name,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  State<SiswaCard> createState() => _SiswaCardState();
}

class _SiswaCardState extends State<SiswaCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Warna.primary600,
              ),
            ),
            RadioBtn(
              selectedValue: widget.selectedValue,
              onChanged: widget.onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
