import 'package:flutter/material.dart';

class TopicDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> topic;

  const TopicDetailsScreen({Key? key, required this.topic}) : super(key: key);

  @override
  _TopicDetailsScreenState createState() => _TopicDetailsScreenState();
}

class _TopicDetailsScreenState extends State<TopicDetailsScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  // متغيرات الفورم لإضافة المحتوى
  final _contentFormKey = GlobalKey<FormState>();
  final _contentTitleController = TextEditingController();
  final _contentTextController = TextEditingController();
  String _selectedContentType = 'text';

  // متغير لفورم إرسال الإشعارات
  final _notificationController = TextEditingController();

  // بيانات المحتوى التجريبية - ستأتي لاحقاً من Firebase
  List<Map<String, dynamic>> contentItems = [
    {
      'id': 1,
      'title': 'مقدمة عن إدارة الألم',
      'type': 'text',
      'content':
          'إدارة الألم هي عملية طبية متكاملة تهدف إلى تخفيف المعاناة وتحسين جودة الحياة للمرضى الذين يعانون من الألم المزمن أو الحاد. تشمل إدارة الألم مجموعة واسعة من التقنيات والعلاجات التي تهدف إلى:\n\n1. تقليل شدة الألم\n2. تحسين الوظائف اليومية\n3. تعزيز الصحة النفسية\n4. توفير استراتيجيات للتعامل مع الألم المزمن\n\nيمكن أن يشمل العلاج الأدوية، العلاج الطبيعي، التقنيات النفسية، والطرق البديلة.',
      'createdDate': '2024-01-15',
      'views': 245,
      'isVisible': true,
    },
    {
      'id': 2,
      'title': 'تقنيات التنفس لتخفيف الألم',
      'type': 'video',
      'content': 'https://example.com/breathing-techniques-video',
      'thumbnailUrl': 'assets/video_thumbnail1.png',
      'duration': '15:30',
      'description':
          'تعلم تقنيات التنفس العميق والاسترخاء للمساعدة في تخفيف الألم المزمن',
      'createdDate': '2024-01-20',
      'views': 189,
      'isVisible': true,
    },
    {
      'id': 3,
      'title': 'أنواع الألم المختلفة',
      'type': 'infographic',
      'content': 'assets/pain_types_infographic.png',
      'description': 'إنفوغرافيك يوضح الأنواع المختلفة للألم وخصائص كل نوع',
      'createdDate': '2024-01-25',
      'views': 312,
      'isVisible': true,
    },
  ];

  // إحصائيات المتابعين التجريبية
  List<Map<String, dynamic>> subscribers = [
    {'name': 'أحمد محمد', 'joinDate': '2024-01-10', 'lastActive': '2024-01-30'},
    {
      'name': 'فاطمة سالم',
      'joinDate': '2024-01-15',
      'lastActive': '2024-01-29',
    },
    {'name': 'عمر خالد', 'joinDate': '2024-01-20', 'lastActive': '2024-01-28'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _contentTitleController.dispose();
    _contentTextController.dispose();
    _notificationController.dispose();
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
              _buildTopicInfo(context),
              _buildTabBar(context),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildContentTab(context),
                    _buildSubscribersTab(context),
                    _buildStatisticsTab(context),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddContentDialog(context),
          backgroundColor: Colors.teal,
          child: Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back, color: Colors.teal),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'تفاصيل الموضوع',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'edit':
                  _showEditTopicDialog(context);
                  break;
                case 'hide':
                  _toggleTopicVisibility();
                  break;
                case 'delete':
                  _showDeleteTopicDialog(context);
                  break;
                case 'notify':
                  _showNotificationDialog(context);
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'edit', child: Text('تعديل الموضوع')),
              PopupMenuItem(
                value: 'hide',
                child: Text(widget.topic['isActive'] ? 'إخفاء' : 'إظهار'),
              ),
              PopupMenuItem(value: 'delete', child: Text('حذف الموضوع')),
              PopupMenuItem(value: 'notify', child: Text('إرسال إشعار')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopicInfo(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(16),
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
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(widget.topic['icon'], color: Colors.teal, size: 32),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.topic['title'],
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: widget.topic['isActive']
                            ? Colors.green
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        widget.topic['isActive'] ? 'نشط' : 'غير نشط',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            widget.topic['description'],
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              _buildInfoChip(
                Icons.people,
                '${widget.topic['participants']} مشترك',
              ),
              SizedBox(width: 16),
              _buildInfoChip(
                Icons.visibility,
                '${widget.topic['views']} مشاهدة',
              ),
              SizedBox(width: 16),
              _buildInfoChip(Icons.article, '${contentItems.length} محتوى'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          SizedBox(width: 4),
          Text(text, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        tabs: [
          Tab(text: 'المحتوى'),
          Tab(text: 'المشتركين'),
          Tab(text: 'الإحصائيات'),
        ],
        labelColor: Colors.teal,
        unselectedLabelColor: Colors.grey,
        indicatorColor: Colors.teal,
      ),
    );
  }

  Widget _buildContentTab(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: contentItems.where((item) => item['isVisible']).length,
      itemBuilder: (context, index) {
        final visibleItems = contentItems
            .where((item) => item['isVisible'])
            .toList();
        final content = visibleItems[index];
        return _buildContentCard(content);
      },
    );
  }

  Widget _buildContentCard(Map<String, dynamic> content) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _getContentTypeIcon(content['type']),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  content['title'],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) => _handleContentAction(value, content),
                itemBuilder: (context) => [
                  PopupMenuItem(value: 'edit', child: Text('تعديل')),
                  PopupMenuItem(value: 'hide', child: Text('إخفاء')),
                  PopupMenuItem(value: 'delete', child: Text('حذف')),
                ],
              ),
            ],
          ),
          SizedBox(height: 12),
          _buildContentPreview(content),
          SizedBox(height: 12),
          Row(
            children: [
              Text(
                'تاريخ الإنشاء: ${content['createdDate']}',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Spacer(),
              Text(
                '${content['views']} مشاهدة',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getContentTypeIcon(String type) {
    switch (type) {
      case 'video':
        return Icon(Icons.play_circle, color: Colors.red, size: 24);
      case 'infographic':
        return Icon(Icons.image, color: Colors.blue, size: 24);
      default:
        return Icon(Icons.article, color: Colors.green, size: 24);
    }
  }

  Widget _buildContentPreview(Map<String, dynamic> content) {
    switch (content['type']) {
      case 'video':
        return Container(
          height: 120,
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.play_circle, size: 48, color: Colors.red),
                SizedBox(height: 8),
                Text(content['duration'] ?? '0:00'),
                if (content['description'] != null)
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      content['description'],
                      style: TextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        );
      case 'infographic':
        return Container(
          height: 120,
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image, size: 48, color: Colors.blue),
                SizedBox(height: 8),
                Text('إنفوغرافيك'),
                if (content['description'] != null)
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      content['description'],
                      style: TextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        );
      default:
        return Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            content['content'],
            style: TextStyle(fontSize: 14, height: 1.4),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
        );
    }
  }

  Widget _buildSubscribersTab(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: subscribers.length,
      itemBuilder: (context, index) {
        final subscriber = subscribers[index];
        return Container(
          margin: EdgeInsets.only(bottom: 12),
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
              CircleAvatar(
                backgroundColor: Colors.teal,
                child: Text(
                  subscriber['name'][0],
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subscriber['name'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'انضم في: ${subscriber['joinDate']}',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      'آخر نشاط: ${subscriber['lastActive']}',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  _sendNotificationToSubscriber(subscriber);
                },
                icon: Icon(Icons.notifications, color: Colors.teal),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatisticsTab(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          _buildStatCard(
            'إجمالي المشتركين',
            '${subscribers.length}',
            Icons.people,
            Colors.blue,
          ),
          SizedBox(height: 16),
          _buildStatCard(
            'إجمالي المحتوى',
            '${contentItems.length}',
            Icons.article,
            Colors.green,
          ),
          SizedBox(height: 16),
          _buildStatCard(
            'إجمالي المشاهدات',
            '${contentItems.fold(0, (sum, item) => sum + (item['views'] as int))}',
            Icons.visibility,
            Colors.orange,
          ),
          SizedBox(height: 16),
          _buildStatCard(
            'تاريخ الإنشاء',
            widget.topic['createdDate'],
            Icons.calendar_today,
            Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
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
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==== الوظائف المساعدة ====

  void _showAddContentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text('إضافة محتوى جديد'),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Form(
              key: _contentFormKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // نوع المحتوى
                    DropdownButtonFormField<String>(
                      value: _selectedContentType,
                      decoration: InputDecoration(
                        labelText: 'نوع المحتوى',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem(value: 'text', child: Text('نص')),
                        DropdownMenuItem(value: 'video', child: Text('فيديو')),
                        DropdownMenuItem(
                          value: 'infographic',
                          child: Text('إنفوغرافيك'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedContentType = value!;
                        });
                      },
                    ),
                    SizedBox(height: 16),

                    // عنوان المحتوى
                    TextFormField(
                      controller: _contentTitleController,
                      decoration: InputDecoration(
                        labelText: 'عنوان المحتوى',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال عنوان المحتوى';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    // محتوى النص
                    if (_selectedContentType == 'text')
                      TextFormField(
                        controller: _contentTextController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          labelText: 'المحتوى النصي',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (_selectedContentType == 'text' &&
                              (value == null || value.isEmpty)) {
                            return 'يرجى إدخال المحتوى النصي';
                          }
                          return null;
                        },
                      )
                    else if (_selectedContentType == 'video')
                      TextFormField(
                        controller: _contentTextController,
                        decoration: InputDecoration(
                          labelText: 'رابط الفيديو',
                          border: OutlineInputBorder(),
                          hintText: 'https://example.com/video.mp4',
                        ),
                        validator: (value) {
                          if (_selectedContentType == 'video' &&
                              (value == null || value.isEmpty)) {
                            return 'يرجى إدخال رابط الفيديو';
                          }
                          return null;
                        },
                      )
                    else
                      TextFormField(
                        controller: _contentTextController,
                        decoration: InputDecoration(
                          labelText: 'مسار الصورة',
                          border: OutlineInputBorder(),
                          hintText: 'assets/images/infographic.png',
                        ),
                        validator: (value) {
                          if (_selectedContentType == 'infographic' &&
                              (value == null || value.isEmpty)) {
                            return 'يرجى إدخال مسار الصورة';
                          }
                          return null;
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _clearContentForm();
              },
              child: Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_contentFormKey.currentState!.validate()) {
                  _addNewContent();
                  Navigator.pop(context);
                  _clearContentForm();
                }
              },
              child: Text('إضافة'),
            ),
          ],
        ),
      ),
    );
  }

  void _addNewContent() {
    final newContent = {
      'id': contentItems.length + 1,
      'title': _contentTitleController.text,
      'type': _selectedContentType,
      'content': _contentTextController.text,
      'createdDate': DateTime.now().toString().split(' ')[0],
      'views': 0,
      'isVisible': true,
    };

    setState(() {
      contentItems.add(newContent);
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('تم إضافة المحتوى بنجاح')));
  }

  void _clearContentForm() {
    _contentTitleController.clear();
    _contentTextController.clear();
    _selectedContentType = 'text';
  }

  void _handleContentAction(String action, Map<String, dynamic> content) {
    switch (action) {
      case 'edit':
        _showEditContentDialog(content);
        break;
      case 'hide':
        setState(() {
          content['isVisible'] = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('تم إخفاء المحتوى')));
        break;
      case 'delete':
        _showDeleteContentDialog(content);
        break;
    }
  }

  void _showEditContentDialog(Map<String, dynamic> content) {
    _contentTitleController.text = content['title'];
    _contentTextController.text = content['content'];
    _selectedContentType = content['type'];

    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text('تعديل المحتوى'),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Form(
              key: _contentFormKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _contentTitleController,
                      decoration: InputDecoration(
                        labelText: 'عنوان المحتوى',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _contentTextController,
                      maxLines: _selectedContentType == 'text' ? 5 : 1,
                      decoration: InputDecoration(
                        labelText: _selectedContentType == 'text'
                            ? 'المحتوى النصي'
                            : _selectedContentType == 'video'
                            ? 'رابط الفيديو'
                            : 'مسار الصورة',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  content['title'] = _contentTitleController.text;
                  content['content'] = _contentTextController.text;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('تم تحديث المحتوى')));
              },
              child: Text('حفظ'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteContentDialog(Map<String, dynamic> content) {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text('تأكيد الحذف'),
          content: Text('هل أنت متأكد من حذف هذا المحتوى؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  contentItems.remove(content);
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('تم حذف المحتوى')));
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('حذف', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  // تكملة _showEditTopicDialog من حيث توقف الكود
  void _showEditTopicDialog(BuildContext context) {
    final titleController = TextEditingController(text: widget.topic['title']);
    final descController = TextEditingController(
      text: widget.topic['description'],
    );

    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text('تعديل الموضوع'),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'عنوان الموضوع',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: descController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'وصف الموضوع',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: تحديث بيانات الموضوع في Firebase
                setState(() {
                  widget.topic['title'] = titleController.text;
                  widget.topic['description'] = descController.text;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('تم تحديث الموضوع بنجاح')),
                );
              },
              child: Text('حفظ'),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleTopicVisibility() {
    setState(() {
      widget.topic['isActive'] = !widget.topic['isActive'];
    });

    String message = widget.topic['isActive']
        ? 'تم إظهار الموضوع'
        : 'تم إخفاء الموضوع';
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));

    // TODO: تحديث حالة الموضوع في Firebase
  }

  void _showDeleteTopicDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text('تأكيد حذف الموضوع'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('هل أنت متأكد من حذف هذا الموضوع؟'),
              SizedBox(height: 8),
              Text(
                'سيتم حذف جميع المحتوى والبيانات المرتبطة بهذا الموضوع نهائياً.',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: حذف الموضوع من Firebase
                Navigator.pop(context); // إغلاق dialog
                Navigator.pop(context); // العودة للشاشة السابقة
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('تم حذف الموضوع'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('حذف نهائياً', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _showNotificationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text('إرسال إشعار'),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _notificationController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'نص الإشعار',
                    hintText: 'اكتب الرسالة التي تريد إرسالها للمشتركين...',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.info, color: Colors.blue, size: 16),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'سيتم إرسال الإشعار لجميع المشتركين في هذا الموضوع (${subscribers.length} مشترك)',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _notificationController.clear();
              },
              child: Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_notificationController.text.trim().isNotEmpty) {
                  _sendNotificationToAllSubscribers();
                  Navigator.pop(context);
                  _notificationController.clear();
                }
              },
              child: Text('إرسال'),
            ),
          ],
        ),
      ),
    );
  }

  void _sendNotificationToAllSubscribers() {
    // TODO: تطبيق إرسال الإشعارات عبر Firebase Cloud Messaging
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'تم إرسال الإشعار لجميع المشتركين (${subscribers.length})',
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _sendNotificationToSubscriber(Map<String, dynamic> subscriber) {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text('إرسال إشعار خاص'),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('إرسال إشعار إلى: ${subscriber['name']}'),
                SizedBox(height: 16),
                TextFormField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'نص الإشعار',
                    hintText: 'اكتب رسالتك الشخصية...',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    _notificationController.text = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_notificationController.text.trim().isNotEmpty) {
                  // TODO: إرسال إشعار شخصي عبر Firebase
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'تم إرسال الإشعار إلى ${subscriber['name']}',
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                  _notificationController.clear();
                }
              },
              child: Text('إرسال'),
            ),
          ],
        ),
      ),
    );
  }

  void _trackContentView(Map<String, dynamic> content) {
    // TODO: تسجيل مشاهدة المحتوى في Firebase Analytics
    setState(() {
      content['views'] = (content['views'] as int) + 1;
    });
  }

  void _trackTopicView() {
    setState(() {
      widget.topic['views'] = (widget.topic['views'] as int) + 1;
    });
  }

  void _exportTopicStatistics() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('سيتم إضافة ميزة التصدير قريباً')));
  }
}
