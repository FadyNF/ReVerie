import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: ListView(
        children: const [
          ListTile(
            title: Text('Notification 1'),
            subtitle: Text('This is a dummy notification.'),
          ),
          ListTile(
            title: Text('Notification 2'),
            subtitle: Text('This is another dummy notification.'),
          ),
        ],
      ),
    );
  }
}
