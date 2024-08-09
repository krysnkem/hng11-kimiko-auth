import 'dart:io';

import 'package:aws_s3_upload/aws_s3_upload.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kimko_auth/services/kimiko_exeception.dart';
import 'package:path/path.dart' as path;

import 'main.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future<void> getSavedUser() async {
    startLoading();
    try {
      var res = await kimkoAuth.getLoggedInUser();
      if(res.data != null){
        setState(() {
          user.value = res.data;
        });
        Navigator.of(context).pop(user.value);
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

  Future<void> updateUser() async {
    startLoading();
    try {
      var res = await kimkoAuth.updateUser(
        firstName: fNameController.text.trim(),
        lastName: lNameController.text.trim(),
        avatarUrl: newImageURL,
      );
      print(res.data);
      if(res.data != null){
       await getSavedUser();
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

  String? newImageURL;

  pickGallery() async {
    try{
      var image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(image!=null){
        String paths = image.path;
        String? imageData = await uploadS32(File(paths));
        if(imageData!=null){
          setState(() {
            newImageURL = imageData;
          });
          print(newImageURL);
        }
      }
    }catch(err){
      debugPrint("IMAGE PICKING ERROR:::: $err");
    }
  }

  pickCamera() async {
    try{
      var image = await ImagePicker().pickImage(source: ImageSource.camera);
      if(image!=null){
        String paths = image.path;
        String? imageData = await uploadS32(File(paths));
        if(imageData!=null){
          setState(() {
            newImageURL = imageData;
          });
        }
      }
    }catch(err){
      debugPrint("IMAGE PICKING ERROR:::: $err");
    }
  }

  Future<String?> uploadS32(File file) async {
    startLoading();
    try{
      var result = await AwsS3.uploadFile(
        accessKey: "AKIATNRDLORKQLXDBJBW",
        secretKey: "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",
        file: file,
        bucket: "adasheuserfiles",
        region: "us-east-1",
        destDir: "profilePics",
        filename:
        '${DateTime.now().millisecondsSinceEpoch.toString()}${path.extension(file.path)}',
      );
      stopLoading();
      return result;
    }catch(err){
      debugPrint("IMAGE UPLOAD ERROR:::: $err");
      stopLoading();
      return null;
    }
  }

  @override
  void initState() {
    fNameController = TextEditingController(text: user.value["first_name"]);
    lNameController = TextEditingController(text: user.value["last_name"]);
    // userNameController = TextEditingController(text: user.value["username"]??"");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Hero(
          tag: "APPBAR",
          child: Text('Edit Profile')
        ),
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
                        Hero(
                          tag: "PROFILE_PIC",
                          child: Container(
                            height: 300,
                            width: 300,
                            padding: EdgeInsets.all(16),
                            alignment: Alignment.bottomCenter,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(newImageURL ?? user.value["avatar_url"]??"")
                                )
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8)
                                              )
                                            // shape:
                                          ),
                                          onPressed: pickGallery,
                                          child: const Text("Gallery")
                                      ),
                                    ),
                                    const SizedBox(width: 16,),
                                    Expanded(
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8)
                                              )
                                            // shape:
                                          ),
                                          onPressed: pickCamera,
                                          child: const Text("Camera")
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16,),
                        Hero(
                          tag: "FIRST_NAME",
                          child: TextFormField(
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
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Hero(
                          tag: "LAST_NAME",
                          child: TextFormField(
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
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16,),
                  Hero(
                    tag: "SUBMIT_BUTTON",
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)
                        )
                        // shape:
                      ),
                      onPressed: () async {
                        if (formKey.currentState?.validate() != true) {
                          errorSnack(
                            "All fields must be filled to proceed",
                            context: context
                          );
                        } else {
                          await updateUser();
                        }
                      },
                      child: const Text("Submit")
                    ),
                  ),
                  const SizedBox(height: 30,),
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
