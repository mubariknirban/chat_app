
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';


class ChatRoom extends StatefulWidget {
  final String name;
  final String chatRoomID;
  const ChatRoom({Key? key, required this.name, required this.chatRoomID}) : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

  final TextEditingController message = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final ImagePicker picker = ImagePicker();
  File? imageFile;

  void onSendMessage() async {

    if(message.text.isNotEmpty){
      Map<String,dynamic> messages = {
        'sendby': auth.currentUser!.displayName,
        'message':message.text,
        'type':'text',
        'time':FieldValue.serverTimestamp()
      };
      await firestore.collection('chatroom').doc(widget.chatRoomID).collection('chats').add(messages);
      message.clear();
    }else{
      print('Enter Some Text');
    }
  }

  void getImage()async{

    await picker.pickImage(source: ImageSource.gallery).then((xfile){
      if(xfile != null){
        setState(() {
          imageFile = File(xfile.path);
        });
        imageUpload();
      }

    });
  }
  Future imageUpload () async{
    String imageId = Uuid().v1();
    int status = 1;
    await firestore.collection('chatroom').doc(widget.chatRoomID).collection('chats').doc(imageId).set({
      'sendby': auth.currentUser!.displayName,
      'message':"",
      'type':'img',
      'time':FieldValue.serverTimestamp()
    });
    var ref = FirebaseStorage.instance.ref().child('images').child('$imageId.jpg');
    var uploadTask = await ref.putFile(imageFile!).catchError((error)async{
      await firestore.collection('chatroom').doc(widget.chatRoomID).collection('chats').doc(imageId).delete();

      status =0;
    });

    if(status == 1){
      String imageUrl = await  uploadTask.ref.getDownloadURL();
      await firestore.collection('chatroom').doc(widget.chatRoomID).collection('chats').doc(imageId).update({
       "message":imageUrl
      });
      print('image---$imageUrl');
    }
  }


  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [


            Container(
              height: size.height / 1.25,
              width: size.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: firestore.collection('chatroom').doc(widget.chatRoomID).collection('chats')
                    .orderBy('time',descending: false).snapshots(),
                builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
                  if(snapshot.data != null){
                    return ListView.builder(
                         itemCount: snapshot.data!.docs.length,
                         itemBuilder: (context,index){
                           Map<String, dynamic>? map = snapshot.data!.docs[index].data() as Map<String, dynamic>?;
                           return messageWidget(size,map);
                    });
                  }
                  else{


                    return Container();
                  }
                },
              ),
            ),
            Container(
                padding: EdgeInsets.all(10),
                height: size.height /10,
                width: size.width,
                alignment: Alignment.center,
                child: Container(
                  height: size.height /12,
                  width: size.width,
                  child: Row(
                    children: [
                      Container(
                        height: size.height / 12,
                        width: size.width / 1.5,
                        child: TextField(
                          controller: message,
                          decoration: InputDecoration(
                              hintText: "Send Message",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8)
                              )
                          ),
                        ),
                      ),
                      IconButton(onPressed: (){
                        getImage();
                      }, icon: Icon(Icons.image)),
                      IconButton(onPressed: (){
                        onSendMessage();
                      }, icon: Icon(Icons.send)),
                    ],
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }

  Widget messageWidget(Size size, Map<String,dynamic>? map){

    return map!['type'] == "text" ? Container(
      width: size.width,
      alignment: map['sendby'] == auth.currentUser!.displayName ?
      Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.blue
        ),
        child: Text(map!['message'],style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500
        ),),
      ),
    ) :
          Container(
            height: size.height /2.5,
            width: size.width,
            alignment: map['sendby'] == auth.currentUser!.displayName ?
            Alignment.centerRight : Alignment.centerLeft,
            child: InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ShowImage(imageUrl:map['message'])));
              },
              child: Container(
                  height: size.height /2.5,
                  width: size.width / 2,
                  padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                  decoration: BoxDecoration(
                      border: Border.all()
                  ),
                  alignment: map['message'] != "" ? null :Alignment.center,
                  child: map['message'] != "" ?Image.network(map['message'],fit: BoxFit.cover,)
                      : CircularProgressIndicator()
              ),
            )
          );

  }
}


class ShowImage extends StatelessWidget {
  final String imageUrl;
  const ShowImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        child: Image.network(imageUrl),
      ),
    );
  }
}

