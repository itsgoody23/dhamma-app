import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

enum ShareCardStyle { forest, dawn, ocean, lotus }

class SuttaShareCard extends StatelessWidget {
  const SuttaShareCard({
    super.key,
    required this.passage,
    required this.reference,
    this.style = ShareCardStyle.forest,
  });

  final String passage;
  final String reference;
  final ShareCardStyle style;

  @override
  Widget build(BuildContext context) {
    final colors = _styleColors(style);

    return Container(
      width: 600,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quote mark
          Text(
            '\u201C',
            style: TextStyle(
              fontSize: 60,
              fontWeight: FontWeight.w800,
              color: Colors.white.withValues(alpha: 0.3),
              height: 0.8,
            ),
          ),
          const SizedBox(height: 8),
          // Passage text
          Text(
            passage.length > 300 ? '${passage.substring(0, 297)}...' : passage,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              height: 1.6,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          // Divider
          Container(
            width: 40,
            height: 2,
            color: Colors.white.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 16),
          // Reference
          Text(
            reference,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.8),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          // Branding
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Icons.spa,
                size: 14,
                color: Colors.white.withValues(alpha: 0.5),
              ),
              const SizedBox(width: 6),
              Text(
                'Dhamma App',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.5),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Color> _styleColors(ShareCardStyle style) {
    return switch (style) {
      ShareCardStyle.forest => [
          AppColors.greenDark,
          const Color(0xFF2D5A3F),
        ],
      ShareCardStyle.dawn => [
          const Color(0xFFE8916D),
          const Color(0xFFC06C84),
        ],
      ShareCardStyle.ocean => [
          const Color(0xFF2B5876),
          const Color(0xFF4E4376),
        ],
      ShareCardStyle.lotus => [
          const Color(0xFF6B3FA0),
          const Color(0xFF9C4DCF),
        ],
    };
  }
}
