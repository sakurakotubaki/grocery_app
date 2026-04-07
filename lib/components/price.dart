import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Price extends StatelessWidget {
  const Price({super.key, required this.amount});

  final String amount;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: '\$$amount',
        style: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: const Color(0xFF4CAF50),
        ),
        children: [
          TextSpan(
            text: '/kg',
            style: GoogleFonts.inter(
              color: const Color(0xFF9E9E9E),
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
