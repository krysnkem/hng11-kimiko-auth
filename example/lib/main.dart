import 'package:flutter/material.dart';
import 'dart:async';

import 'package:kimko_auth/kimko_auth.dart';
import 'package:kimko_auth/services/kimiko_exeception.dart';

KimkoAuth kimkoAuth = KimkoAuth();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await KimkoAuth.initialize(orgId: 'angrybird-kimiko-f06');

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "KIMIKO AUTH",
      theme: ThemeData.light(useMaterial3: true).copyWith(
        primaryColor:  Color(0xFF6E2222),
        colorScheme:  const ColorScheme.light(
            primary:Color(0xFF6E2222),
            secondary: Color(0xFFF0EBEB),
            onPrimary: Color(0xFFCCBCBC),
            brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.white.withOpacity(0.99)
      ),
      home: const LoginScreen(),
    );
  }
}


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();

  onChanged(String? val){
    setState(() {
      formKey.currentState!.validate();
    });
  }

  bool _isLoading = false;

  startLoading (){
    setState(() {
      _isLoading = true;
    });
  }

  stopLoading (){
    setState(() {
      _isLoading = false;
    });
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> signIn(BuildContext context) async {
    startLoading();
    try {
      var res = await kimkoAuth.signIn(
          email: emailController.text.trim(),
          password: passwordController.text.trim()
      );
      print(res.data);
      print(res.statusCode);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login Successful", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),),
          backgroundColor: Colors.black,
        ),
      );
    } on KimikoException catch (e) {
      print('Kimiko ${e.error}');
    } catch (e) {
      print("Another error $e");
    }
    stopLoading();
  }

  Map<String, dynamic> user = {};

  Future<void> getCachedUser() async {
    try {
      var res = await kimkoAuth.getLoggedInUser();
      print(res.data);
      user = res.data;

    } on KimikoException catch (e) {
      print('Kimiko ${e.error}');
    } catch (e) {
      print("Another error $e");
    }
  }

  Future<void> getUser() async {
    startLoading();
    try {
      var res = await kimkoAuth.getUser();
      print(res.data);
    } on KimikoException catch (e) {
      print('Kimiko ${e.error}');
    } catch (e) {
      print("Another error $e");
    }
    stopLoading();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Stack(
        children: [
          Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        TextFormField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            labelText: "Email Address",
                            border: OutlineInputBorder()
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [AutofillHints.email],
                          onChanged: onChanged,
                          validator: (v){
                            if(v==null || v.isEmpty){
                              return "Email cannot be empty";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          onChanged: onChanged,
                          decoration: const InputDecoration(
                            labelText: "Password",
                            border: OutlineInputBorder()
                          ),
                          validator: (v){
                            if(v==null || v.isEmpty){
                              return "Password cannot be empty";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.visiblePassword,
                        ),
                        MaterialButton(
                          onPressed: (){
                            if(formKey.currentState?.validate()!=true){
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("All fields must be filled to proceed", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),),
                                  backgroundColor: Colors.black,
                                ),
                              );
                            }else{
                              signIn(context);
                            }
                          },
                          child: const Text("Submit"),
                        ),
                        const SizedBox(height: 16,),
                        ElevatedButton(
                            onPressed: getUser,
                            child: Text("Get User")
                        ),
                        const SizedBox(height: 16,),
                        OutlinedButton(
                            onPressed: getCachedUser,
                            child: Text("Get Stored User")
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=> const SignUpScreen()));
                    },
                    child: Text(
                      "Go to Sign up",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  )
                ],
              ),
            ),
          ),
          if(_isLoading)
            const LoaderScreen()
        ],
      ),
    );
  }
}


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future<void> signUp() async {
    startLoading();
    try {
      var res = await kimkoAuth.signup(
          username: userNameController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          firstName: fNameController.text.trim(),
          lastName: lNameController.text.trim()
      );
      print(res.data);
      print(res.statusCode);
      stopLoading();
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=> const LoginScreen()));
    } on KimikoException catch (e) {
      print('Kimiko ${e.error}');
      stopLoading();
    } catch (e) {
      print("Another error $e");
      stopLoading();
    }
  }

  bool _isLoading = false;

  startLoading (){
    setState(() {
      _isLoading = true;
    });
  }

  stopLoading (){
    setState(() {
      _isLoading = false;
    });
  }

  onChanged(String? val){
    setState(() {
      formKey.currentState!.validate();
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Stack(
        children: [
          Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        TextFormField(
                          controller: fNameController,
                          decoration: const InputDecoration(
                            labelText: "First Name",
                            border: OutlineInputBorder()
                          ),
                          keyboardType: TextInputType.name,
                          autofillHints: const [AutofillHints.givenName, AutofillHints.name],
                          validator: (v){
                            if(v==null || v.isEmpty){
                              return "First name cannot be empty";
                            }
                            return null;
                          },
                          onChanged: onChanged,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          controller: lNameController,
                          decoration: const InputDecoration(
                            labelText: "Last Name",
                            border: OutlineInputBorder()
                          ),
                          keyboardType: TextInputType.name,
                          autofillHints: const [AutofillHints.familyName, AutofillHints.name],
                          onChanged: onChanged,
                          validator: (v){
                            if(v==null || v.isEmpty){
                              return "Last name cannot be empty";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          controller: userNameController,
                          decoration: const InputDecoration(
                            labelText: "Username",
                            border: OutlineInputBorder()
                          ),
                          keyboardType: TextInputType.name,
                          autofillHints: const [AutofillHints.username],
                          onChanged: onChanged,
                          validator: (v){
                            if(v==null || v.isEmpty){
                              return "username cannot be empty";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            labelText: "Email Address",
                            border: OutlineInputBorder()
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [AutofillHints.email],
                          onChanged: onChanged,
                          validator: (v){
                            if(v==null || v.isEmpty){
                              return "Email cannot be empty";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          onChanged: onChanged,
                          decoration: const InputDecoration(
                            labelText: "Password",
                            border: OutlineInputBorder()
                          ),
                          validator: (v){
                            if(v==null || v.isEmpty){
                              return "Password cannot be empty";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.visiblePassword,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        ElevatedButton(
                          onPressed: (){
                            if(formKey.currentState?.validate()!=true){
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("All fields must be filled to proceed", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),),
                                  backgroundColor: Colors.black54,
                                ),
                              );
                            }else{
                              signUp();
                            }
                          },
                          child: const Text("Submit"),
                        ),
                        const SizedBox(height: 16,),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=> const LoginScreen()));
                    },
                    child: Text(
                      "Go to Login",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  )
                ],
              ),
            ),
          ),
          if(_isLoading)
            const LoaderScreen()
        ],
      ),
    );
  }
}

class LoaderScreen extends StatelessWidget {
  const LoaderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.white.withOpacity(0.5),
      alignment: Alignment.center,
      child: const CircularProgressIndicator(),
    );
  }
}
