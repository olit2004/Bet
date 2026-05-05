import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  
  // New Customizable Parameters
  final Color? color;        // User can pick a solid color
  final Color? textColor;    // User can pick text color
  final double? width;       // User can pick width
  final double? height;      // User can pick height

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,              // Optional
    this.textColor,          // Optional
    this.width,              // Optional
    this.height,             // Optional
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity, // Use provided width or fill screen
      height: height,                  // Use provided height (usually 50-60)
      decoration: BoxDecoration(
        // If user provides a color, use it. Otherwise, use a default blue.
        color: color ?? const Color(0xFF5C59E8), 
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16.0),
        ),
        child: Text(
          text,
          style: GoogleFonts.manrope(
            // Use provided textColor or default to white
            color: textColor ?? Colors.white, 
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}