import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        automaticallyImplyLeading: false,
        title: Text(
          'الملف الشخصي',
          style: TextStyle(
            color: Color(0xFF2E7D7B),
            fontSize: screenWidth * 0.045,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        textDirection: TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Profile Header Section
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Row(
              children: [
                CircleAvatar(
                  radius: screenWidth * 0.08,
                  backgroundColor: Color(0xFF2E7D7B),
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: screenWidth * 0.08,
                  ),
                ),
                SizedBox(width: screenWidth * 0.04),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'أحمد محمد',
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.02,
                          vertical: screenWidth * 0.01,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF2E7D7B), // لون الخلفية
                            foregroundColor: Colors.white, // لون النص
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.05,
                              vertical: screenWidth * 0.02,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            // هنا الأكشن
                          },
                          child: Text(
                            'تعديل',
                            style: TextStyle(
                              fontSize: screenWidth * 0.03,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Tab Bar
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: 'المعلومات'),
                Tab(text: 'النشاط'),
                Tab(text: 'الاشتراكات'),
              ],
              labelColor: Color(0xFF2E7D7B),
              unselectedLabelColor: Colors.grey,
              indicatorColor: Color(0xFF2E7D7B),
              labelStyle: TextStyle(
                fontSize: screenWidth * 0.035,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // Tab Bar View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildInformationTab(context),
                _buildActivityTab(context),
                _buildSubscriptionsTab(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String title,
    String value,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.015),
      child: Row(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              textDirection: TextDirection.rtl,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: screenWidth * 0.035,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: screenWidth * 0.03,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: screenWidth * 0.03),
          Icon(icon, color: Color(0xFF2E7D7B), size: screenWidth * 0.05),
        ],
      ),
    );
  }

  Widget _buildInformationTab(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      padding: EdgeInsets.all(screenWidth * 0.04),
      child: Column(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Personal Information Card
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(screenWidth * 0.04),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              textDirection: TextDirection.rtl,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'المعلومات الشخصية',
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E7D7B),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                _buildInfoRow(
                  context,
                  Icons.email_outlined,
                  'البريد الإلكتروني',
                  'ahmed@example.com',
                ),
                _buildInfoRow(
                  context,
                  Icons.phone_outlined,
                  'رقم الهاتف',
                  '+966 50 123 4567',
                ),
                _buildInfoRow(
                  context,
                  Icons.calendar_today_outlined,
                  'تاريخ الميلاد',
                  '١٤٠٥/١/٢٣ هـ',
                ),
                _buildInfoRow(
                  context,
                  Icons.location_on_outlined,
                  'العنوان',
                  'الرياض، المملكة العربية السعودية',
                ),
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          // Subscribed Topics Section
          Text(
            'المواضيع المشترك بها',
            style: TextStyle(
              fontSize: screenWidth * 0.04,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2E7D7B),
            ),
            textAlign: TextAlign.end,
          ),
          SizedBox(height: screenWidth * 0.02),
          Text(
            'أنت مشترك في ١ مواضيع',
            style: TextStyle(
              fontSize: screenWidth * 0.035,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: screenWidth * 0.04),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(screenWidth * 0.04),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  textDirection: TextDirection.ltr,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'عرض',
                        style: TextStyle(
                          color: Color(0xFF2E7D7B),
                          fontSize: screenWidth * 0.035,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'التغذية الصحية',
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'نصائح وإرشادات للحصول',
                          style: TextStyle(
                            fontSize: screenWidth * 0.032,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          'على تغذية متوازنة',
                          style: TextStyle(
                            fontSize: screenWidth * 0.032,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          'ومناسبة',
                          style: TextStyle(
                            fontSize: screenWidth * 0.032,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    CircleAvatar(
                      radius: screenWidth * 0.04,
                      backgroundColor: Color(0xFF4CAF50),
                      child: Text(
                        '🥗',
                        style: TextStyle(fontSize: screenWidth * 0.04),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenWidth * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(
                          '189',
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D7B),
                          ),
                        ),
                        Text(
                          'مشترك',
                          style: TextStyle(
                            fontSize: screenWidth * 0.03,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '987',
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D7B),
                          ),
                        ),
                        Text(
                          'مشاهدة',
                          style: TextStyle(
                            fontSize: screenWidth * 0.03,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityTab(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      padding: EdgeInsets.all(screenWidth * 0.04),
      child: Column(
        textDirection: TextDirection.rtl,
        children: [
          // Statistics Cards
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  Icons.menu_book_outlined,
                  '1',
                  'الاشتراكات',
                ),
              ),
              SizedBox(width: screenWidth * 0.03),
              Expanded(
                child: _buildStatCard(
                  context,
                  Icons.visibility_outlined,
                  '1247',
                  'المشاهدات',
                ),
              ),
            ],
          ),
          SizedBox(height: screenWidth * 0.03),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  Icons.help_outline,
                  '8',
                  'الأسئلة',
                ),
              ),
              SizedBox(width: screenWidth * 0.03),
              Expanded(
                child: _buildStatCard(
                  context,
                  Icons.show_chart,
                  '45',
                  'يوم نشاط',
                ),
              ),
            ],
          ),
          SizedBox(height: screenWidth * 0.04),
          // Recent Activity Section
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(screenWidth * 0.04),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              textDirection: TextDirection.ltr,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'النشاط الأخير',
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E7D7B),
                  ),
                ),
                SizedBox(height: screenWidth * 0.03),
                Row(
                  children: [
                    Icon(
                      Icons.menu_book_outlined,
                      color: Color(0xFF2E7D7B),
                      size: screenWidth * 0.05,
                    ),
                    SizedBox(width: screenWidth * 0.03),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'منذ 2 ساعة',
                            style: TextStyle(
                              fontSize: screenWidth * 0.03,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            'شاهدت محتوى "تقنيات التنفس للألم"',
                            style: TextStyle(
                              fontSize: screenWidth * 0.035,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionsTab(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      padding: EdgeInsets.all(screenWidth * 0.04),
      child: Column(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'الاشتراكات النشطة',
            style: TextStyle(
              fontSize: screenWidth * 0.04,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2E7D7B),
            ),
          ),
          SizedBox(height: screenWidth * 0.03),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(screenWidth * 0.05),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 2),
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
                      'التغذية الصحية',
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenWidth * 0.02),
                Text(
                  'تاريخ الاشتراك: ١٤٤٥/٦/١٥ هـ',
                  style: TextStyle(
                    fontSize: screenWidth * 0.032,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  'تاريخ انتهاء الاشتراك: ١٤٤٦/٦/١٥ هـ',
                  style: TextStyle(
                    fontSize: screenWidth * 0.032,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    IconData icon,
    String number,
    String title,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: Color(0xFF2E7D7B), size: screenWidth * 0.08),
          SizedBox(height: screenWidth * 0.02),
          Text(
            number,
            style: TextStyle(
              fontSize: screenWidth * 0.06,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D7B),
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: screenWidth * 0.032,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
