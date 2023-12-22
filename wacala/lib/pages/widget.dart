import 'package:flutter/material.dart';

Widget buttonApp(String text, Function() onPressed) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.grey[200],
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.black)),
    ),
    onPressed: () async {
      await onPressed();
    },
    child: Text(text),
  );
}

Widget buttonComun(String label, double width, Function() onPressed) {
  return Container(
    width: width,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[200],
        // Establecer el fondo del botón como transparente
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: () {
        onPressed();
      },
      child: Text(label),
    ),
  );
}
