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


### Kimiko response
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
### Kimiko User json
```dart
{
  "id": "",
  "first_name": "",
  "last_name": "",
  "is_active": true,
  "email": "somethingm@gmail.com",
  "avatar_url": ""
}
```


### Sign UP functionality

#### Returns:

```dart 
Future<KimikoResponse>
containing the user response
```

#### Example:

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



### Sign in functionality

#### Returns:

```dart 
Future<KimikoResponse>
containing the user response
```

##### Example:


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


### Get User

Get user details from api

#### Returns:

```dart 
Future<KimikoResponse>
containing the user response
```

#### Example:

```dart
Future<void> getUser() async {
    try {
      var res = await kimkoAuth.getUser();
      print(res.data);
      if (res.data != null) {
        setState(() {
          user.value = res.data['data'];
        });
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => const ProfileScreen()));
      }
    } on KimikoException catch (e) {
      debugPrint('Kimiko ${e.error}');
      errorSnack(e.error.toString(), context: context);
    } catch (e) {
      debugPrint("Another error $e");
      errorSnack(e.toString(), context: context);
    }
    
  }
```


### Get Logged in User

Logs in a user with the provided email and password.

#### Returns:

```dart 
Future<KimikoResponse>
containing the user response
```

#### Example:

```dart 
 var res = await kimkoAuth.getLoggedInUser();
 print(res.data);
```


### Update user

This updates the user's details.
You can update 
- firstName
- lastName
- avatarUrl
- username

#### Returns:

```dart 
Future<KimikoResponse>
containing the user response
```

#### Example:

```dart 
 Future<void> updateUser() async {
    try {
      var res = await kimkoAuth.updateUser(
        firstName: fNameController.text.trim(),
        lastName: lNameController.text.trim(),
        avatarUrl: newImageURL,
      );
      print(res.data);
      
    } on KimikoException catch (e) {
      debugPrint('Kimiko ${e.error}');
      errorSnack(e.error.toString(), context: context);
    } catch (e) {
      debugPrint("Another error $e");
      errorSnack(e.toString(), context: context);
    }
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