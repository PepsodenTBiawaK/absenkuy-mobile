import 'package:absenkuy_app/utils/color.dart';
import 'package:flutter/widgets.dart';

class RadioBtn extends StatelessWidget {
  final String selectedValue;
  final ValueChanged<String> onChanged;

  const RadioBtn({
    super.key,
    required this.selectedValue,
    required this.onChanged,
  });

  final Map<String, Color> activatedColor = const {
    'H': Warna.succes600,
    'S': Warna.primary600,
    'I': Warna.warning600,
    'A': Warna.error500,
  };

  final Map<String, Color> activatedBackground = const {
    'H': Warna.succes300,
    'S': Warna.primary300,
    'I': Warna.warning200,
    'A': Warna.error200,
  };

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildRadioItem('H'),
        _buildRadioItem('S'),
        _buildRadioItem('I'),
        _buildRadioItem('A'),
      ],
    );
  }

  Widget _buildRadioItem(String value) {
    final isSelected = selectedValue == value;
    final color = isSelected ? activatedColor[value]! : Warna.black600;
    final backgroundColor =
        isSelected ? activatedBackground[value]! : Warna.gray100;

    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        alignment: Alignment.center,
        width: 34,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
        ),
        child: Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }
}
