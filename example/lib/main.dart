import 'package:flutter/material.dart';
import 'package:kimko_auth/kimko_auth.dart';
import 'package:kimko_auth_example/profile.dart';

KimkoAuth kimkoAuth = KimkoAuth();
ValueNotifier<Map<String, dynamic>> user = ValueNotifier<Map<String, dynamic>>({});
ValueNotifier<bool> isLoggedIn = ValueNotifier(false);


errorSnack(String text, {required BuildContext context}){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        text,
        style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700),
      ),
      backgroundColor: Colors.red,
    ),
  );
}


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await KimkoAuth.initialize(teamId: 'team-test');

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
    isUserLoggedIn();
    super.initState();
  }

  Future<void> isUserLoggedIn() async {
    try {
      var res = await kimkoAuth.isUserLoggedIn();
      setState(() {
        isLoggedIn.value = res;
      });
      print("IS USER LOGGED IN $res");
    } on KimikoException catch (e) {
      print('Kimiko ${e.error}');
    } catch (e) {
      print("Another error $e");
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: !isLoggedIn.value? const LoginScreen(): const ProfileScreen(),
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


  onChanged(String? val) {
    setState(() {
      formKey.currentState!.validate();
    });
  }

  bool _isLoading = false;

  startLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  stopLoading() {
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
          password: passwordController.text.trim());
      print(res.data);
      setState(() {
        isLoggedIn.value = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Login Successful",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
          backgroundColor: Colors.black,
        ),
      );
    } on KimikoException catch (e) {
      setState(() {
        isLoggedIn.value = false;
      });
      print('Kimiko ${e.error}');
      errorSnack(e.error.toString(), context: context);
    } catch (e) {
      print("Another error $e");
      setState(() {
        isLoggedIn.value = false;
      });
      errorSnack(e.toString(), context: context);
    }
    stopLoading();
  }

  Future<void> getUser() async {
    startLoading();
    try {
      var res = await kimkoAuth.getUser();
      print(res.data);
      if(res.data != null){
        setState(() {
          user.value = res.data;
        });
        Navigator.of(context).push(
            MaterialPageRoute(
                builder: (_)=> const ProfileScreen()
            )
        );
      }
    } on KimikoException catch (e) {
      debugPrint('Kimiko ${e.error}');
      errorSnack(e.error.toString(), context: context);
    } catch (e) {
      debugPrint("Another error $e");
      errorSnack(e.toString(), context: context);
    }
    stopLoading();
  }

  Future<void> getSavedUser() async {
    try {
      var res = await kimkoAuth.getLoggedInUser();
      if(res.data != null){
        setState(() {
          user.value = res.data;
        });
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_)=> const ProfileScreen()
          )
        );
      }
    } on KimikoException catch (e) {
      debugPrint('Kimiko ${e.error}');
      errorSnack(e.error.toString(), context: context);
    } catch (e) {
      debugPrint("Another error $e");
      errorSnack(e.toString(), context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Page"),
      ),
      body: Stack(
        children: [
          !isLoggedIn.value?
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
                              border: OutlineInputBorder()),
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [AutofillHints.email],
                          onChanged: onChanged,
                          validator: (v) {
                            if (v == null || v.isEmpty) {
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
                              border: OutlineInputBorder()),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return "Password cannot be empty";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.visiblePassword,
                        ),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)
                            )
                          ),
                          onPressed: () {
                            if (formKey.currentState?.validate() != true) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "All fields must be filled to proceed",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  backgroundColor: Colors.black,
                                ),
                              );
                            } else {
                              signIn(context);
                            }
                          },
                          child: const Text("Submit"),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (_) => const SignUpScreen()));
                    },
                    child: Text(
                      "Go to Sign up",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  )
                ],
              ),
            ),
          ):
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Column(
                  children: [
                    OutlinedButton(
                        onPressed: () async {
                          await getSavedUser();
                        },
                        child: const Text("Get Stored User")),
                    OutlinedButton(
                        onPressed: () async {
                          await getUser();
                        },
                        child: const Text("Get User")),
                  ],
                ),
              ],
            ),
          ),
          if (_isLoading) const LoaderScreen()
        ],
      ),
    );
  }
}

class UserDetails extends StatelessWidget {
  final String title;
  final String body;
  final Widget? child;
  const UserDetails({
    super.key, required this.title, required this.body, this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$title:"),
        child ?? Text(body, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),),
        SizedBox(height: 10,)
      ],
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
          lastName: lNameController.text.trim());
      print(res.data);
      print(res.statusCode);
      stopLoading();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()));
    } on KimikoException catch (e) {
      print('Kimiko ${e.error}');
      stopLoading();
    } catch (e) {
      print("Another error $e");
      stopLoading();
    }
  }

  bool _isLoading = false;

  startLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  stopLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  onChanged(String? val) {
    setState(() {
      formKey.currentState!.validate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up page'),
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
                              border: OutlineInputBorder()),
                          keyboardType: TextInputType.name,
                          autofillHints: const [
                            AutofillHints.givenName,
                            AutofillHints.name
                          ],
                          validator: (v) {
                            if (v == null || v.isEmpty) {
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
                              border: OutlineInputBorder()),
                          keyboardType: TextInputType.name,
                          autofillHints: const [
                            AutofillHints.familyName,
                            AutofillHints.name
                          ],
                          onChanged: onChanged,
                          validator: (v) {
                            if (v == null || v.isEmpty) {
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
                              border: OutlineInputBorder()),
                          keyboardType: TextInputType.name,
                          autofillHints: const [AutofillHints.username],
                          onChanged: onChanged,
                          validator: (v) {
                            if (v == null || v.isEmpty) {
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
                              border: OutlineInputBorder()),
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [AutofillHints.email],
                          onChanged: onChanged,
                          validator: (v) {
                            if (v == null || v.isEmpty) {
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
                              border: OutlineInputBorder()),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return "Password cannot be empty";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.visiblePassword,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)
                            )
                          ),
                          onPressed: () {
                            if (formKey.currentState?.validate() != true) {
                              errorSnack(
                                "All fields must be filled to proceed",
                                context: context
                              );
                            } else {
                              signUp();
                            }
                          },
                          child: const Text("Submit"),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (_) => const LoginScreen()));
                    },
                    child: Text(
                      "Go to Login",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  )
                ],
              ),
            ),
          ),
          if (_isLoading) const LoaderScreen()
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
