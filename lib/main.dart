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
      options: const FirebaseOptions(
        apiKey: "AIzaSyA42pAY6Qpzaeo2LFNZwA9nlRz_fYs1iZA",
        appId: "1:204761192676:ios:abce7938927e0b4bf3f4f1",
        messagingSenderId: "204761192676",
        projectId: "messenger-49964",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const HomePage());
}

class User {
  final String name;
  final String? avatar;
  final String message;

  User({required this.name, this.avatar, required this.message});

  User.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        avatar = map['avatar'],
        message = map['message'];

  @override
  String toString() {
    return 'User{name: $name}';
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

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
        setState(() {
          this.users = users;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // theme: ThemeData(useMaterial3: false),
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
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(27.5),
                              child: Image.network(
                                "https://scontent.fdad3-6.fna.fbcdn.net/v/t39.30808-6/286980610_1738159929916991_5836782347974105570_n.jpg?_nc_cat=103&ccb=1-7&_nc_sid=6ee11a&_nc_ohc=HcnzHW7rV8YQ7kNvgE3TyPf&_nc_ht=scontent.fdad3-6.fna&oh=00_AYAoLfF2SUwiTJjakjFo9V3h8MKSU5VLBCa_gt7H5_ZHmg&oe=669E8EAE",
                                width: 55,
                                height: 55,
                              ),
                            ),
                            SizedBox(width: 20),
                            Text(
                              'Long Phú',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 18),
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
          preferredSize: Size.fromHeight(60),
          child: Container(
            decoration: BoxDecoration(
                boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)]),
            child: AppBar(
              notificationPredicate: (_) => false,
              backgroundColor: Colors.white,
              leading: IconButton(
                padding: EdgeInsets.only(left: 15),
                icon: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey[100],
                    ),
                    child: Icon(
                      Icons.menu,
                      color: Colors.black,
                    )),
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
                  Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey[100]),
                      child: Icon(
                        Icons.edit,
                        color: Colors.black,
                      )),
                ],
              ),
            ),
          ),
        ),
        body: Expanded(
          child: Container(
            color: Colors.white,
            child: ListView.builder(
              itemCount: users.length + 1,
              itemBuilder: (context, index) {
                if (index == 0)
                  return Column(
                    children: [
                      SizedBox(height: 10),
                      Container(
                        margin:
                            EdgeInsets.only(left: 25, right: 25, bottom: 20),
                        child: TextField(
                          maxLines: 1,
                          decoration: InputDecoration(
                            prefixIconColor: Colors.grey,
                            fillColor: Colors.grey[100],
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 18),
                            hintText: 'Search',
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(40),
                            ),
                            filled: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 15),
                          ),
                        ),
                      ),
                      Container(
                        height: 110,
                        color: Colors.white,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: users.length + 1,
                            itemBuilder: (context, index) {
                              User user =
                                  (index != 0) ? users[index - 1] : users[0];
                              return InkWell(
                                onTap: () => {
                                  if (index != 0)
                                    {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MessagePage(user: user),
                                        ),
                                      )
                                    }
                                },
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: index == 0 ? 25 : 0, right: 25),
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(40),
                                        child: Image.network(
                                          index == 0
                                              ? "https://scontent.fdad3-6.fna.fbcdn.net/v/t39.30808-6/286980610_1738159929916991_5836782347974105570_n.jpg?_nc_cat=103&ccb=1-7&_nc_sid=6ee11a&_nc_ohc=HcnzHW7rV8YQ7kNvgE3TyPf&_nc_ht=scontent.fdad3-6.fna&oh=00_AYAoLfF2SUwiTJjakjFo9V3h8MKSU5VLBCa_gt7H5_ZHmg&oe=669E8EAE"
                                              : (user.avatar ??
                                                  'https://cdn.pixabay.com/photo/2016/11/18/23/38/child-1837375_1280.png'),
                                          width: 80,
                                          height: 80,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        index == 0 ? "Long Phú" : user.name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                    ],
                  );
                else {
                  User user = users[index - 1];
                  return InkWell(
                    onTap: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MessagePage(user: user),
                        ),
                      )
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          SizedBox(width: 15),
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
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22),
                                  ),
                                  Text(
                                    user.message,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700),
                                  )
                                ]),
                          ),
                          Container(
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
                  );
                }
              },
            ),
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
  final User user;

  MessagePage({required this.user});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  var messageList = [];

  void initState() {
    super.initState();
    messageList.add(Message(
        message: widget.user.message, createdAt: DateTime.now(), sentBy: '2'));
  }

  late final chatController = ChatController(
    initialMessageList: messageList.cast<Message>(),
    scrollController: ScrollController(),
    currentUser: ChatUser(id: '1', name: 'You'),
    otherUsers: [ChatUser(id: '2', name: widget.user.name)],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Container(
          decoration: BoxDecoration(
              boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)]),
          child: AppBar(
            notificationPredicate: (_) => false,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.purple, size: 30),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(22.5),
                  child: Image.network(
                    widget.user.avatar ??
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
                        widget.user.name,
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
