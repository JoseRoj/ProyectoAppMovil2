import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:wacala/object/report.dart';
import 'package:wacala/pages/detalle.dart';
import 'package:wacala/utils/globals.dart';

class Wacalas extends StatefulWidget {
  static const route = '/wacalas';

  const Wacalas({Key? key}) : super(key: key);

  @override
  _WacalasState createState() => _WacalasState();
}

class _WacalasState extends State<Wacalas> {
  late Future<void> _initReport;
  late List<dynamic> reports;

  Future<void> getReport() async {
    try {
      print("pullRefresh");
      final response = await http.get(
        Uri.parse("http://10.0.2.2:3000/api/reports"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': Globals.token,
        },
      );
      print("statuscode: " + response.statusCode.toString());
      if (response.statusCode == 200) {
        reports = json.decode(response.body);
        // Actualizar el estado de la aplicacion al hacer pusllRefresh
        reports = reports.map((bit) => Report.fromJson(bit)).toList();

        /*setState(() {
          //reports = reports.reversed.toList();
        });*/
      }
    } catch (error) {
      // Manejo de errores de la solicitud
      throw Exception('Failed to load reports');
    }
  }

  @override
  void initState() {
    /*_initLoad = () async {
      await auth.loadToken();
      idUser = returnId(auth.token);
      await getStadistics();
    }();*/
    super.initState();
    _initReport = getReport();
  }

  Widget containerWacala(BuildContext context, dynamic item) {
    return Container(
        height: 80,
        margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(12.0), // Bordes redondeados
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 94, 94, 94)
                  .withOpacity(0.2), // Color de la sombra
              spreadRadius: 5,
              blurRadius: 5,
              offset: const Offset(0, 2), // Desplazamiento de la sombra
            ),
          ],
          color: Color.fromARGB(214, 255, 249, 249), // Color del contenedor
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.sector,
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                          overflow: TextOverflow.ellipsis),
                    ),
                    Text(
                      "Por @${item.autor.username} - ${DateFormat('dd/MM/yyyy').format(item.date)}",
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => detalles(item.id)))
                  },
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey[700],
                  ),
                )
              ],
            ),
          ],
        ));
  }

  Widget build(BuildContext context) {
    print("pase por el build");
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: RefreshIndicator(
        onRefresh: () async {
          await getReport();
          setState(() {});
        },
        child: ListView(
          children: [
            SizedBox(
              height: 10,
            ),
            Center(
              child: Container(
                child: Text(
                  "Lista de Wakalas",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            // Lista de Wacalas
            FutureBuilder(
              future: _initReport,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    return Column(
                      children: reports.map((item) {
                        return containerWacala(context, item);
                      }).toList(),
                    );
                  case ConnectionState.waiting:
                    return const Center(child: CircularProgressIndicator());
                  case ConnectionState.active:
                    return const Center(child: CircularProgressIndicator());
                  case ConnectionState.none:
                    return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/newWacala');
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}
