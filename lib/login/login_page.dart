import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:health_app/first_forms/my_home_page.dart';
import 'package:health_app/login/login_model.dart';
import 'package:provider/provider.dart';
import 'package:sign_button/constants.dart';
import 'package:sign_button/create_button.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginModel>(
      create: (context) => LoginModel(),
      child: Consumer<LoginModel>(builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'ログイン',
            ),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(FirebaseAuth.instance.currentUser?.displayName ??
                    'ログインしていません'),
                const SizedBox(
                  height: 24,
                ),
                SignInButton(
                    buttonType: ButtonType.google,
                    onPressed: () async {
                      await model.login();
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return MyHomePage();
                      }));
                    }),
                const SizedBox(
                  height: 24,
                ),
                if (FirebaseAuth.instance.currentUser != null)
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        model.logout();
                      },
                      child: const Text('ログアウト'),
                    ),
                  )
                else
                  const SizedBox(height: 48)
              ],
            ),
          ),
        );
      }),
    );
  }

  //Googleサインインで成功するとtrueを返す。
  Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return false;
      }

      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      return true;
    } catch (e) {
      log('$e');
      return false;
    }
  }
}
