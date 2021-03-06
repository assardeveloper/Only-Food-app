import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fajira_grosery/widgets/my_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './login_page.dart';
import '../widgets/rasied_button.dart';
import '../widgets/flat_button.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../model/user.dart';
import 'package:path/path.dart' as Path;

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _netWorkLodding = false;
  bool isMale = true;

  File isImage;
  File camaraImage;
  Future getImage(bool iscamera) async {
    if (iscamera) {
      isImage = await ImagePicker.pickImage(source: ImageSource.camera);
    } else {
      isImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    }
    setState(() {
      camaraImage = isImage;
    });
  }

  // Future getImage({ImageSource source}) async {
  //   final pickedImage = await ImagePicker().getImage(source: source);
  //   setState(() {
  //     isImage = File(pickedImage.path);
  //   });
  // }

  Future<Map<String, String>> _uploadFile(File _image) async {
    String _imagePath = _image.path;

    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('images/${(Path.basename(_imagePath))}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    StorageTaskSnapshot task = await uploadTask.onComplete;
    final String _imageUrl = (await task.ref.getDownloadURL());

    Map<String, String> _downloadData = {
      'imagePath': Path.basename(_imagePath),
      'imageUrl': _imageUrl
    };
    return _downloadData;
  }

  static Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  final RegExp regex = RegExp(pattern);

  AuthResult authResult;

  GlobalKey<ScaffoldState> myKey = GlobalKey<ScaffoldState>();
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController fullName = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController address = TextEditingController();

  void submit() async {
    try {
      setState(() {
        _netWorkLodding = true;
      });

      var imageMap = await _uploadFile(isImage);
      User user = User(
        myImage: imageMap["imageUrl"],
        imagePath: imageMap["imagePath"],
        email: email.text,
        fullName: fullName.text,
        phoneNumber: int.parse(phoneNumber.text),
        address: address.text,
        gender: isMale ? 'Male' : 'Famale',
      );

      await Firestore.instance
          .collection('user')
          .document(authResult.user.uid)
          .setData(
        {
          'email': user.email,
          'phoneNumber': user.phoneNumber,
          'fullName': user.fullName,
          'gender': user.gender,
          "userId": authResult.user.uid,
          'address': user.address,
          "UserImage": user.myImage,
          "UserPath": user.imagePath,
        },
      );
    } on PlatformException catch (err) {
      var message = 'assar';
      if (err.message != null) {
        message = err.message;
      }
      myKey.currentState.showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      setState(() {
        _netWorkLodding = false;
      });
    } catch (erro) {
      setState(() {
        _netWorkLodding = false;
      });
      myKey.currentState.showSnackBar(
        SnackBar(
          content: Text(
            erro,
          ),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    }
    setState(
      () {
        _netWorkLodding = false;
      },
    );
  }

  void checkValid() {
    if (isImage == null) {
      myKey.currentState.showSnackBar(SnackBar(
        content: Text("Photo Is Empty"),
        duration: Duration(milliseconds: 800),
        backgroundColor: Theme.of(context).primaryColor,
      ));
    } else if (fullName.text.trim() == null || fullName.text.isEmpty) {
      myKey.currentState.showSnackBar(SnackBar(
        content: Text("FullName Is Empty"),
        duration: Duration(milliseconds: 800),
        backgroundColor: Theme.of(context).primaryColor,
      ));
    } else if (email.text.isEmpty || email.text.trim() == null) {
      myKey.currentState.showSnackBar(SnackBar(
        content: Text("Email is Empty"),
        duration: Duration(milliseconds: 800),
        backgroundColor: Theme.of(context).primaryColor,
      ));
    } else if (password.text.trim() == null || password.text.isEmpty) {
      myKey.currentState.showSnackBar(SnackBar(
        content: Text("Password Is Empty"),
        duration: Duration(milliseconds: 800),
        backgroundColor: Theme.of(context).primaryColor,
      ));
    } else if (!regex.hasMatch(email.text)) {
      myKey.currentState.showSnackBar(SnackBar(
        content: Text("Please Try Vaild Email"),
        duration: Duration(milliseconds: 800),
        backgroundColor: Theme.of(context).primaryColor,
      ));
    } else if (phoneNumber.text.isEmpty) {
      myKey.currentState.showSnackBar(SnackBar(
        content: Text("Phone Number is Empty"),
        duration: Duration(milliseconds: 800),
        backgroundColor: Theme.of(context).primaryColor,
      ));
    }  else if (address.text.isEmpty || address.text.trim() == null) {
      myKey.currentState.showSnackBar(SnackBar(
        content: Text("Address is Empty"),
        duration: Duration(milliseconds: 800),
        backgroundColor: Theme.of(context).primaryColor,
      ));
    } else {
      submit();
    }
  }

  Widget firstPart() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.2 + 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 110,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'SignUp',
                  style: TextStyle(
                    color: Color(0xfffe257e),
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                  ),
                ),
                Text(
                  'create an account',
                  style: TextStyle(
                    color: Color(0xfffe6ba7),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              showDialog<void>(
                context: context,
                barrierDismissible: false, // user must tap button!
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Choice Your Option'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(Icons.camera_alt),
                                  onPressed: () {
                                    getImage(true);
                                  }),
                              Text("From Camera"),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(Icons.photo_album),
                                  onPressed: () {
                                    getImage(false);
                                  }),
                              Text(
                                "From Gallery",
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Container(
                            height: 40,
                            width: 60,
                            color: Theme.of(context).primaryColor,
                            child: Center(
                              child: Text(
                                'Ok',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            )),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
              // getImage(
              //   source: ImageSource.camera,
              // );
            },
            child: CircleAvatar(
              backgroundColor: Colors.red,
              radius: 60,
              child: CircleAvatar(
                backgroundImage: isImage == null
                    ? AssetImage('images/tonyprofile.jpg')
                    : FileImage(isImage),
                radius: 56,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget secoundPart() {
    return Container(
      height: 450,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  MyTextField(
                    name: 'fullName',
                    obscureText: false,
                    controller: fullName,
                  ),
                  MyTextField(
                    name: 'Email',
                    obscureText: false,
                    controller: email,
                  ),
                  MyTextField(
                    name: 'Password',
                    obscureText: false,
                    controller: password,
                  ),
                  MyTextField(
                    name: 'phoneNumber',
                    obscureText: false,
                    controller: phoneNumber,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isMale = !isMale;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 20, left: 10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Color(0x40aee4f2),
                          borderRadius: BorderRadius.circular(10)),
                      height: 60,
                      child: Text(
                        isMale ? 'male' : 'Female',
                        style: TextStyle(
                          fontSize: 17,
                          color: Color(0xff756b6f),
                        ),
                      ),
                    ),
                  ),
                  MyTextField(
                    name: 'address',
                    obscureText: false,
                    controller: address,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget thirdPart() {
    return Container(
      child: Column(
        children: <Widget>[
          _netWorkLodding == false
              ? RasiedButton(
                  textColors: Colors.white,
                  colors: Theme.of(context).primaryColor,
                  buttonText: 'SignUp',
                  whenPrassed: () {
                    checkValid();
                  },
                )
              : CircularProgressIndicator(
                  backgroundColor: Colors.red,
                ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.0 + 10,
          ),
          Container(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Text(
                        'already have an account?',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    if (!_netWorkLodding)
                      MyFlatButton(
                        flatButtonText: 'Login',
                        whenPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: myKey,
      backgroundColor: Colors.white,
      body: Form(
        child: SafeArea(
          child: Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 30),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  firstPart(),
                  secoundPart(),
                  SizedBox(
                    height: 25,
                  ),
                  thirdPart(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
