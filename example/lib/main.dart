import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:kimko_auth/kimko_auth.dart';
import 'package:kimko_auth/services/kimiko_exeception.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await KimkoAuth.initialize(orgId: 'organizationID');

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  KimkoAuth kimkoAuth = KimkoAuth();

  Future<void> signIn() async {
    try {
      var res = await kimkoAuth.signIn(
          emailController.text.trim(), passwordController.text.trim());
      print(res.error);
      print(res.statusCode);
    } on KimikoException catch (e) {
      print('Kimiko ${e.error}');
    } catch (e) {
      print("Another error $e");
    }
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    hintText: "Email Address",
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: "Password",
                  ),
                  keyboardType: TextInputType.visiblePassword,
                ),
                MaterialButton(
                  onPressed: signIn,
                  child: const Text("Submit"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
