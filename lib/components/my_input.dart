import 'package:flutter/material.dart';

class InputBox extends StatefulWidget {
  const InputBox(
      {super.key,
      required this.controller,
      required this.hint,
      required this.obscure});
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  @override
  State<InputBox> createState() => _InputBoxState();
}

class _InputBoxState extends State<InputBox> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        obscureText: widget.obscure,
        controller: widget.controller,
        cursorColor: Colors.grey.shade700,
        style: TextStyle(fontSize: 12),
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: TextStyle(fontSize: 12),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade700),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
