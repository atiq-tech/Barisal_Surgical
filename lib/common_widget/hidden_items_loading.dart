import 'package:flutter/material.dart';

class HiddenItemsLoading extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  const HiddenItemsLoading({
    Key? key,
    required this.controller,
    required this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 0.0,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        showCursor: false,
        readOnly: false,
        decoration: const InputDecoration(
          filled: true,
          hintText: "",
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
      ),
    );
  }
}
