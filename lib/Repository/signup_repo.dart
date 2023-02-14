import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';



Future<User?> createAccount(String name, String email, String password) async{

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  try{

    User? user = (await auth.createUserWithEmailAndPassword(email: email, password: password)).user;

    if(user != null){

      print('User Create Successfully');

      user.updateProfile(displayName: name);
      await firebaseFirestore.collection('user').doc(auth.currentUser!.uid).set({
        "name":name,
        "email":email,
        "status":"offline",
        'uid':auth.currentUser!.uid
      });

      return user;
    }else{
      print('User Not Created');
      return user;
    }

  }catch(e){
    print(e);
    return null;
  }

}

Future<User?> login(String email, String password) async{

  FirebaseAuth auth = FirebaseAuth.instance;

  try{

    User? user = (await auth.signInWithEmailAndPassword(email: email, password: password)).user;

    if(user != null){

      print('Login Successfully');
      return user;
    }else{
      print('Login Failed');
      return user;
    }

  }catch(e){
    print(e);
    return null;
  }

}

Future<User?> logOut() async{

  FirebaseAuth auth = FirebaseAuth.instance;

  try{

    await auth.signOut();
  }catch(e){
    print(e);
    return null;
  }

}

