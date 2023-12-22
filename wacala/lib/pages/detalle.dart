import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wacala/object/report.dart';
import 'package:wacala/pages/widget.dart';
import 'package:wacala/utils/globals.dart';

class detalles extends StatefulWidget {
  String id;
  static const route = '/detalles';
  detalles(this.id);

  @override
  State<detalles> createState() => _detallesState();
}

class _detallesState extends State<detalles> {
  late dynamic args;
  late Future<void> _initLoad;
  late int still;
  late int nostill;
  Image imagenFromBase64(String s) {
    return Image.memory(base64Decode(s));
  }

  Future<void> getReport() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/report/${widget.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': Globals.token,
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        args = json.decode(response.body);
        args = Report.fromJson(args);
        still = args.still;
        nostill = args.notStill;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> vote(bool option, String id) async {
    try {
      if (option) {
        final response = await http.put(
          Uri.parse('http://10.0.2.2:3000/api/report/vote/still'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': Globals.token,
          },
          body: jsonEncode(<String, String>{
            'id': id,
          }),
        );
      } else {
        final response = await http.put(
            Uri.parse('http://10.0.2.2:3000/api/report/vote/nostill'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': Globals.token,
            },
            body: jsonEncode(<String, String>{
              'id': id,
            }));
      }
    } catch (e) {
      throw Exception('Error.');
    }
  }

  Widget comment(Comment x) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Color.fromRGBO(0, 0, 0, 2500),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Text(x.description,
                  style: TextStyle(fontSize: 15), softWrap: true),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [Text(x.autor.username)],
            )
          ],
        ),
      ),
    );

    /*  
      child: Column(
        children: [
          Text("Comentario"),
          Text("Autor"),
        ],
      ),
    );*/
  }

  @override
  void initState() {
    super.initState();
    _initLoad = getReport();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Center(
        child: FutureBuilder(
          future: _initLoad,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.waiting:
                return const Center(
                    child:
                        CircularProgressIndicator()); // O cualquier indicador de carga que desees mostrar mientras se obtienen los datos.
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  // Aquí construyes tu interfaz de usuario utilizando los datos en snapshot.data
                  return Container(
                    margin: EdgeInsets.only(left: 35.0, right: 35),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 80,
                        ),

                        Text(
                          args.sector,
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20, bottom: 20),
                          child: Text(
                            args.description,
                          ),
                        ),

                        // Fotos

                        // Boton de Personas
                        (args.images[0] != "" && args.images[1] != "")
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      args.images[0] == ""
                                          ? Container(
                                              width: 150,
                                              height: 150,
                                              color: Colors.black,
                                            )
                                          : GestureDetector(
                                              onTap: () {
                                                Navigator.pushNamed(
                                                    context, '/imageWacala',
                                                    arguments: args.images[0]);
                                              },
                                              child: Container(
                                                width: 150,
                                                height: 150,
                                                color: Colors.black,
                                                child: imagenFromBase64(
                                                    args.images[0]),
                                              ),
                                            ),
                                      buttonApp("Sigue ahí(${still})",
                                          () async {
                                        await vote(true, args.id);

                                        setState(() {
                                          still++;
                                        });
                                      }),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    children: [
                                      args.images[1] == ""
                                          ? Container(
                                              width: 150,
                                              height: 150,
                                              color: Colors.white,
                                            )
                                          : GestureDetector(
                                              onTap: () {
                                                Navigator.pushNamed(
                                                    context, '/imageWacala',
                                                    arguments: args.images[1]);
                                              },
                                              child: Container(
                                                width: 150,
                                                height: 150,
                                                color: Colors.black,
                                                child: imagenFromBase64(
                                                    args.images[1]),
                                              ),
                                            ),
                                      buttonApp("Ya no está(${nostill})",
                                          () async {
                                        await vote(false, args.id);
                                        setState(() {
                                          nostill++;
                                        });
                                      }),
                                    ],
                                  ),
                                ],
                              )
                            : args.images[0] != ""
                                ? Center(
                                    child: Column(
                                      children: [
                                        args.images[0] == ""
                                            ? GestureDetector(
                                                onTap: () {
                                                  Navigator.pushNamed(
                                                      context, '/imageWacala',
                                                      arguments:
                                                          args.images[0]);
                                                },
                                                child: Container(
                                                  width: 150,
                                                  height: 150,
                                                  color: Colors.black,
                                                ),
                                              )
                                            : GestureDetector(
                                                onTap: () {
                                                  Navigator.pushNamed(
                                                      context, '/imageWacala',
                                                      arguments:
                                                          args.images[0]);
                                                },
                                                child: Container(
                                                  width: 150,
                                                  height: 150,
                                                  color: Colors.black,
                                                  child: imagenFromBase64(
                                                      args.images[0]),
                                                ),
                                              ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            buttonApp("Sigue ahí(${still})",
                                                () async {
                                              await vote(true, args.id);
                                              setState(() {
                                                still++;
                                              });
                                            }),
                                            buttonApp("Ya no está(${nostill})",
                                                () async {
                                              await vote(false, args.id);
                                              setState(() {
                                                nostill++;
                                              });
                                            }),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                : Center(
                                    child: Column(
                                      children: [
                                        args.images[1] == ""
                                            ? Container(
                                                width: 150,
                                                height: 150,
                                                color: Colors.black,
                                              )
                                            : GestureDetector(
                                                onTap: () {
                                                  Navigator.pushNamed(
                                                      context, '/imageWacala',
                                                      arguments:
                                                          args.images[1]);
                                                },
                                                child: Container(
                                                  width: 150,
                                                  height: 150,
                                                  color: Colors.black,
                                                  child: imagenFromBase64(
                                                      args.images[1]),
                                                ),
                                              ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            buttonApp("Sigue ahí(${still})",
                                                () async {
                                              await vote(true, args.id);
                                              setState(() {
                                                still++;
                                              });
                                            }),
                                            buttonApp("Ya no está(${nostill})",
                                                () async {
                                              await vote(false, args.id);
                                              setState(() {
                                                nostill++;
                                              });
                                            }),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                        // Texto de autor
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              "Subido por: @${args.autor.username} - ${DateFormat('dd/MM/yyyy').format(args.date)}"),
                        ),

                        Row(
                          children: [
                            Expanded(
                              child: Text("Comentarios"),
                            ),
                            buttonApp("comentar", () {
                              Navigator.pushNamed(context, '/comment',
                                  arguments: args);
                            }),
                          ],
                        ),

                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: 300,
                          padding: EdgeInsets.all(10),
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: args.comment.length,
                            itemBuilder: (BuildContext context, int index) {
                              return comment(args.comment[index]);
                            },
                          ),
                        ),

                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[200],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: const BorderSide(color: Colors.black)),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/wacalas');
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.arrow_back_ios),
                                Text("VOLVER AL LISTADO"),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }
              default:
                return Text(
                    'Unhandled ConnectionState: ${snapshot.connectionState}');
            }
          },
        ),
      ),
    ));
  }
}
