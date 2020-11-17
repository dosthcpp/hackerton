import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:chatter/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

final _fireStore = FirebaseFirestore.instance;
const int SAMPLE_RATE = 8000;

class ChatPage extends StatefulWidget {
  static String id = 'chat_page';

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  var newFile;
  var dir;
  var byte;
  var result;
  bool didPay = false;
  bool isLoading = false;
  var state = "유료 이모티콘 결제";

  final textEditingController = TextEditingController();
  String messageText;

  Future<http.Response> fetchResult(req) async {
    return await http.post(
      'http://svc.saltlux.ai:31781',
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
        {
          'key': 'ff539f0a-952e-499c-91cd-703558ff9dcc',
          'serviceId': '11987300804',
          "argument": {
            'type': "1",
            'query': req
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          200.0,
        ),
        child: Material(
          elevation: 2.0,
          child: Padding(
            padding: EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              top: 20.0,
            ),
            child: Container(
              height: 120.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: [
                      Material(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            10.0,
                          ),
                        ),
                        color: Colors.black12,
                        child: Image.asset(
                          'images/icon.png',
                          height: 70.0,
                          scale: 0.65,
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 30.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "대화방",
                              style: TextStyle(
                                fontSize: 21.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 30.0,
                      left: 70.0,
                    ),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Row(
                        children: <Widget>[
                          GestureDetector(
                              child: Icon(
                                Icons.search,
                                size: 30.0,
                              ),
                              onTap: () {
                                // Do something
                              }),
                          SizedBox(
                            width: 5.0,
                          ),
                          GestureDetector(
                              child: Image.asset(
                                'images/alarm_setting.png',
                                height: 35.0,
                              ),
                              onTap: () {
                                // Do something
                              }),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          _MessagesStream(
            didPay: didPay,
          ),
          Expanded(
            child: Material(
              elevation: 10.0,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 10.0,
                  right: 10.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 3.0,
                        horizontal: 10.0,
                      ),
                      child: Container(
                        child: GestureDetector(
                          child: Text("\$",
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black54,
                              )),
                          onTap: () {
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              child:
                                  StatefulBuilder(builder: (context, setState) {
                                return AlertDialog(
                                  content: Container(
                                    child: GestureDetector(
                                      child: Row(
                                        children: [
                                          Text(state),
                                          isLoading
                                              ? CircularProgressIndicator()
                                              : SizedBox(),
                                        ],
                                      ),
                                      onTap: () {
                                        setState(() {
                                          state = "결제중입니다...";
                                          isLoading = true;
                                          Future.delayed(Duration(seconds: 3),
                                              () {
                                            Navigator.pop(context);
                                            didPay = true;
                                          });
                                        });
                                      },
                                    ),
                                  ),
                                );
                              }),
                            );
                          },
                        ),
                      ),
                    )),
                    Expanded(
                      flex: 10,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 3.0,
                          horizontal: 10.0,
                        ),
                        child: TextField(
                          controller: textEditingController,
                          decoration: kMessageTextFieldDecoration,
                          onChanged: (value) {
                            messageText = value;
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: RawMaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          side: BorderSide(
                            color: Color(0xFF2C76E3),
                          ),
                        ),
                        fillColor: Colors.blue,
                        onPressed: () async {
                          DateTime now = DateTime.now();
                          var emo;
                          http.Response response =
                              await fetchResult(messageText);
                          if (response.statusCode == 200) {
                            print(json.decode(response.body));
                            emo = json.decode(response.body)['Result'] !=
                                    null
                                ? json.decode(response.body)['Result'][0][1]
                                : null;
                          }
                          else {
                            throw Exception('Failed to load.');
                          }
                          if (messageText != null) {
                            textEditingController.clear();
                            String email = Theme.of(context).platform ==
                                    TargetPlatform.android
                                ? 'aaa@bbb.com'
                                : 'drakedog19@gmail.com';
                            _fireStore.collection('messageList').add(
                              {
                                'text': messageText,
                                'sender': email,
                                'time': now.toString(),
                                'emo': emo
                              },
                            );
                          }
                        },
                        child: Icon(
                          Icons.arrow_upward,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessagesStream extends StatelessWidget {
  bool didPay = false;

  _MessagesStream({this.didPay});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _fireStore.collection('messageList').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        String messageSender;
        // TODO: order data by time directly on the database
        final messages = snapshot.data.documents; // Flutter inline variable
        List<_MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final String messageText =
              message['text']; // messages from FirebaseData
          messageSender = message['sender'];
          final DateTime time = DateTime.parse(message['time']);
          final String emo = message['emo'];
          final String currentUser =
              Theme.of(context).platform == TargetPlatform.android
                  ? 'aaa@bbb.com'
                  : 'drakedog19@gmail.com';

          final messageBubble = _MessageBubble(
            // TODO: if teacher send this message, ...
            // TODO: following kindergarten code, make a new chatroom.
            sender: messageSender,
            text: messageText,
            time: time.toString(),
            isMe: currentUser == messageSender,
            emo: emo,
          );
          messageBubbles.add(messageBubble);
        }
        messageBubbles.sort((a, b) {
          var aTime = a.time;
          var bTime = b.time;
          return -aTime.compareTo(bTime);
        });

        Map<String, String> emojiMap = {
          '기쁨': 'images/emoji/happy.gif',
          '신뢰': 'images/emoji/truthful.gif',
          '공포': 'images/emoji/scary.gif',
          '기대': 'images/emoji/expecting.gif',
          '놀라움': 'images/emoji/amazing.gif',
          '슬픔': 'images/emoji/sad.gif',
          '혐오': 'images/emoji/disgustting.gif',
          '분노': 'images/emoji/furious.gif'
        };

        Map<String, String> emojiMapFree = {
          '기쁨': 'images/emoji/happy_.png',
          '신뢰': 'images/emoji/truthful_.png',
          '공포': 'images/emoji/scary_.png',
          '기대': 'images/emoji/expecting_.png',
          '놀라움': 'images/emoji/amazing_.png',
          '슬픔': 'images/emoji/sad_.png',
          '혐오': 'images/emoji/disgustting_.png',
          '분노': 'images/emoji/furious_.png'
        };

        List<Widget> ret = [];
        for (var i = 0; i < messageBubbles.length; ++i) {
          ret.add(Theme.of(context).platform == TargetPlatform.android
              ? SizedBox()
              : Padding(
                  padding: EdgeInsets.only(
                    top: 20,
                    right: 250,
                  ),
                  child: !messageBubbles[i].isMe
                      ? Container(
                          color: Colors.white,
                          height: 100,
                          child: Center(
                            child: messageBubbles[i].emo != null
                                ? Image.asset(
                                    didPay == true
                                        ? emojiMap[messageBubbles[i].emo]
                                        : emojiMapFree[messageBubbles[i].emo],
                                  )
                                : null,
                          ),
                        )
                      : null,
                ));
          ret.add(messageBubbles[i]);

          if (i + 1 != messageBubbles.length &&
              messageBubbles[i].time.toString().split(" ")[0] !=
                  messageBubbles[i + 1].time.toString().split((" "))[0]) {
            ret.add(
              _CustomDivider(
                time: DateTime.parse(
                  messageBubbles[i].time,
                ),
              ),
            );
          }
          if (i == messageBubbles.length - 1) {
            ret.add(
              _CustomDivider(
                time: DateTime.parse(
                  messageBubbles[i].time,
                ),
              ),
            );
          }
        }

        return Expanded(
          flex: 10,
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 20.0,
            ),
            children: ret,
          ),
        );
      },
    );
  }
}

class _CustomDivider extends StatelessWidget {
  _CustomDivider({@required this.time});

  final DateTime time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 10.0,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Divider(
              color: Colors.black,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                time.toString().split(" ")[0].split("-")[0] +
                    "년 " +
                    time.toString().split(" ")[0].split("-")[1] +
                    "월 " +
                    time.toString().split(" ")[0].split("-")[2] +
                    "일",
                style: TextStyle(
                  fontSize: 12.0,
                ),
              ),
            ),
          ),
          Expanded(
            child: Divider(
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  _MessageBubble({
    this.sender,
    this.emo,
    @required this.text,
    @required this.time,
    @required this.isMe,
  });

  final String emo;
  final String sender;
  final String text;
  final String time;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    if (!isMe) {
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: 5.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: AssetImage(
                'images/icon.png',
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "유저",
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Material(
                      borderRadius: kBorderRadiusIfIsNotMe,
                      color: Colors.black54,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 5.0,
                          horizontal: 15.0,
                        ),
                        child: Text(
                          text,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      time.split(" ")[1].split(":")[0] +
                          ":" +
                          time.split(" ")[1].split(":")[1],
                      style: TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: 5.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  "유저",
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      time.split(" ")[1].split(":")[0] +
                          ":" +
                          time.split(" ")[1].split(":")[1],
                      style: TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Material(
                      borderRadius: kBorderRadiusIfIsMe,
                      color: Colors.blue,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 5.0,
                          horizontal: 15.0,
                        ),
                        child: Text(
                          text,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              width: 10.0,
            ),
            CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: AssetImage(
                'images/icon.png',
              ),
            ),
          ],
        ),
      );
    }
  }
}
