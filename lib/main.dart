import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:chatview/chatview.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isIOS) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyBTM49IRZCB6qKF0LrVscztjg7tKHldI2Q",
        appId: "1:589403131839:ios:637aa04b5a0f2546fc9b0a",
        messagingSenderId: "589403131839",
        projectId: "messenger-7b147",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(HomePage());
}

class User {
  final String name;
  final int age;
  final String? avatar;

  User({
    required this.name,
    required this.age,
    this.avatar,
  });

  //fromMap
  User.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        avatar = map['avatar'],
        age = map['age'];

  @override
  String toString() {
    return 'User{name: $name, age: $age}';
  }
}

class HomePage extends StatefulWidget {
  HomePage({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int currentIndex = 0;
  var title = ['Chats', 'Contacts', 'Reels'];
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      // listen realtime
      FirebaseFirestore.instance
          .collection("users")
          .snapshots()
          .listen((event) {
        final users = event.docs.map((e) => User.fromMap(e.data())).toList();
        print(users);
        setState(() {
          this.users = users;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        drawer: Drawer(
          backgroundColor: Colors.white,
          width: 360,
          child: ListView(
            children: [
              Container(
                height: 90,
                child: DrawerHeader(
                  // decoration: BoxDecoration(
                  //   boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)]
                  // ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.network(
                              'https://cdn.pixabay.com/photo/2016/11/18/23/38/child-1837375_1280.png',
                              width: 60,
                              height: 60,
                            ),
                          ),
                          SizedBox(width: 20),
                          Text(
                            'Long Phú',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 20),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.black,
                            size: 40,
                          )
                        ],
                      ),
                      Icon(
                        Icons.settings,
                        color: Colors.black,
                        size: 30,
                      )
                    ],
                  ),
                ),
              ),
              ListTile(
                horizontalTitleGap: 30,
                minVerticalPadding: 25,
                leading: Icon(
                  Icons.chat_bubble,
                  color: Colors.black,
                  size: 30,
                ),
                title: Text(
                  'Chats',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
              ),
              ListTile(
                horizontalTitleGap: 30,
                minVerticalPadding: 25,
                leading: Icon(
                  Icons.storefront,
                  color: Colors.black,
                  size: 30,
                ),
                title: Text(
                  'Marketplace',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
              ),
              ListTile(
                horizontalTitleGap: 30,
                minVerticalPadding: 25,
                leading: Icon(
                  Icons.sms,
                  color: Colors.black,
                  size: 30,
                ),
                title: Text(
                  'Message Requests',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
              ),
              ListTile(
                horizontalTitleGap: 30,
                minVerticalPadding: 25,
                leading: Icon(
                  Icons.inventory_2,
                  color: Colors.black,
                  size: 30,
                ),
                title: Text(
                  'Archived',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(65),
          child: Container(
            decoration: BoxDecoration(
                boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)]),
            child: AppBar(
              leading: IconButton(
                icon: Icon(
                  Icons.reorder,
                  color: Colors.black,
                ),
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title[currentIndex],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    Icons.edit,
                    color: Colors.black,
                  )
                ],
              ),
            ),
          ),
        ),
        body: Container(
          color: Colors.white,
          child: ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];

              return InkWell(
                onTap: () => {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => MessagePage(),
                  //   ),
                  // )
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FirestoreDemo(),
                    ),
                  )
                },
                child: Container(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      children: [
                        SizedBox(width: 20),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Image.network(
                            user.avatar ??
                                'https://cdn.pixabay.com/photo/2016/11/18/23/38/child-1837375_1280.png',
                            width: 80,
                            height: 80,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                Text(
                                  'Age: ${user.age}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                )
                              ]),
                        ),
                        Expanded(
                            child: Container(
                                alignment: Alignment.topRight,
                                child: Text(
                                  DateFormat('HH:mm').format(DateTime.now()),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black),
                                ))),
                        SizedBox(
                          width: 20,
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        bottomNavigationBar: Container(
          height: 110,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                color: const Color.fromARGB(255, 235, 235, 235), blurRadius: 5)
          ]),
          child: BottomNavigationBar(
              backgroundColor: Colors.white,
              selectedItemColor: Colors.blueAccent,
              unselectedItemColor: Colors.grey,
              currentIndex: currentIndex,
              onTap: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              items: [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.chat_bubble,
                    ),
                    label: 'Chats'),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.group,
                    ),
                    label: 'Contacts'),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.content_copy,
                    ),
                    label: 'Reels'),
              ]),
        ),
      ),
    );
  }
}

