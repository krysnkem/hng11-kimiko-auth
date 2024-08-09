import 'package:flutter/material.dart';
import 'package:kimko_auth/services/kimiko_exeception.dart';

import 'edit-profile.dart';
import 'main.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

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

  Future<void> logOut(BuildContext context) async {
    startLoading();
    try {
      var res = await kimkoAuth.logOut();
      print(res.data);
      setState(() {
        isLoggedIn.value = false;
        user.value ={};
      });
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_)=> const LoginScreen()), (route) => false);
    } on KimikoException catch (e) {
      debugPrint('Kimiko ${e.error}');
    } catch (e) {
      debugPrint("Another error $e");
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
  @override
  void initState() {
    getSavedUser();
    super.initState();
  }

  Future<void> getSavedUser() async {
    startLoading();
    try {
      var res = await kimkoAuth.getLoggedInUser();
      if(res.data != null){
        setState(() {
          user.value = res.data;
        });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: "APPBAR",
          child: const Text('User Page')
        ),
      ),
      body: Stack(
        children: [
          Padding(
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
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(user.value["avatar_url"]??"")
                              )
                          ),
                        ),
                      ),
                      const SizedBox(height: 16,),
                      UserDetails(
                        title: "First Name",
                        body: user.value["first_name"],
                      ),
                      UserDetails(
                        title: "Last Name",
                        body: user.value["last_name"],
                      ),
                      UserDetails(
                        title: "Email",
                        body: user.value["email"],
                      ),

                    ],
                  ),
                ),
                const SizedBox(height: 16,),
                Row(
                  children: [
                    Expanded(
                      child: Hero(
                        tag: "SUBMIT_BUTTON",
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)
                            )
                            // shape:
                          ),
                          onPressed: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (_)=> const EditProfileScreen())),
                          child: const Text("Edit Profile")
                        ),
                      ),
                    ),
                    const SizedBox(width: 16,),
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)
                          )
                          // shape:
                        ),
                        onPressed: getUser,
                        child: const Text("Get User")
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10,),
                OutlinedButton(
                    onPressed: ()=> logOut(context),
                    child: const Text("Logout")),
                const SizedBox(height: 16,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)
                    )
                    // shape:
                  ),
                  onPressed: () async {

                  },
                  child: const Text("Deactivate Account", style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),)
                ),
                const SizedBox(height: 30,),
              ],
            ),
          ),
          if (_isLoading) const LoaderScreen()
        ],
      ),
    );
  }
}
