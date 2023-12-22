import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:wacala/pages/wacalas.dart';
import 'package:http/http.dart' as http;
import 'package:wacala/token/accces_token-dart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wacala/utils/globals.dart';

bool isEmailValid(String email) {
  // Expresión regular para validar una dirección de correo electrónico
  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$',
  );

  // Verificar si la cadena cumple con la expresión regular
  return emailRegex.hasMatch(email);
}

class Login extends StatefulWidget {
  const Login({super.key});
  static const route = '/login';

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<AccessToken>? _futureToken;

  Future<AccessToken> validar(String user_name, String password) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, String>{"email": user_name, "password": password}),
    );
    if (response.statusCode == 200) {
      return AccessToken.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error.');
    }
  }

  FutureBuilder<AccessToken> buildFutureBuilder() {
    return FutureBuilder<AccessToken>(
      future: _futureToken,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Globals.token = snapshot.data!.accessToken;
          print("Token: ${Globals.token}");
          WidgetsBinding.instance.addPostFrameCallback((_) =>
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const Wacalas()),
                  (Route<dynamic> route) => false));

          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return seccionEnviar("Error en las Credenciales");
        }
        return const CircularProgressIndicator();
      },
    );
  }

  Widget seccionEnviar(String msg) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              setState(() {
                Future.delayed(Duration.zero, () {
                  _futureToken =
                      validar(loginController.text, passwordController.text);
                });
              });
            }
          },
          child: const Text('Ingresar'),
        ),
        Text(msg)
      ],
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(top: 150),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Wacala',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 50,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w900,
                      height: 0,
                    ),
                    maxLines: 1,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 40),
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.width * 0.5,
                    decoration: const ShapeDecoration(
                      color: Colors.white,
                      shape: OvalBorder(side: BorderSide(width: 1)),
                      shadows: [
                        BoxShadow(
                          color: Color(0x3F000000),
                          blurRadius: 4,
                          offset: Offset(0, 4),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    constraints:
                        const BoxConstraints(maxWidth: 300, maxHeight: 300),
                    child: Center(
                      child: Image.network(
                        ("https://media.tenor.com/wXLw0DG5HtIAAAAC/wacala.gif"),
                        width: MediaQuery.of(context).size.width * 0.4,
                      ),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 16),
                            child: TextFormField(
                              controller: loginController,
                              decoration: const InputDecoration(
                                  fillColor: Color.fromARGB(255, 255, 0, 0),
                                  iconColor: Color.fromARGB(255, 255, 0, 0),
                                  focusColor: Color.fromARGB(255, 255, 0, 0),
                                  hoverColor: Color.fromARGB(255, 255, 0, 0),
                                  border: OutlineInputBorder(),
                                  labelText: "email"),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Ingresa tu usuario';
                                }
                                if (!isEmailValid(value))
                                  return 'Ingresa un email valido';
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 16),
                            child: TextFormField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                  focusColor: Color.fromARGB(255, 255, 0, 0),
                                  border: OutlineInputBorder(),
                                  labelText: "Contraseña"),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Ingresa tu contraseña';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 16.0),
                            child: Center(
                                child: (_futureToken == null)
                                    ? seccionEnviar("")
                                    : buildFutureBuilder()),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
          ),
        ));
  }
}
