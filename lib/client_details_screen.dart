import 'package:flutter/material.dart';

class ClientDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> client;
  const ClientDetailsScreen({required this.client});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // خلفية فاتحة لطيفة
      appBar: AppBar(title: Text(client['name']), backgroundColor: Colors.teal),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.teal,
              child: Text(
                client['name'][0].toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            margin: EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'البريد الإلكتروني',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(client['email'], style: TextStyle(fontSize: 15)),
                  Divider(height: 20, thickness: 1),
                  Text(
                    'الهاتف',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(client['phone'], style: TextStyle(fontSize: 15)),
                  Divider(height: 20, thickness: 1),
                  Text(
                    'تاريخ الانضمام',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(client['joinDate'], style: TextStyle(fontSize: 15)),
                  Divider(height: 20, thickness: 1),
                  Text(
                    'الحالة',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(client['status'], style: TextStyle(fontSize: 15)),
                ],
              ),
            ),
          ),

          // المواضيع المشترك فيها
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            margin: EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'المواضيع المشترك فيها',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  ...client['subscribedTopics'].map<Widget>(
                    (topic) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 2),
                      child: Text('- $topic', style: TextStyle(fontSize: 15)),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // الإحصائيات
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            margin: EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'إحصائيات العميل',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'عدد المحتويات التي شاهدها: ${client['contentViewed']}',
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'عدد الأسئلة: ${client['questionsAsked']}',
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'آخر سؤال: ${client['lastQuestion']}',
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
