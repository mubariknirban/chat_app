import 'package:chat_app/Repository/signup_repo.dart';
import 'package:chat_app/Screens/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Constant/controller.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {



  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(
              height: size.height / 10,
            ),
            TextField(
              controller: TextControllers.nameController,
              decoration: InputDecoration(
                  hintText: 'Name',
                  hintStyle: const TextStyle(
                      color: Colors.black
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                          color: Colors.black,
                          width: 2
                      )
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                          color: Colors.black,
                          width: 2
                      )
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                          color: Colors.black,
                          width: 2
                      )
                  )
              ),
            ),
            SizedBox(
              height: size.height / 30,
            ),
            TextField(
              controller: TextControllers.emailController,
              decoration: InputDecoration(
                  hintText: 'Email',
                  hintStyle: const TextStyle(
                      color: Colors.black
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                          color: Colors.black,
                          width: 2
                      )
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                          color: Colors.black,
                          width: 2
                      )
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                          color: Colors.black,
                          width: 2
                      )
                  )
              ),
            ),
            SizedBox(
              height: size.height / 30,
            ),
            TextField(
              controller: TextControllers.passwordController,
              decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: const TextStyle(
                      color: Colors.black
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                          color: Colors.black,
                          width: 2
                      )
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                          color: Colors.black,
                          width: 2
                      )
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                          color: Colors.black,
                          width: 2
                      )
                  )
              ),
            ),
            SizedBox(
              height: size.height / 30,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue
                ),
                onPressed: ()async{


                  if(TextControllers.emailController.text.isNotEmpty && TextControllers.passwordController.text.isNotEmpty){

                    createAccount(
                        TextControllers.nameController.text,
                        TextControllers.emailController.text,
                        TextControllers.passwordController.text).then((value) {

                          if(value != null){
                            print('create Successfully');
                            Navigator.push(context, MaterialPageRoute(builder:
                                (context) => const LoginPage()));
                          }else{
                            print('failed');
                          }

                    });

                  }

                },
                child: const Text("Register")),
          ],
        ),
      ),
    );
  }
}
