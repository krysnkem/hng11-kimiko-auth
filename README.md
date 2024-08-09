# kimko_auth


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
```
dependencies:
kimko_auth: ^1.0.4
```
Run
```
dart flutter pub get
```
To install the new dependency.


## Usage
After adding the Auth Library to your project, you can start using it by importing the package and initializing the KimkoAuth.
Initialize the Library

```dart
import 'package:flutter/material.dart';
import 'package:kimko_auth/kimko_auth.dart';

KimkoAuth kimkoAuth = KimkoAuth();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await KimkoAuth.initialize(teamId: 'angrybird-kimiko-f06');

  runApp(const MyApp());
}
```


### Sign in functionality

```dart
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


```dart
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

```dart
Future<KimikoResponse>
containing the user response
```

# Example:

```dart
 var res = await kimkoAuth.signIn(
    email: emailController.text.trim(),
    password: passwordController.text.trim()
  );
print(response);
```

### Get User

Logs in a user with the provided email and password.

# Returns:

```dart 
Future<KimikoResponse>
containing the user response
```

# Example:

```dart 
 var res = await kimkoAuth.getLoggedInUser();
 print(res.data);
```

### Sign UP functionality


```dart
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

# signup(username: username, email: email,  password: password, firstName: firstName, lastName: lastName,)

Creates a user on the platform

# Parameters:
* email: The user's email address.
* password: The user's password.
* username: The user's username.
* firstname: The user's first name.
* lastName: The user's last name.

# Returns:

```dart
Future<KimikoResponse>
containing the user response
```

# Example:
 
 ```dart
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


### Log out

This deletes all the user data and ends session

# Returns:

```dart 
Future<KimikoResponse>
containing the user response
```

# Example:

```dart 
 var res = await kimkoAuth.logOut();
```


### Team IDs
#### Team Names and their IDs
Team Kimiko (Flutter Team F)	-	angrybird-flutter-f01


Flutter Team A	-	angrybird-kimiko-f06


Team Starlight	-	heritagequest-starlight-f02


Team Anchor	-	hockeygame-anchor-f03

## Team: Team Kimiko (Telex)
- [@krysnkem](https://github.com/krysnkem) (GitHub: krysnkem | Slack: @Christian Onyisi)
- [@andymaking](https://github.com/andymaking) (GitHub: andymaking | Slack: @the_andima)
- [@adebola-duf](https://github.com/adebola-duf) (GitHub: adebola-duf | Slack: @bolexyro)
- [@ManifestJosh](https://github.com/ManifestJosh) (GitHub: ManifestJosh | Slack: @Manifest)


Feel free to reach out to the team for any questions.