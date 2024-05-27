import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart' as http;
import 'package:web/screens/homeScreen.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class CommandLineScreen extends StatefulWidget {
  static String router = "commandLine";
  const CommandLineScreen({super.key});

  @override
  State<CommandLineScreen> createState() => _CommandLineScreenState();
}

class _CommandLineScreenState extends State<CommandLineScreen> {
  final channel = WebSocketChannel.connect(Uri.parse('ws://localhost:1300'));
    // final channel = IOWebSocketChannel.connect('ws://192.168.1.46:1300');

  TextEditingController _commandController = TextEditingController();
  TextEditingController _numBotsController = TextEditingController();
  TextEditingController _outputController = TextEditingController();

   @override
  void initState() {
    super.initState();
    channel.stream.listen((data) {
      // Handle incoming data from the Node.js server here
     _outputController.text = _outputController.text + data;
    });
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
          margin: EdgeInsets.only(top: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(children: [
                  OutlinedButton(onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context, HomeScreen.router, (route) => false);
                  }, child: Icon(Icons.arrow_back)),
                ],),
                SizedBox(height: 100,),
                Container(
                  color: Colors.black,
                  // elevation: 4,
                  // shape:
                  //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(children: [
                      Text(
                        "Command Form",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      TextField(
                        controller: _commandController,
                        decoration: InputDecoration(labelText: "Command :"),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextField(
                        controller: _numBotsController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: "Number of Bots:"),
                
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          _outputController.text = "";
                          String command = "stream::" + _commandController.text;
                          int botsNum = int.tryParse(_numBotsController.text) ?? 0;
                
                          if (command != "" && botsNum != 0 && botsNum < 11) {
                            try {
                            final response1 = await http.get(
                                Uri.parse("http://localhost:8080/api/s/clients"));
                            List connectedBots = json.decode(response1.body);
                            int i = 0;
                            for (var botId in connectedBots) {
                              i += 1;
                              final response2 = await http.get(Uri.parse(
                                  "http://localhost:8080/stream_command?command=$command&id=$botId"));
                              // response2.body
                
                              _outputController.text = _outputController.text +
                                                            """
                                          ~~~~~~~~~~~~~~~~~~~~~~~ Device $i ~~~~~~~~~~~~~~~~~~~~~~~
                                          
                                          ${response2.body} 
                                          
                                          ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                
                                          """;
                            }
                          } catch (err) {
                            _outputController.text = err.toString();
                          }
                          } else {
                            _outputController.text = "Number of bot should be between 1 and 10";
                          }
                        },
                        child: Text("Send command"),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextField(
                        controller: _outputController,
                        readOnly: true,
                        maxLines: null,
                        decoration: InputDecoration(border: OutlineInputBorder()),
                                          style: TextStyle(color: Colors.green),
                
                      )
                    ]),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
