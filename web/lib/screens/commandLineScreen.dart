import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart' as http;
import 'package:web/screens/homeScreen.dart';
import 'package:web/widgets/MainScreenWidget.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class CommandLineScreen extends StatefulWidget {
  static String router = "commandLine";
  const CommandLineScreen({super.key});

  @override
  State<CommandLineScreen> createState() => _CommandLineScreenState();
}

class _CommandLineScreenState extends State<CommandLineScreen> {
  WebSocketChannel? channel;
  bool _disconnected = true;  // final channel = IOWebSocketChannel.connect('ws://192.168.1.46:1300');

  TextEditingController _commandController = TextEditingController();
  TextEditingController _numBotsController = TextEditingController();
  TextEditingController _outputController = TextEditingController();

     void connectTowebsocket() async {

    try {

    
    channel = WebSocketChannel.connect(Uri.parse('ws://localhost:1300'));

  
      
      channel!.stream.listen((data) {
        if (data == "Connected#0&") {
          setState(() {
            _disconnected = false;
          });
        } else {
        setState(() {
          _outputController.text = _outputController.text + data;
        });

        }
      }, 
    
      onDone: () {
        print("the connection done > try to reconnect");
        handelDisconnection();
      }, onError: (error) {
        print("error in connection > try to reconnect");
        handelDisconnection();
      });
    } catch (err) {
      print(err);
      handelDisconnection();
    }
   

  }

  void handelDisconnection() {
      setState(() {
        _disconnected = true; // We are now disconnected
      });

      Future.delayed(Duration(milliseconds: 5000), () {
        if (_disconnected) {
          connectTowebsocket();
        }
      });
    
  }


  @override
  void initState() {
    super.initState();
    connectTowebsocket();

  }

  @override
  void dispose() {
    channel?.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainScreenWidget(body: [
      SizedBox(
        height: 100,
      ),
      Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 800), // Set the max width here
          child: Container(
            color: Colors.black,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Command Form ☄️",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Container(
                  margin: EdgeInsets.all(20),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: _disconnected
                        ? 
                            Text(
                                "The website is not connected to the commander server ❌")
                          
                        : Text(
                            "The website is connected to the commander server ✅"),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: _disconnected ? Colors.red : Colors.green),
                ),
                  SizedBox(height: 16),
                  TextField(
                    minLines: 3, // Set this
  maxLines: 20, // and this
  
                    controller: _commandController,
                    decoration: InputDecoration(labelText: "Command :",),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _numBotsController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: "Number of Bots:"),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      _outputController.text = "";

                      String command = Uri.encodeQueryComponent(
                          "stream::" + _commandController.text);
                      int botsNum = int.tryParse(_numBotsController.text) ?? 0;

                      if (command != "" && botsNum != 0 && botsNum < 11) {
                        try {
                          final response1 = await http.get(
                              Uri.parse("http://localhost:8080/api/s/clients"));
                          List connectedBots = json.decode(response1.body);
                          print(connectedBots);
                          int i = 0;

                          for (var botId in connectedBots) {
                            i += 1;

                            final response2 = await http.get(Uri.parse(
                                "http://localhost:8080/stream_command?command=$command&id=$botId"));
                            // response2.body

                            // _outputController.text = _outputController.text +
                            //                               """
                            //             ~~~~~~~~~~~~~~~~~~~~~~~ Device $i ~~~~~~~~~~~~~~~~~~~~~~~

                            //             ${response2.body}

                            //             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

                            //             """;
                          }

                          await Future.delayed(Duration(
                              milliseconds: 100)); // Adjust delay as needed
                        } catch (err) {
                          _outputController.text = err.toString();
                        }
                      } else {
                        _outputController.text =
                            "Number of bots should be between 1 and 10";
                      }
                    },
                    child: Text("Send command"),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            padding: EdgeInsets.all(10),
            color: Colors.black,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("The Result Here 👇",  style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.green ),),
                SizedBox(height: 10,),
                TextField(
                  
                            controller: _outputController,
                            readOnly: true,
                            maxLines: null,
                            decoration:
                                const InputDecoration(border: OutlineInputBorder()),
                            style: TextStyle(color: Colors.green),
                          ),
              ],
            ),
          ),
        )
    ]);
  }
}
