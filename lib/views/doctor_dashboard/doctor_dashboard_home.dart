import 'package:flutter/material.dart';
import 'notification_page.dart';

class DoctorDashboardHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationPage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Text('Welcome to the Doctor Dashboard'),
      ),
    );
  }
}