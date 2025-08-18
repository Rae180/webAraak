import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DarkModelLogo extends StatelessWidget {
  const DarkModelLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1D2671), Color(0xFF5C469C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Icon(Icons.photo_library, size: 48, color: Colors.white),
        ),
        const SizedBox(height: 16),
        Text('GALLERY MANAGER',
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: 3,
              color: Colors.white,
            )),
      ],
    );
  }
}
