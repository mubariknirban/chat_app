import 'package:chat_app/Repository/signup_repo.dart';
import 'package:chat_app/Screens/chat_room_screen.dart';
import 'package:chat_app/Screens/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Constant/controller.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver{


  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  Map<String,dynamic>? userList;


  void searchUser()async{


    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

     await firebaseFirestore.collection('user')
           .where('email',isEqualTo: TextControllers.searchController.text).get().then((value){

             setState(() {
               userList = value.docs[0].data();
             });
             print(userList);

     });


  }

  chatRoomId(String user1, String user2)  {

    if(user1[0].toLowerCase().codeUnits[0] > user2[0].toLowerCase().codeUnits[0]){
      return '$user1$user2';
    }else{
      return '$user2$user1';
    }

  }

  void updateStatus(String status)async{

    await firestore.collection('user').doc(auth.currentUser!.uid).update({
      'status':status
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    updateStatus('online');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);

    if(state == AppLifecycleState.resumed){
      updateStatus('online');
    }else{
      updateStatus('offline');
    }
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("MainPage"),
        actions: [
          IconButton(
              onPressed: (){
                logOut();
                updateStatus('offline');
                Navigator.push(context, MaterialPageRoute(builder:
                    (context) => LoginPage()));
              },
              icon: Icon(Icons.logout_rounded))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: firestore.collection('user').snapshots(),
                builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
                  print(snapshot.data);
                  if(snapshot.data != null){
                    return ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context,index){
                          return ListTile(
                            onTap: ()async{


                              String roomId = await chatRoomId(auth.currentUser!.displayName.toString(), snapshot.data!.docs[index]['name'].toString());
                              print('chatRoomId----${roomId}');
                              Navigator.push(context, MaterialPageRoute(builder:
                                  (context) =>  ChatRoom(
                                name: snapshot.data!.docs[index]['name'].toString(),
                                chatRoomID: roomId,
                              )));
                            },
                            leading: Icon(Icons.account_box, color: Colors.black,),
                            title: Text(
                              snapshot.data!.docs[index]['name'].toString(),style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 17
                            ),
                            ),
                            subtitle: Row(
                              children: [
                                Text(
                                  snapshot.data!.docs[index]['email'].toString(),style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 10
                                ),

                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: snapshot.data!.docs[index]['status'] == "online"?Colors.green : Colors.red,
                                    shape: BoxShape.circle
                                  ),
                                  height: 10,
                                  width: 10,
                                )
                              ],
                            ),
                            trailing: Icon(Icons.chat, color: Colors.black,),
                          );
                        });
                  }
                  else{
                    return Container();
                  }
                },
              ),
            ],
          ),
        ),
      )
    );
  }

}