class MessagePage extends StatefulWidget {
  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  var messageList = [
    Message(message: 'Hello', createdAt: DateTime.now(), sentBy: '1'),
    Message(message: 'Hello', createdAt: DateTime.now(), sentBy: '2'),
  ];

  late final chatController = ChatController(
    initialMessageList: messageList,
    scrollController: ScrollController(),
    currentUser: ChatUser(id: '1', name: 'You'),
    otherUsers: [ChatUser(id: '2', name: 'Long Phú')],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65),
        child: Container(
          decoration: BoxDecoration(
              boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)]),
          child: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.purple, size: 30),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(22.5),
                  child: Image.network(
                    'https://cdn.pixabay.com/photo/2016/11/18/23/38/child-1837375_1280.png',
                    width: 50,
                    height: 50,
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Long Phú',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        'Active now',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      )
                    ],
                  ),
                ),
                Icon(Icons.call, color: Colors.purple, size: 30),
                SizedBox(
                  width: 25,
                ),
                Icon(Icons.videocam, color: Colors.purple, size: 30),
                SizedBox(
                  width: 25,
                ),
                Icon(Icons.info, color: Colors.purple, size: 30),
              ],
            ),
          ),
        ),
      ),
      body: ChatView(
        chatController: chatController,
        onSendTap: (message, replyMessage, messageType) {
          chatController.addMessage(Message(
              message: message, createdAt: DateTime.now(), sentBy: '1'));
        },
        sendMessageConfig: SendMessageConfiguration(
          textFieldConfig:
              TextFieldConfiguration(textStyle: TextStyle(color: Colors.black)),
          defaultSendButtonColor: Colors.blueAccent,
          allowRecordingVoice: false,
          enableCameraImagePicker: false,
          enableGalleryImagePicker: false,
        ),
        chatViewState: ChatViewState.hasMessages,
      ),
    );
  }
}

class FirestoreDemo extends StatefulWidget {
  @override
  State<FirestoreDemo> createState() => _FirestoreDemoState();
}

class _FirestoreDemoState extends State<FirestoreDemo> {
  String text = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firestore Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Firestore Demo'),
        ),
        body: Center(
          child: Column(
            children: [
              Text(text),
              ElevatedButton(
                onPressed: () async {
                  final nhi = await FirebaseFirestore.instance
                      .collection("users")
                      .get();
                  final users =
                      nhi.docs.map((e) => User.fromMap(e.data())).toList();
                  print(users);
                  setState(() {
                    text = users.join('\n');
                  });
                },
                child: Text('Get all users'),
              ),
              ElevatedButton(
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection("users")
                      .doc('nhi')
                      .get()
                      .then((value) {
                    final user = User.fromMap(value.data()!);
                    print(user);
                    setState(() {
                      text = user.toString();
                    });
                  });
                },
                child: Text('Get user by id (nhi)'),
              ),
              ElevatedButton(
                onPressed: () {
                  // add user minh
                  FirebaseFirestore.instance
                      .collection("users")
                      .doc('minh')
                      .set({
                    'name': 'Minh',
                    'age': 30,
                  });

                  // get lại all users để kiểm tra
                  FirebaseFirestore.instance
                      .collection("users")
                      .get()
                      .then((value) {
                    final users =
                        value.docs.map((e) => User.fromMap(e.data())).toList();
                    print(users);
                    setState(() {
                      text = users.join('\n');
                    });
                  });
                },
                child: Text('Add user (minh)'),
              ),
              ElevatedButton(
                onPressed: () {
                  // update user minh
                  FirebaseFirestore.instance
                      .collection("users")
                      .doc('minh')
                      .update({
                    'name': 'Thanh Minh',
                    'age': 31,
                    'avatar':
                        'https://cdn.pixabay.com/photo/2016/11/18/23/38/child-1837375_1280.png'
                  });

                  // get lại all users để kiểm tra
                  FirebaseFirestore.instance
                      .collection("users")
                      .get()
                      .then((value) {
                    final users =
                        value.docs.map((e) => User.fromMap(e.data())).toList();
                    print(users);
                    setState(() {
                      text = users.join('\n');
                    });
                  });
                },
                child: Text('Update user (minh)'),
              ),
              ElevatedButton(
                onPressed: () {
                  // delete user minh
                  FirebaseFirestore.instance
                      .collection("users")
                      .doc('minh')
                      .delete();

                  // get lại all users để kiểm tra
                  FirebaseFirestore.instance
                      .collection("users")
                      .get()
                      .then((value) {
                    final users =
                        value.docs.map((e) => User.fromMap(e.data())).toList();
                    print(users);
                    setState(() {
                      text = users.join('\n');
                    });
                  });
                },
                child: Text('Delete user (minh)'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
