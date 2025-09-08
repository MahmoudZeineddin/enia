import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // بيانات المواضيع (سيتم جلبها من Firebase لاحقاً)
  final List<Topic> topics = [
    Topic(
      id: '1',
      title: 'إدارة الألم',
      description: 'تعلم كيفية إدارة الألم والتعامل معه بطرق طبيعية وفعالة',
      icon: Icons.medical_services,
      subscribers: 245,
      views: 1520,
      isSubscribed: true,
    ),
    Topic(
      id: '2',
      title: 'التغذية الصحية',
      description: 'نصائح وإرشادات للحصول على تغذية متوازنة ومناسبة',
      icon: Icons.local_dining,
      subscribers: 189,
      views: 987,
      isSubscribed: false,
    ),
    Topic(
      id: '3',
      title: 'الصحة النفسية',
      description: 'الاهتمام بالصحة النفسية والعاطفية والتعامل مع التوتر',
      icon: Icons.psychology,
      subscribers: 312,
      views: 2145,
      isSubscribed: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? screenWidth * 0.1 : screenWidth * 0.04,
              vertical: screenHeight * 0.02,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(screenWidth, screenHeight, isTablet),
                SizedBox(height: screenHeight * 0.03),
                _buildWelcomeCard(screenWidth, screenHeight, isTablet),
                SizedBox(height: screenHeight * 0.03),
                _buildSectionHeader(screenWidth, isTablet),
                SizedBox(height: screenHeight * 0.02),
                _buildTopicsList(screenWidth, screenHeight, isTablet),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(double screenWidth, double screenHeight, bool isTablet) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
      child: Row(
        textDirection: TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'أهلاً يا أحمد محمد',
            style: TextStyle(
              fontSize: isTablet ? 22 : screenWidth * 0.05,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A9B8E),
            ),
            textDirection: TextDirection.rtl,
          ),

          Container(
            padding: EdgeInsets.all(isTablet ? 12 : screenWidth * 0.025),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),

            child: Icon(
              Icons.notifications_outlined,
              color: Color(0xFF4A9B8E),
              size: isTablet ? 28 : screenWidth * 0.06,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard(
    double screenWidth,
    double screenHeight,
    bool isTablet,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isTablet ? 32 : screenWidth * 0.06),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF4A9B8E), Color(0xFF6BB6AB)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF4A9B8E).withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'مرحباً بك في عناية',
            style: TextStyle(
              fontSize: isTablet ? 26 : screenWidth * 0.055,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: screenHeight * 0.015),
          Text(
            'اكتشف المواضيع المختلفة للرعاية الصحية\nوشارك في المجتمع',
            style: TextStyle(
              fontSize: isTablet ? 18 : screenWidth * 0.04,
              color: Colors.white.withOpacity(0.9),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(double screenWidth, bool isTablet) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'المواضيع المتاحة',
          style: TextStyle(
            fontSize: isTablet ? 22 : screenWidth * 0.05,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(width: screenWidth * 0.56),
        Icon(
          Icons.search,
          color: Color(0xFF4A9B8E),
          size: isTablet ? 28 : screenWidth * 0.06,
        ),
      ],
    );
  }

  Widget _buildTopicsList(
    double screenWidth,
    double screenHeight,
    bool isTablet,
  ) {
    return Column(
      children: topics
          .map(
            (topic) =>
                _buildTopicCard(topic, screenWidth, screenHeight, isTablet),
          )
          .toList(),
    );
  }

  Widget _buildTopicCard(
    Topic topic,
    double screenWidth,
    double screenHeight,
    bool isTablet,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: screenHeight * 0.02),
      padding: EdgeInsets.all(isTablet ? 24 : screenWidth * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with icon and subscription badge
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(isTablet ? 16 : screenWidth * 0.03),
                decoration: BoxDecoration(
                  color: Color(0xFF4A9B8E).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  topic.icon,
                  color: Color(0xFF4A9B8E),
                  size: isTablet ? 32 : screenWidth * 0.08,
                ),
              ),
              SizedBox(width: screenWidth * 0.04),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            topic.title,
                            style: TextStyle(
                              fontSize: isTablet ? 20 : screenWidth * 0.045,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        if (topic.isSubscribed)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.02,
                              vertical: screenHeight * 0.005,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xFF4A9B8E),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'مشترك',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isTablet ? 12 : screenWidth * 0.025,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.015),
          Text(
            topic.description,
            style: TextStyle(
              fontSize: isTablet ? 16 : screenWidth * 0.035,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          Row(
            children: [
              _buildStatItem(
                '${topic.subscribers} مشترك',
                screenWidth,
                isTablet,
              ),
              SizedBox(width: screenWidth * 0.04),
              _buildStatItem('${topic.views} مشاهدة', screenWidth, isTablet),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  _navigateToTopicDetails(topic);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4A9B8E),
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 24 : screenWidth * 0.06,
                    vertical: isTablet ? 12 : screenHeight * 0.01,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'تفاصيل',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isTablet ? 16 : screenWidth * 0.035,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String text, double screenWidth, bool isTablet) {
    return Text(
      text,
      style: TextStyle(
        fontSize: isTablet ? 14 : screenWidth * 0.03,
        color: Colors.grey[500],
        fontWeight: FontWeight.w500,
      ),
    );
  }

  void _navigateToTopicDetails(Topic topic) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('فتح تفاصيل: ${topic.title}'),
        backgroundColor: Color(0xFF4A9B8E),
      ),
    );
  }
}

// Topic Model Class
class Topic {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final int subscribers;
  final int views;
  final bool isSubscribed; // بدل isNew

  Topic({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.subscribers,
    required this.views,
    required this.isSubscribed,
  });
}
