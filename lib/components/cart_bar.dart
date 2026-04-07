import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Bottom “Cart” strip: label, last-item thumbnail, count badge.
class CartBar extends StatelessWidget {
  const CartBar({
    super.key,
    required this.thumbnailAsset,
    this.itemCount = 0,
    this.onIncrement,
    this.onDecrement,
  });

  final String thumbnailAsset;
  final int itemCount;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Material(
        elevation: 0,
        color: const Color(0xFFF5F5F7),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          child: Row(
            children: [
              Text(
                'Cart',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              const Spacer(),
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white,
                backgroundImage: AssetImage(thumbnailAsset),
              ),
              const SizedBox(width: 8),
              if (onDecrement != null)
                IconButton.filled(
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFFE8E8EA),
                    foregroundColor: const Color(0xFF1A1A1A),
                  ),
                  onPressed: onDecrement,
                  icon: const Icon(Icons.remove, size: 20),
                ),
              const SizedBox(width: 6),
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Color(0xFF4CAF50),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '$itemCount',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              if (onIncrement != null) ...[
                const SizedBox(width: 6),
                IconButton.filled(
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: onIncrement,
                  icon: const Icon(Icons.add, size: 20),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
