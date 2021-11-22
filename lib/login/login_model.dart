import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginModel with ChangeNotifier {
  //ログアウト
  Future<void> logout() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
    notifyListeners();
  }

//ログインした上でログインしたユーザーデータを作る
  Future<void> login() async {
    //動画
    // 49:20エラーインポートのところ　おそらくpageの所でコードが違うのかも知れない
    final res = await signInWithGoogle();
    if (res) {
      //登録したユーザーデータが見れる
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        return;
      }
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(<String, dynamic>{
        'name': user.displayName,
        'imageUrl': user.photoURL,
        'email': user.email,
      });
    }
    notifyListeners();
  }

  //pageにも書いてあるから出来れば同じ、ものを使いまわしたい。
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
