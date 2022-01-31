import 'package:flutter/material.dart';
import 'package:kbg/screens/clients_chats_screen.dart';
import 'package:kbg/screens/engineers_chats_screen.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              bottom: const TabBar(
                labelColor: Colors.black,
                indicatorColor: Colors.amberAccent,
                indicatorSize: TabBarIndicatorSize.label,
                tabs: [
                  Tab(
                    text: 'Clients',
                  ),
                  Tab(
                    text: 'Engineers',
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: [ClientsChatsScreen(), EngineersChatsScreen()],
            )));
  }
}
