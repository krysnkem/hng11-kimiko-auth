import 'package:flutter/material.dart';

import 'main.dart';

class ForgetPasswordScreen extends StatefulWidget {
  final String? email;
  const ForgetPasswordScreen({super.key, this.email});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {

  TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

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
  void initState() {
    emailController = TextEditingController(text: widget.email);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password"),
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
                              // signIn(context);
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
          ),
          if (_isLoading) const LoaderScreen()
        ],
      ),
    );
  }
}
