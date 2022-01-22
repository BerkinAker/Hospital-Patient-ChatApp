import 'package:flutter/material.dart';
import 'package:client/models/UserChat.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatPage extends StatefulWidget {
  final int userId; 
  final int userTo;
  final String usernameMe;
  final String usernameTo;
  final String statu;

  ChatPage({Key? key, required this.userId, required this.userTo, required this.usernameMe, required this.usernameTo, required this.statu}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<UserChat> _messages = [];

   void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  late IO.Socket socket;
  
  @override
  void initState() {
     try{
      print("test");
      socket = IO.io('http://10.0.2.2:4320', <String, dynamic>{
          'transports': ['websocket'],
          'autoConnect': false,
        });

      socket.connect();

      socket.emit('fetchOldMessages', UserChat(
                                        userId: widget.userId,
                                        userTo: widget.userTo,
                                        message: '',
                                        statu: widget.statu,
                                        //widget.username
                                       ).toJson());

      socket.on("fetchMessages", (data) {
          var c = data.length;
          print(c);
          
          for(int i = 0; i < c; i++){
          var oldMessages = UserChat.fromJson(data[i]);
          print(oldMessages.message);
          setStateIfMounted(() {
            _messages.add(oldMessages);
          });
          //print(oldMessages.message);
          }
        });

      socket.on("thread", (data) {
         var userMessage = UserChat.fromJson(data);
         print(userMessage);
         if(userMessage.statu == "HASTA"){
            if(userMessage.userTo == widget.userId && userMessage.userId == widget.userTo && widget.statu == "DOKTOR"){
          
           setStateIfMounted(() {
            _messages.add(userMessage);
           });
           /* print(userMessage.message); */
         } else if (userMessage.userTo == widget.userTo && userMessage.userId == widget.userId && widget.statu == "HASTA") {
        
             setStateIfMounted(() {
            _messages.add(userMessage);
           });
          }
         } 
         else {
           if(userMessage.userTo == widget.userId && userMessage.userId == widget.userTo && widget.statu == "HASTA"){
          
           setStateIfMounted(() {
            _messages.add(userMessage);
           });
           /* print(userMessage.message); */
         } else if (userMessage.userTo == widget.userTo && userMessage.userId == widget.userId && widget.statu == "DOKTOR") {
        
             setStateIfMounted(() {
            _messages.add(userMessage);
           });
          }
         }
         
      }); 

    } 
    catch (e) {
      print(e);
    }
 
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.userId);
    print(widget.userTo);
    print(widget.usernameMe);
    print(widget.usernameTo);
    print(widget.statu);

     Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(widget.usernameTo),
          backgroundColor: const Color(0xFF971160)),
      body: SafeArea(
        child: Container(
          color: const Color(0xFFEAEFF2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Flexible(
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    reverse: _messages.isEmpty ? false : true,
                    itemCount: 1,
                    shrinkWrap: false,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: 3),
                        child: Column(
                          mainAxisAlignment: _messages.isEmpty
                              ? MainAxisAlignment.center
                              : MainAxisAlignment.start,
                          children: <Widget>[
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: _messages.map((message) {
                                  //print(message);
                                  return ChatBubble(                  
                                    message: message.message,
                                    isMe: message.userId == widget.userId,
                                  );
                                }).toList()),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.only(
                    bottom: 10, left: 20, right: 10, top: 5),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: Container(
                        child: TextField(
                          minLines: 1,
                          maxLines: 5,
                          controller: _messageController,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: const InputDecoration.collapsed(
                            hintText: "Mesajınızı giriniz",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 43,
                      width: 42,
                      child: FloatingActionButton(
                        backgroundColor: const Color(0xFF271160),
                        onPressed: () async {
                          if (_messageController.text.trim().isNotEmpty) {
                            String message = _messageController.text.trim();
                            print("test");

                            socket.emit(
                                "messages",
                                UserChat(
                                        userId: widget.userId,
                                        userTo: widget.userTo,
                                        message: message,
                                        statu: widget.statu,
                                       )
                                    .toJson());

                            _messageController.clear();
                          }
                        },
                        mini: true,
                        child: Transform.rotate(
                            angle: 5.79449,
                            child: const Icon(Icons.send, size: 20)),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}



class ChatBubble extends StatelessWidget {
  final bool isMe;
  final String message;

  ChatBubble({
    Key? key,
    required this.message,
    this.isMe = true,
  });
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Column(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            margin: const EdgeInsets.symmetric(vertical: 5.0),
            constraints: BoxConstraints(maxWidth: size.width * .5),
            decoration: BoxDecoration(
              color: isMe ? const Color(0xFFE3D8FF) : const Color(0xFFFFFFFF),
              borderRadius: isMe
                  ? const BorderRadius.only(
                      topRight: Radius.circular(11),
                      topLeft: Radius.circular(11),
                      bottomRight: Radius.circular(0),
                      bottomLeft: Radius.circular(11),
                    )
                  : const BorderRadius.only(
                      topRight: Radius.circular(11),
                      topLeft: Radius.circular(11),
                      bottomRight: Radius.circular(11),
                      bottomLeft: Radius.circular(0),
                    ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  message,
                  textAlign: TextAlign.start,
                  softWrap: true,
                  style:
                      const TextStyle(color: Color(0xFF2E1963), fontSize: 14),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 7),
                    /* child: Text("Kimden: " +
                      username,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                          color: Color(0xFF594097), fontSize: 12),
                    ), */
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}