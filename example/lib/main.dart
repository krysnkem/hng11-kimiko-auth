import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:kimko_auth/kimko_auth.dart';

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

  @override
  void initState() {
    super.initState();
  }

  signIn()async{
    try {
      var res = await KimkoAuth.signIn(emailController.text.trim(), passwordController.text.trim());
      print(res);
    } catch (e) {
      print(e);
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
                  decoration: InputDecoration(
                    hintText: "Email Address",
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                TextFormField(
                  controller: passwordController,
                  obscureText:  true,
                  decoration: InputDecoration(
                    hintText: "Password",
                  ),
                  keyboardType: TextInputType.visiblePassword,
                ),


                MaterialButton(
                  onPressed: signIn,
                  child: Text("Submit"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
