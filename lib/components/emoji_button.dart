import 'package:flutter/material.dart';

class EmoButton extends StatefulWidget {
  const EmoButton({super.key, required this.emoji, required this.onTap});
  final String emoji;
  final VoidCallback onTap;

  @override
  State<EmoButton> createState() => _EmoButtonState();
}

class _EmoButtonState extends State<EmoButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 65,
        height: 65,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
            child: Text(
          widget.emoji,
          style: TextStyle(fontSize: 32),
        )),
      ),
    );
  }
}
