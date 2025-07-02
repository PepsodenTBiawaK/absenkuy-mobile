import 'package:absenkuy_app/utils/color.dart';
import 'package:flutter/material.dart';

class RekapCard extends StatefulWidget {
  final String title;
  final String number;
  final Color? bgColor;
  final Color? color;

  const RekapCard({
    super.key,
    required this.title,
    required this.number,
    this.bgColor,
    this.color,
  });
  @override
  State<RekapCard> createState() => _RekapCardState();
}

class _RekapCardState extends State<RekapCard> {
  @override
  Widget build(BuildContext context) {
    final Color bgColor = widget.bgColor ?? Warna.succes200;
    final Color color = widget.color ?? Warna.succes600;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 22,
        // vertical: 8,
      ),
      child: Container(
        clipBehavior: Clip.antiAlias,
        height: 78,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(25, 113, 153, 210),
              blurRadius: 12,
              offset: const Offset(0, 1),
              spreadRadius: 2,
              blurStyle: BlurStyle.normal,
            ),
          ],
          color: bgColor,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              children: [
                Container(
                  width: 3,
                  height: 42,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: color,
                  ),
                ),
                Spacer(),
                Expanded(
                  flex: 3,
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ),
                Spacer(),
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    // color: Warna.primary600,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.number,
                    style:  TextStyle(color: color),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
