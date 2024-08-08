# kimko_auth

### KimikoAuth Library for Flutter

## Overview

The Kimiko Auth Library for Flutter provides a robust solution for managing user authentication in your Flutter applications. It supports various operations like login, signup, logout, getting user details, updating profile details, updating profile images, and deactivating accounts.
Table of Contents
1. Installation
2. Usage
3. Public Methods
4. Example Code
5. Unique App IDs
## Installation
To use the Auth Library in your Flutter project, add it to your pubspec.yaml file:

yaml
dependencies:
kimko_auth: ^0.0.3
Run
dart flutter pub get 
to install the new dependency.


## Usage
After adding the Auth Library to your project, you can start using it by importing the package and initializing the KimkoAuth.
Initialize the Library


dart
import 'package:flutter/material.dart';
import 'package:kimko_auth/kimko_auth.dart';

KimkoAuth kimkoAuth = KimkoAuth();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await KimkoAuth.initialize(teamId: 'angrybird-kimiko-f06');

  runApp(const MyApp());
}


## Sign in functionality

dart
```bash
TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();

Future<void> signIn(BuildContext context) async {
  try {
    var res = await kimkoAuth.signIn(
        email: emailController.text.trim(),
        password: passwordController.text.trim());
  } on KimikoException catch (e) {
    print('Kimiko ${e.error}');
  } catch (e) {
    print("Another error $e");
  }
}
```

dart
```
class KimikoResponse {
  final  dynamic data;
  final String? error;
  final int? statusCode;

  KimikoResponse( {this.data, this.error, this.statusCode});

  bool get isSuccess => error == null;
}

dart
 class KimikoException implements Exception {
  final String? error;

  KimikoException({this.error});
}
```

## Public Methods

# signIn(email: email, password: password)

Logs in a user with the provided email and password.
# Parameters:
* email: The user's email address.
* password: The user's password.

# Returns:
A
dart Future<KimikoResponse>
containing the user response

# Example:
dart
```
 var res = await kimkoAuth.signIn(
    email: emailController.text.trim(),
    password: passwordController.text.trim()
  );
print(response);
```

# Get User

Logs in a user with the provided email and password.

# Returns:

dart 
```
Future<KimikoResponse>
containing the user response
```

# Example:
dart 
```
 var res = await kimkoAuth.getLoggedInUser();
print(response);
```

## Sign UP functionality

dart
```
TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController fNameController = TextEditingController();
TextEditingController lNameController = TextEditingController();
TextEditingController userNameController = TextEditingController();

Future<void> signUp() async {
  try {
    var res = await kimkoAuth.signup(
        username: userNameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        firstName: fNameController.text.trim(),
        lastName: lNameController.text.trim());
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()));
  } on KimikoException catch (e) {
    print('Kimiko ${e.error}');
  } catch (e) {
    print("Another error $e");
  }
}
```

## Public Methods
### .signup(username: username, email: email,  password: password, firstName: firstName, lastName: lastName,)

Logs in a user with the provided email and password.
### Parameters:
* email: The user's email address.
* password: The user's password.
* username: The user's username.
* firstname: The user's first name.
* lastName: The user's last name.

### Returns:
dart
```
Future<KimikoResponse>
containing the user response
```

### Example:
dart 
 ```
signup()async {
  var res = await kimkoAuth.signup(
      username: userNameController.text.trim(), 
      email: emailController.text.trim(), 
      password: passwordController.text.trim(), 
      firstName: fNameController.text.trim(), 
      lastName: lNameController.text.trim()
  );
  print(response);
}
```

## Team table

| Team Name        | App bundle                          | Team id                     |
|----------------|-----------------------------------|-----------------------------|
| **Team Kimiko (Flutter Team F)**  | com.example.angry_bird | angrybird-flutter-f01       |
| **Flutter Team A**  | com.example.angry_bird | angrybird-kimiko-f06        |
| **Team Starlight**  | com.example.heritage_quest | heritagequest-starlight-f02 |
| **Team Anchor**  | com.example.hockey_game | hockeygame-anchor-f03       |
