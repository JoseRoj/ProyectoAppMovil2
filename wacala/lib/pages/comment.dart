import 'package:flutter/material.dart';
import 'package:wacala/object/report.dart';
import 'package:wacala/pages/detalle.dart';
import 'package:wacala/pages/widget.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'package:wacala/utils/globals.dart';

class commentPage extends StatefulWidget {
  const commentPage({super.key});
  static const route = '/comment';

  @override
  State<commentPage> createState() => _commentPageState();
}

class _commentPageState extends State<commentPage> {
  TextEditingController _controllerDescription = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Future<void> addComment(String id) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/api/report/comment'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': Globals.token,
        },
        body: jsonEncode(<String, String>{
          'id': id,
          'description': _controllerDescription.text,
        }),
      );
      print("responde : ${response.body}");
    } catch (e) {
      throw Exception('Error.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Report args = ModalRoute.of(context)!.settings.arguments as Report;
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 80,
              ),
              Text(args.sector,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _controllerDescription,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Debe ingresar una descripción';
                      }
                      return null;
                    },
                    maxLines: 10,
                  ),
                ),
              ),
              buttonComun("Me arrepentí",
                  MediaQuery.of(context).size.width * 0.9, () {}),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Colors.black)),
                ),
                onPressed: () async {
                  await addComment(args.id);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => detalles(args.id)));
                },
                child: Text("Comentar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
