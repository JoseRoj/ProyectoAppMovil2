import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
//import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wacala/utils/globals.dart';
import 'package:http/http.dart' as http;

enum MediaType {
  image,
  video;
}

class newWacala extends StatefulWidget {
  const newWacala({super.key});
  static const route = '/newWacala';

  @override
  State<newWacala> createState() => _newWacalaState();
}

class _newWacalaState extends State<newWacala> {
  TextEditingController _controllerSector = TextEditingController();
  TextEditingController _controllerDescription = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  File? image;

  String? imagePath1, imagePath2;

  final picker = ImagePicker();

  Future<void> pickMedia(ImageSource source, int Image) async {
    XFile? file;
    file = await ImagePicker().pickImage(source: source);
    if (file != null) {
      if (Image == 1) {
        imagePath1 = file.path;
      } else {
        imagePath2 = file.path;
      }
    }
  }

  String imageToBase64(String imagePath) {
    File imageFile = File(imagePath);

    if (!imageFile.existsSync()) {
      print('La imagen no existe en la ruta proporcionada.');
      return "";
    }

    List<int> imageBytes = imageFile.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);

    return base64Image;
  }

  Future<String> toBase64C(String ruta) async {
    if (ruta.isNotEmpty) {
      ImageProperties properties =
          await FlutterNativeImage.getImageProperties(ruta);
      File compressedFile = await FlutterNativeImage.compressImage(ruta,
          quality: 65,
          targetWidth: 400,
          targetHeight: (properties.height! * 400 / properties.width!).round());
      final bytes = await compressedFile.readAsBytes();
      String img64 = base64Encode(bytes);
      return img64;
    } else {
      return "";
    }
  }

  Future<void> insertar() async {
    String img1_64 = "";
    String img2_64 = "";

    if (imagePath1 != null) {
      img1_64 = await toBase64C(imagePath1!);
    }
    print("img1_64: " + img1_64);
    if (imagePath2 != null) {
      img2_64 = await toBase64C(imagePath2!);
    }
    try {
      print("token: " + Globals.token);
      final response = await http.post(
        Uri.parse("http://10.0.2.2:3000/api/report"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': '${Globals.token}',
        },
        body: jsonEncode(<String, dynamic>{
          'sector': _controllerSector.text,
          'description': _controllerDescription.text,
          "images": [img1_64, img2_64]
        }),
      );
      if (response.statusCode == 200) {
        print("Reporte creado");
      } else {
        print("Error al crear reporte");
      }
    } catch (error) {
      throw (error);
    }
  }

  @override
  void initState() {
    super.initState();
    //print("Tokeeeeeen es: " + authProvider.token.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(
                height: 80,
              ),
              const Text("Avisar por nuevo Wacala",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),

              // Formuluario de Sector
              SizedBox(
                height: 20,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _controllerSector,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        fillColor: Colors.white,
                        filled: true,
                        labelText: 'Sector',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingresa un sector';
                        }
                        return null;
                      },
                      maxLines: 1,
                    ),

                    SizedBox(
                      height: 20,
                    ),
                    // Formuluario de Descripcion
                    // Formuluario de Sector
                    // Formuluario de Descripcion
                    TextFormField(
                      controller: _controllerDescription,
                      decoration: const InputDecoration(
                        labelText: 'Descripción',
                        border: OutlineInputBorder(),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      validator: (value) {
                        if (value!.length < 15) {
                          return 'Please enter at least 15';
                        }
                        return null;
                      },
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              imagePath1 == null
                  ? const Text("")
                  : Image.file(
                      File(imagePath1!),
                      width: 200, // Ajusta el ancho según tus necesidades
                      height: 200, // Ajusta la altura según tus necesidades
                      fit: BoxFit
                          .cover, // Puedes ajustar la propiedad de ajuste según tus necesidades
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(color: Colors.black)),
                      ),
                      onPressed: () async {
                        await pickMedia(ImageSource.camera, 1);
                        setState(() {});
                      },
                      child: const Text('Foto 1'),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(color: Colors.black)),
                      ),
                      onPressed: () {
                        setState(() {
                          imagePath1 = null;
                        });
                        //Navigator.pop(context);
                      },
                      child: const Text('Borrar'),
                    ),
                  ),
                ],
              ),
              imagePath2 == null
                  ? const Text("")
                  : Image.file(
                      File(imagePath2!),
                      width: 200, // Ajusta el ancho según tus necesidades
                      height: 200, // Ajusta la altura según tus necesidades
                      fit: BoxFit
                          .cover, // Puedes ajustar la propiedad de ajuste según tus necesidades
                    ),

              /*Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    imagePath1 == null
                        ? const Text("")
                        : Image.file(
                            File(imagePath1!),
                            width: 100, // Ajusta el ancho según tus necesidades
                            height: 100, // Ajusta la altura según tus necesidades
                            fit: BoxFit
                                .cover, // Puedes ajustar la propiedad de ajuste según tus necesidades
                          ),
                    SizedBox(
                      width: 20,
                    ),
                    imagePath2 == null
                        ? const Text("")
                        : Image.file(
                            File(imagePath2!),
                            width: 100, // Ajusta el ancho según tus necesidades
                            height: 100, // Ajusta la altura según tus necesidades
                            fit: BoxFit
                                .cover, // Puedes ajustar la propiedad de ajuste según tus necesidades
                          ),
                  ],
                ),*/
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(color: Colors.black)),
                      ),
                      onPressed: () async {
                        await pickMedia(ImageSource.camera, 2);

                        setState(() {});
                      },
                      child: const Text('Foto 2'),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(color: Colors.black)),
                      ),
                      onPressed: () {
                        setState(() {
                          imagePath2 = null;
                        });
                      },
                      child: const Text('Borrar'),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    // Establecer el fondo del botón como transparente
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (imagePath1 != null || imagePath2 != null) {
                        await insertar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Reporte creado'),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Debe subir al menos una imagen'),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text('Denunciar Wakala'),
                ),
              ),

              SizedBox(height: 30),

              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    // Establecer el fondo del botón como transparente
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Me arrepentí'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
