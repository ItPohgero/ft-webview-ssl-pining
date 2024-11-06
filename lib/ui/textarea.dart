import 'package:flutter/material.dart';

// CustomTextField with scrollable content when height exceeds 400
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;

  const CustomTextField({
    Key? key,
    required this.controller,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 100, // Set minimum height to 100px
      ),
      decoration: const BoxDecoration(
        color: Color(0XFFfdf4ff),
      ),
      child: CustomPaint(
        painter: DashedBorderPainter(), // Custom dashed border painter
        child: SingleChildScrollView( // Make content scrollable
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 400, // Fixed height of 400 for the field
            ),
            child: TextFormField(
              controller: controller,
              validator: validator,
              maxLines: null, // Allows the TextFormField to expand
              decoration: const InputDecoration(
                labelText: 'Input valid url',
                border: InputBorder.none, // Remove default border
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12), // Adjust padding for better positioning
                errorStyle: TextStyle(
                  fontSize: 12, // Adjust error text size
                  height: 1.2, // Move error message closer to the text field
                  color: Colors.red, // Set error text color
                ),
              ),
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
      ..strokeWidth = 1; // Border thickness

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
