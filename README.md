# kimko_auth

Authentication for HNG game App

## Getting Started


## Initialization

Before using the KimkoAuth library, you need to initialize it in your main application file (`main.dart`). This setup must be done before making any authentication requests.

```dart
import 'package:flutter/material.dart';
import 'package:kimko_auth/kimko_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize KimkoAuth with your organization ID
  await KimkoAuth.initialize(orgId: 'YOUR_ORG_ID');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('KimkoAuth Example')),
        body: Center(child: Text('Welcome to KimkoAuth!')),
      ),
    );
  }
}
```


Sign in functionality

```dart
import 'package:kimko_auth/kimko_auth.dart';

void signIn(String email, String password) async {
  try {
    KimikoResponse response = await KimkoAuth.signIn(email, password);
    if (response.isSuccess) {
      // Handle successful login
      print('User signed in successfully: ${response.data}');
    } else {
      // Handle login failure
      print('Login failed: ${response.message}');
    }
  } catch (e) {
    // Handle error
    print('Error: $e');
  }
}
```

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter development, view the
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

