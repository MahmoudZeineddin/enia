import 'package:enia/client_details_screen.dart';
import 'package:enia/topic_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class DoctorDashboardScreen extends StatefulWidget {
  @override
  _DoctorDashboardScreenState createState() => _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState extends State<DoctorDashboardScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  int _currentIndex = 0;
  // قائمة الوسائط المرفوعة
  List<File> _mediaFiles = [];
  List<XFile> selectedMedia = []; // للصور والفيديو
  List<PlatformFile> selectedFiles = []; // للملفات الأخرى (إنفوجرافيك)

  final _topicFormKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  IconData _selectedIcon = Icons.topic;

  final List<Map<String, dynamic>> dashboardStats = [
    {
      'title': 'إجمالي العملاء',
      'count': '6',
      'color': Colors.teal,
      'icon': Icons.people,
    },
    {
      'title': 'إجمالي المواضيع',
      'count': '3',
      'color': Colors.blue,
      'icon': Icons.topic,
    },
    {
      'title': 'العمليات النشطة',
      'count': '5',
      'color': Colors.orange,
      'icon': Icons.trending_up,
    },
    {
      'title': 'إجمالي المشاهدات',
      'count': '4652',
      'color': Colors.purple,
      'icon': Icons.visibility,
    },
  ];

  final List<Map<String, dynamic>> activeClients = [
    {
      'id': 1,
      'name': 'أحمد محمد علي',
      'lastActive': 'آخر نشاط منذ 10 دقائق',
      'avatar': 'assets/avatar1.png',
      'email': 'ahmed.ali@email.com',
      'phone': '+970591234567',
      'joinDate': '2024-01-15',
      'status': 'نشط',
      'subscribedTopics': ['إدارة الألم', 'التغذية الصحية'],
      'contentViewed': 15,
      'questionsAsked': 3,
      'lastQuestion': 'كيف يمكنني تخفيف آلام الظهر؟',
    },
    {
      'id': 2,
      'name': 'فاطمة سالم أحمد',
      'lastActive': 'آخر نشاط منذ ساعة',
      'avatar': 'assets/avatar2.png',
      'email': 'fatima.salem@email.com',
      'phone': '+970591234568',
      'joinDate': '2024-02-10',
      'status': 'نشط',
      'subscribedTopics': ['الصحة النفسية', 'التغذية الصحية'],
      'contentViewed': 22,
      'questionsAsked': 5,
      'lastQuestion': 'ما هي أفضل الأطعمة للصحة النفسية؟',
    },
    {
      'id': 3,
      'name': 'عمر خالد محمود',
      'lastActive': 'آخر نشاط منذ 3 ساعات',
      'avatar': 'assets/avatar3.png',
      'email': 'omar.khaled@email.com',
      'phone': '+970591234569',
      'joinDate': '2024-01-20',
      'status': 'متوسط النشاط',
      'subscribedTopics': ['إدارة الألم'],
      'contentViewed': 8,
      'questionsAsked': 1,
      'lastQuestion': 'هل يمكن استخدام العلاج الطبيعي للألم؟',
    },
    {
      'id': 4,
      'name': 'محمد حسن إبراهيم',
      'lastActive': 'آخر نشاط منذ 4 ساعات',
      'avatar': 'assets/avatar4.png',
      'email': 'mohamed.hassan@email.com',
      'phone': '+970591234570',
      'joinDate': '2024-03-05',
      'status': 'متوسط النشاط',
      'subscribedTopics': ['الصحة النفسية', 'إدارة الألم'],
      'contentViewed': 12,
      'questionsAsked': 2,
      'lastQuestion': 'كيف أتعامل مع التوتر اليومي؟',
    },
    {
      'id': 5,
      'name': 'سارة أحمد علي',
      'lastActive': 'آخر نشاط منذ 30 دقيقة',
      'avatar': 'assets/avatar5.png',
      'email': 'sarah.ahmed@email.com',
      'phone': '+970591234571',
      'joinDate': '2024-02-28',
      'status': 'نشط',
      'subscribedTopics': ['التغذية الصحية', 'الصحة النفسية'],
      'contentViewed': 18,
      'questionsAsked': 4,
      'lastQuestion': 'ما هي الفيتامينات الأساسية للمرأة؟',
    },
  ];

  final List<Map<String, dynamic>> topics = [
    {
      'id': 1,
      'title': 'إدارة الألم',
      'description': 'تعلم كيفية إدارة الألم والتعامل معه بطرق طبيعية وفعالة',
      'participants': 245,
      'views': 1520,
      'icon': Icons.healing,
      'isActive': true,
      'createdDate': '2024-01-01',
    },
    {
      'id': 2,
      'title': 'التغذية الصحية',
      'description': 'نصائح وإرشادات للحصول على تغذية متوازنة ومناسبة',
      'participants': 189,
      'views': 987,
      'icon': Icons.restaurant,
      'isActive': true,
      'createdDate': '2024-01-15',
    },
    {
      'id': 3,
      'title': 'الصحة النفسية',
      'description': 'الاهتمام بالصحة النفسية والعاطفية والتعامل مع التوتر',
      'participants': 312,
      'views': 2145,
      'icon': Icons.psychology,
      'isActive': true,
      'createdDate': '2024-02-01',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 0);
    _tabController!.addListener(() {
      setState(() {
        _currentIndex = _tabController!.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              _buildTabBar(context),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildOverviewTab(context),
                    _buildTopicsTab(context),
                    _buildQuestionsTab(context),
                    _buildClientsTab(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'لوحة التحكم الطبية',
                  style: TextStyle(
                    fontSize: isTablet ? 28 : 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  _showAddTopicDialog(context);
                },
                icon: Icon(Icons.add, color: Colors.white),
                label: Text(
                  isTablet ? 'إضافة موضوع جديد' : 'موضوع جديد',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 20 : 16,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
          if (isTablet) ...[
            SizedBox(height: 16),
            Text(
              'إدارة شاملة للمحتوى الطبي والعملاء',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(text: 'نظرة عامة'),
          Tab(text: 'المواضيع'),
          Tab(text: 'الأسئلة'),
          Tab(text: 'العملاء'),
        ],
        labelColor: Colors.teal,
        unselectedLabelColor: Colors.grey,
        indicatorColor: Colors.teal,
        labelStyle: TextStyle(
          fontSize: screenWidth * 0.045, // أكبر شوي
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: TextStyle(fontSize: screenWidth * 0.04),
      ),
    );
  }

  Widget _buildOverviewTab(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth > 800 ? 4 : 2;

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
            ),
            itemCount: dashboardStats.length,
            itemBuilder: (context, index) {
              final stat = dashboardStats[index];
              return Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      stat['count'],
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: stat['color'],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      stat['title'],
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(Map<String, dynamic> stat, bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: stat['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              stat['icon'],
              color: stat['color'],
              size: isTablet ? 32 : 28,
            ),
          ),
          SizedBox(height: 12),
          Text(
            stat['count'],
            style: TextStyle(
              fontSize: isTablet ? 32 : 28,
              fontWeight: FontWeight.bold,
              color: stat['color'],
            ),
          ),
          SizedBox(height: 8),
          Text(
            stat['title'],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isTablet ? 16 : 14,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionsTab(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final TextEditingController _replyController = TextEditingController();

    // بيانات أسئلة تجريبية (لاحقًا من Firebase)
    final List<Map<String, dynamic>> questions = [
      {
        'patientName': 'خالد',
        'question': 'ما هي أعراض القلق النفسي؟',
        'date': '12/09/2025 - 10:30م',
        'answers': [
          {
            'doctorName': 'د. أحمد',
            'text': 'الأرق',
            'date': '12/09/2025 - 10:45م',
          },
          {
            'doctorName': 'د. أحمد',
            'text': 'التوتر المستمر',
            'date': '12/09/2025 - 10:50م',
          },
        ],
      },
      {
        'patientName': 'محمود',
        'question': 'كيف أتعامل مع قلة النوم؟',
        'date': '12/09/2025 - 11:00م',
        'answers': [],
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: questions.length,
      itemBuilder: (context, index) {
        final q = questions[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // السؤال (مريض)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                textDirection: TextDirection.rtl,
                children: [
                  CircleAvatar(
                    radius: screenWidth * 0.05,
                    backgroundColor: Colors.teal,
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          q['patientName'],
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            q['question'],
                            style: TextStyle(
                              fontSize: screenWidth * 0.043,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          q['date'],
                          style: TextStyle(
                            fontSize: screenWidth * 0.032,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // الإجابات (أطباء)
              if (q['answers'].isNotEmpty)
                Column(
                  children: q['answers'].map<Widget>((ans) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        textDirection: TextDirection.ltr, // طبيب يسار
                        children: [
                          CircleAvatar(
                            radius: screenWidth * 0.05,
                            backgroundColor: Colors.blue,
                            child: const Icon(
                              Icons.medical_services,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ans['doctorName'],
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.04,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    ans['text'],
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.04,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  ans['date'],
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.032,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                )
              else
                Padding(
                  padding: const EdgeInsets.only(right: 48),
                  child: Text(
                    'لا توجد إجابات بعد.',
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: Colors.grey,
                    ),
                  ),
                ),

              const SizedBox(height: 12),

              // إدخال الرد (لوحة مفاتيح + زر إرسال)
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _replyController,
                      decoration: InputDecoration(
                        hintText: "اكتب ردك هنا...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.teal),
                    onPressed: () {
                      if (_replyController.text.trim().isNotEmpty) {
                        // هنا يتم إضافة الرد للطبيب
                        // TODO: ربط مع Firebase
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("تم إرسال الرد")),
                        );
                        _replyController.clear();
                      }
                    },
                  ),
                ],
              ),

              // زر الحذف
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () {
                    // TODO: حذف السؤال من Firebase
                  },
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text(
                    "حذف",
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActiveClientsSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'العملاء النشطين مؤخراً',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              TextButton(
                onPressed: () {
                  _tabController!.animateTo(2);
                },
                child: Text('عرض الكل'),
              ),
            ],
          ),
          SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: activeClients.take(3).length,
            itemBuilder: (context, index) {
              return _buildClientListItem(activeClients[index], context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildClientListItem(
    Map<String, dynamic> client,
    BuildContext context,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () {
          // _navigateToClientProfile(client, context);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.teal,
                child: Text(
                  client['name'][0],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      client['name'],
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      client['lastActive'],
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: client['status'] == 'نشط'
                      ? Colors.green
                      : Colors.orange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  client['status'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopicsTab(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;
        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'إدارة المواضيع',
                style: TextStyle(
                  fontSize: isTablet ? 24 : 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              SizedBox(height: 16),
              isTablet ? _buildTopicsGrid() : _buildTopicsList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTopicsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: topics.length,
      itemBuilder: (context, index) {
        return _buildTopicCard(topics[index]);
      },
    );
  }

  Widget _buildTopicsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: topics.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: _buildTopicCard(topics[index]),
        );
      },
    );
  }

  // Widget _buildTopicCard(Map<String, dynamic> topic) {
  //   return Container(
  //     padding: EdgeInsets.all(20),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(16),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.grey.withOpacity(0.1),
  //           spreadRadius: 1,
  //           blurRadius: 8,
  //           offset: Offset(0, 4),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           children: [
  //             Container(
  //               padding: EdgeInsets.all(12),
  //               decoration: BoxDecoration(
  //                 color: Colors.teal.withOpacity(0.1),
  //                 borderRadius: BorderRadius.circular(12),
  //               ),
  //               child: Icon(topic['icon'], color: Colors.teal, size: 28),
  //             ),
  //             Spacer(),
  //             Container(
  //               padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  //               decoration: BoxDecoration(
  //                 color: topic['isActive'] ? Colors.green : Colors.grey,
  //                 borderRadius: BorderRadius.circular(20),
  //               ),
  //               child: Text(
  //                 topic['isActive'] ? 'نشط' : 'غير نشط',
  //                 style: TextStyle(
  //                   color: Colors.white,
  //                   fontSize: 12,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //         SizedBox(height: 16),
  //         Text(
  //           topic['title'],
  //           style: TextStyle(
  //             fontSize: 20,
  //             fontWeight: FontWeight.bold,
  //             color: Colors.teal,
  //           ),
  //         ),
  //         SizedBox(height: 8),
  //         Text(
  //           topic['description'],
  //           style: TextStyle(
  //             color: Colors.grey[600],
  //             fontSize: 14,
  //             height: 1.5,
  //           ),
  //           maxLines: 3,
  //           overflow: TextOverflow.ellipsis,
  //         ),
  //         SizedBox(height: 16),
  //         Row(
  //           children: [
  //             Icon(Icons.people, color: Colors.grey[500], size: 16),
  //             SizedBox(width: 4),
  //             Text(
  //               '${topic['participants']} مشترك',
  //               style: TextStyle(fontSize: 12, color: Colors.grey[600]),
  //             ),
  //             SizedBox(width: 16),
  //             Icon(Icons.visibility, color: Colors.grey[500], size: 16),
  //             SizedBox(width: 4),
  //             Text(
  //               '${topic['views']} مشاهدة',
  //               style: TextStyle(fontSize: 12, color: Colors.grey[600]),
  //             ),
  //           ],
  //         ),
  //         SizedBox(height: 20),
  //         Wrap(
  //           spacing: 8,
  //           runSpacing: 8,
  //           children: [
  //             _buildActionButton(
  //               label: 'إضافة محتوى',
  //               icon: Icons.add,
  //               color: Colors.teal,
  //               onPressed: () {},
  //             ),
  //             _buildActionButton(
  //               label: 'تعديل',
  //               icon: Icons.edit,
  //               color: Colors.blue,
  //               onPressed: () {},
  //             ),
  //             _buildActionButton(
  //               label: 'إخفاء',
  //               icon: Icons.visibility_off,
  //               color: Colors.orange,
  //               onPressed: () {},
  //             ),
  //             _buildActionButton(
  //               label: 'حذف',
  //               icon: Icons.delete,
  //               color: Colors.red,
  //               onPressed: () {},
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildTopicCard(Map<String, dynamic> topic) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TopicDetailsScreen(topic: topic),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.teal.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(topic['icon'], color: Colors.teal, size: 28),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: topic['isActive'] ? Colors.green : Colors.grey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    topic['isActive'] ? 'نشط' : 'غير نشط',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              topic['title'],
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            SizedBox(height: 8),
            Text(
              topic['description'],
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
                height: 1.5,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: color, size: 16),
      label: Text(label, style: TextStyle(color: color, fontSize: 12)),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        minimumSize: Size(0, 32),
      ),
    );
  }

  Widget _buildClientsTab(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;

        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'قائمة العملاء',
                    style: TextStyle(
                      fontSize: isTablet ? 24 : 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  Text(
                    '${activeClients.length} عميل',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // البحث والتصفية
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'البحث عن عميل...',
                          prefixIcon: Icon(Icons.search, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.filter_list, color: Colors.teal),
                      label: Text(
                        'تصفية',
                        style: TextStyle(color: Colors.teal),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.teal),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16),

              // قائمة العملاء
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: activeClients.length,
                itemBuilder: (context, index) {
                  final client = activeClients[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onTap: () {
                        // افتح صفحة تفاصيل العميل
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ClientDetailsScreen(client: client),
                          ),
                        );
                      },
                      child: _buildClientCard(client, context),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildClientCard(Map<String, dynamic> client, context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.teal,
            child: Text(
              client['name'][0],
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  client['name'],
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  client['email'],
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                SizedBox(height: 4),
                Text(
                  client['phone'],
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                SizedBox(height: 4),
                Text(
                  'آخر سؤال: ${client['lastQuestion']}',
                  style: TextStyle(color: Colors.grey[800], fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: client['status'] == 'نشط'
                  ? Colors.green
                  : Colors.orangeAccent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              client['status'],
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }

  _showAddTopicDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text(
            'إضافة موضوع جديد',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
          ),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Form(
              key: _topicFormKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'عنوان الموضوع',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال عنوان الموضوع';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: 'وصف الموضوع',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال وصف الموضوع';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 12),
                    Text('اختر أيقونة الموضوع:'),
                    Wrap(
                      spacing: 8,
                      children: [
                        _iconChoice(Icons.healing),
                        _iconChoice(Icons.restaurant),
                        _iconChoice(Icons.psychology),
                        _iconChoice(Icons.fitness_center),
                        _iconChoice(Icons.medical_services),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text('رفع وسائط:'),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: _pickMedia,
                          icon: Icon(Icons.image),
                          label: Text('صور/فيديو'),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: _pickFiles,
                          icon: Icon(Icons.file_present),
                          label: Text('ملفات أخرى'),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    if (_mediaFiles.isNotEmpty)
                      Text('${_mediaFiles.length} وسائط مرفوعة'),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_topicFormKey.currentState!.validate()) {
                  setState(() {
                    topics.add({
                      'id': topics.length + 1,
                      'title': _titleController.text,
                      'description': _descriptionController.text,
                      'participants': 0,
                      'views': 0,
                      'icon': _selectedIcon,
                      'isActive': true,
                      'createdDate': DateTime.now().toString().split(' ')[0],
                    });
                    _titleController.clear();
                    _descriptionController.clear();
                    _mediaFiles.clear();
                  });
                  Navigator.pop(context);
                }
              },
              child: Text('حفظ'),
            ),
          ],
        ),
      ),
    );
  } // دالة لإضافة الموضوع الجديد

  void _addNewTopic() {
    final newTopic = {
      'id': topics.length + 1,
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
      'participants': 0,
      'views': 0,
      'icon': _selectedIcon,
      'isActive': true,
      'createdDate': DateTime.now().toString().split(' ')[0],
    };

    setState(() {
      topics.add(newTopic);
      // تحديث إحصائية إجمالي المواضيع
      dashboardStats[1]['count'] = topics.length.toString();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم إضافة الموضوع بنجاح'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _clearForm() {
    _titleController.clear();
    _descriptionController.clear();
    _selectedIcon = Icons.topic;
  }

  // اختيار الأيقونة
  Widget _iconChoice(IconData icon) {
    final isSelected = _selectedIcon == icon;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIcon = icon;
        });
      },
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.teal : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: isSelected ? Colors.white : Colors.black54),
      ),
    );
  }

  // اختيار وسائط (صور/فيديو)
  Future<void> _pickMedia() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? picked = await picker.pickMultiImage();
    if (picked != null) {
      setState(() {
        selectedMedia.addAll(picked);
        _mediaFiles.addAll(picked.map((e) => File(e.path)));
      });
    }
  }

  // اختيار ملفات إنفوجرافيك أو PDF
  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      setState(() {
        selectedFiles.addAll(result.files);
        _mediaFiles.addAll(result.files.map((e) => File(e.path!)));
      });
    }
  }
}
