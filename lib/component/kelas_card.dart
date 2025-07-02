import 'package:absenkuy_app/utils/color.dart';
import 'package:flutter/material.dart';

//enum KelasCard Mode
enum KelasCardMode { navigate, showForm, showDropdown }

class KelasCard extends StatelessWidget {
  final String title;
  final String idKelas;
  final bool showLogo;
  final bool showTrailing;
  final Widget? trailing;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final KelasCardMode mode;
  final Map<String, dynamic>? data;
  final VoidCallback? onShowForm;
  final List<Map<String, dynamic>>? dropdownItems;

  const KelasCard({
    super.key,
    required this.title,
    required this.idKelas,
    this.showLogo = true,
    this.showTrailing = true,
    this.trailing,
    this.backgroundColor,
    this.onTap,
    this.mode = KelasCardMode.navigate,
    this.data,
    this.onShowForm,
    this.dropdownItems,
  });

  Widget _defaultTrailing() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: const Icon(
        Icons.arrow_forward_ios_rounded,
        color: Warna.primary600,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        switch (mode) {
          // Mode Navigate / Pindah Halaman
          case KelasCardMode.navigate:
            if (onTap != null) {
              onTap!();
            }
            break;
          // Mode Show Form / Kirim Data ke Form
          case KelasCardMode.showForm:
            if (onShowForm != null) onShowForm!();
            break;
          // Mode Dropdown
          case KelasCardMode.showDropdown:
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              builder:
                  (_) => Container(
                    padding: const EdgeInsets.only(top: 12, bottom: 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Drag indicator
                        Container(
                          width: 40,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Title
                        const Text(
                          'Pilih Kelas',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Warna.primary600,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // List of items
                        Flexible(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: dropdownItems?.length ?? 0,
                            itemBuilder: (context, index) {
                              final item = dropdownItems![index];
                              return InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  if (item['onTap'] != null) {
                                    item['onTap']();
                                  }
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 6,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Warna.primary50,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Warna.primary200.withOpacity(
                                          0.1,
                                        ),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['title'] ?? '',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Warna.primary600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item['subtitle'] ?? '',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Warna.black400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
            );

            break;
        }
      },
      child: Container(
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
            color: Colors.white,
          ),
          child: Stack(
            children: [
              if (showLogo)
                Positioned(
                  top: 32,
                  left: -34,
                  child: Opacity(
                    opacity: 0.16,
                    child: Image.asset(
                      'assets/logo.png',
                      fit: BoxFit.cover,

                      width: 102,
                      // height: double.infinity,
                    ),
                  ),
                ),
              Row(
                children: [
                  Container(
                    width: 3,
                    height: 42,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Warna.primary600,
                    ),
                  ),
                  Spacer(),
                  Expanded(
                    flex: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Warna.primary600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          idKelas,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Warna.black400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),

                  if (showTrailing)
                    (trailing ?? _defaultTrailing())
                  else
                    const SizedBox.shrink(), // benar-benar kosong tanpa ruang
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
