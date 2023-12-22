import 'dart:ffi';

import 'package:flutter/material.dart';
import 'dart:convert';

class ImageWacala extends StatelessWidget {
  const ImageWacala({super.key});
  static const route = '/imageWacala';

  @override
  Widget build(BuildContext context) {
    final String img = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 80,
            ),
            const Text("Detalle Foto Wacala",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),

            // Formuluario de Sector
            SizedBox(
              height: 20,
            ),

            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.5, // Ancho deseado
              // Altura deseada
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: MemoryImage(base64Decode(img)),
                ),
              ),
            ),
            Expanded(
              child: SizedBox(),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Colors.black)),
                  ),
                  child: Text("Salir")),
            ),
            SizedBox(height: 20)
          ],
        ),
      ),
    );
  }
}
