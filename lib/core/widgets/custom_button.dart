import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  
  
  final Color? color;        
  final Color? textColor;    
  final double? width;      
  final double? height;      

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,             
    this.textColor,          
    this.width,              
    this.height,            
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
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
           
            color: textColor ?? Colors.white, 
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}