import 'package:chat_app/Constant/controller.dart';
import 'package:chat_app/Repository/signup_repo.dart';
import 'package:chat_app/Screens/main_screen.dart';
import 'package:chat_app/Screens/register_screen.dart';
import 'package:chat_app/Screens/remote_cofig.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    FirebaseCrashlytics.instance.setCustomKey('str_key', 'Mubarik');
  }

  getData()async{
    var value  = await RemoteConfigure.getDate();
    print(value);
  }

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
                  await FirebaseCrashlytics.instance.recordError("error", null,
                      reason: 'a fatal error',
                      fatal: true
                  );

                  if(TextControllers.emailController.text.isNotEmpty && TextControllers.passwordController.text.isNotEmpty){

                    login(
                        TextControllers.emailController.text,
                        TextControllers.passwordController.text).then((value) {

                      if(value != null){

                        debugPrint('Login Successfully');
                        Navigator.push(context, MaterialPageRoute(builder:
                            (context) => const MainScreen()));

                      }else{
                        debugPrint('failed');
                      }

                    });

                  }
                },
                child: const Text("Login")),
            SizedBox(
              height: size.height / 80,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue
                ),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder:
                      (context) => const SignUpScreen()));
                },
                child: const Text("Create New")),
          ],
        ),
      ),
    );
  }
}
