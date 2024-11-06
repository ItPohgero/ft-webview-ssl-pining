import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final FormFieldValidator<String>? validator; // Add validator parameter

  const CustomTextField({
    Key? key,
    required this.controller,
    this.validator, // Accept the validator
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxHeight: 300, // Set maximum height to 300px
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), // Rounded corners
      ),
      child: CustomPaint(
        painter: DashedBorderPainter(), // Custom dashed border painter
        child: SingleChildScrollView( // Wrap with SingleChildScrollView for scrolling
          child: TextFormField(
            controller: controller,
            validator: validator, // Set the validator
            maxLines: null, // Allows the TextFormField to expand
            decoration: const InputDecoration(
              labelText: 'Input valid url',
              border: InputBorder.none, // Remove default border
              contentPadding: EdgeInsets.all(12), // Padding for the text
            ),
          ),
        ),
      ),
    );
  }
}

// Custom painter for dashed border
class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black12
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2; // Border thickness

    double dashWidth = 5;
    double dashSpace = 5;
    double startX = 0;

    // Draw the top border
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }

    startX = 0;

    // Draw the bottom border
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, size.height), Offset(startX + dashWidth, size.height), paint);
      startX += dashWidth + dashSpace;
    }

    // Draw the left border
    startX = 0;
    double endY = size.height;
    for (double y = 0; y < endY; y += dashWidth + dashSpace) {
      canvas.drawLine(Offset(0, y), Offset(0, y + dashWidth), paint);
    }

    // Draw the right border
    startX = size.width;
    for (double y = 0; y < endY; y += dashWidth + dashSpace) {
      canvas.drawLine(Offset(size.width, y), Offset(size.width, y + dashWidth), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
