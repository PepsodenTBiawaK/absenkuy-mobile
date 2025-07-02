import 'package:flutter/material.dart';

class InfoCardList extends StatelessWidget {
  final List<String> images;

  const InfoCardList({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          images
              .map(
                (imagePath) => Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 8,
                  ),
                  child: _InfoCard(imagePath: imagePath),
                ),
              )
              .toList(),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String imagePath;

  const _InfoCard({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder:
              (_) => Dialog(
                backgroundColor: Colors.transparent,
                insetPadding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Gambar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(imagePath, fit: BoxFit.cover),
                    ),
                    const SizedBox(height: 12),
                    // Tombol Close
                    Center(
                      child: IconButton(
                        icon: const Icon(
                          Icons.close_outlined,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ],
                ),
              ),
        );
      },
      child: Container(
        height: 120.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(50, 113, 153, 210),
              blurRadius: 12,
              offset: Offset(0, 1),
              spreadRadius: 2,
            ),
          ],
        ),
      ),
    );
  }
}
