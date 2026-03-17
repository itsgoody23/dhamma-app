import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class NikayaBadge extends StatelessWidget {
  const NikayaBadge({super.key, required this.nikaya});

  final String nikaya;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.nikayaColor(nikaya);
    return Semantics(
      label: '${nikaya.toUpperCase()} nikaya',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(100),
          border:
              Border.all(color: color.withValues(alpha: 0.3), width: 0.5),
        ),
        child: Text(
          nikaya.toUpperCase(),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: color,
            letterSpacing: 0.6,
          ),
        ),
      ),
    );
  }
}
