import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom header: greeting, user name, and profile avatar (not a standard [AppBar]).
class StoreAppBar extends StatelessWidget implements PreferredSizeWidget {
  const StoreAppBar({
    super.key,
    this.greeting = 'Good Morning!',
    this.userName = 'Caesar Rincon',
    this.avatarAsset,
  });

  final String greeting;
  final String userName;

  /// Optional local asset for the circular avatar (e.g. `assets/images/avatar.png`).
  final String? avatarAsset;

  static const double _height = 108;

  @override
  Size get preferredSize => const Size.fromHeight(_height);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SizedBox(
        height: _height,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      greeting,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF9E9E9E),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userName,
                      style: GoogleFonts.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A1A),
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              CircleAvatar(
                radius: 28,
                backgroundColor: const Color(0xFFE8E8E8),
                backgroundImage:
                    avatarAsset != null ? AssetImage(avatarAsset!) : null,
                child: avatarAsset == null
                    ? const Icon(Icons.person, color: Color(0xFF9E9E9E))
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
