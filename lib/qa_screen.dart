import 'package:flutter/material.dart';

class QAScreen extends StatefulWidget {
  @override
  _QAScreenState createState() => _QAScreenState();
}

class _QAScreenState extends State<QAScreen> {
  final TextEditingController _questionController = TextEditingController();

  final List<Map<String, dynamic>> questions = [
    {
      'id': '1',
      'userName': 'أحمد محمد',
      'timeAgo': 'منذ ساعتين',
      'question': 'ما هي أفضل الطرق للتعامل مع الألم المزمن في المنزل؟',
      'doctorName': 'د. سارة أحمد',
      'specialty': 'طبيب مختص',
      'answer':
          'يمكن التعامل مع الألم المزمن من خلال عدة طرق منها: تطبيق الكمادات الباردة أو الدافئة، ممارسة تمارين التنفس العميق، والحفاظ على نمط نوم منتظم، كما ينصح بممارسة الرياضة الخفيفة والتأمل.',
      'isAnswered': true,
    },
    {
      'id': '2',
      'userName': 'فاطمة علي',
      'timeAgo': 'منذ 4 ساعات',
      'question': 'هل يمكن استخدام العلاج الطبيعي مع الأدوية التقليدية؟',
      'isAnswered': false,
    },
  ];

  bool isButtonEnabled = false; // للتحكم في الزر

  @override
  void initState() {
    super.initState();
    _questionController.addListener(() {
      setState(() {
        isButtonEnabled = _questionController.text.trim().isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Directionality(
      // ✅ لضبط اتجاه الشاشة للعربي
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Color(0xFFF5F7FA),
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04,
                  vertical: screenHeight * 0.02,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'الأسئلة والأجوبة',
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E7D7B),
                    ),
                  ),
                ),
              ),

              // Question Input Section
              Container(
                margin: EdgeInsets.all(screenWidth * 0.04),
                padding: EdgeInsets.all(screenWidth * 0.04),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'اطرح سؤالك هنا',
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF333333),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _questionController,
                        maxLines: 4,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          hintText: 'اكتب سؤالك بالتفصيل...',
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: screenWidth * 0.04,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(screenWidth * 0.04),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isButtonEnabled
                            ? () {
                                setState(() {
                                  questions.insert(0, {
                                    'id': DateTime.now().toString(),
                                    'userName': 'أنت',
                                    'timeAgo': 'الآن',
                                    'question': _questionController.text,
                                    'isAnswered': false,
                                  });
                                  _questionController.clear();
                                });
                              }
                            : null, // ❌ الزر معطل لو ما كتب المستخدم
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isButtonEnabled
                              ? Color(0xFF2E7D7B)
                              : Color(0xFFB0CFCF), // ✅ غامق عند التفعيل
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.02,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'إرسال السؤال',
                              style: TextStyle(
                                fontSize: screenWidth * 0.045,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.02),
                            Icon(
                              Icons.send,
                              color: Colors.white,
                              size: screenWidth * 0.05,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Questions List
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                  itemCount: questions.length,
                  itemBuilder: (context, index) {
                    final question = questions[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: screenHeight * 0.02),
                      padding: EdgeInsets.all(screenWidth * 0.04),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // User Info
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Color(0xFF88B8B6),
                                radius: screenWidth * 0.05,
                                child: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: screenWidth * 0.05,
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.02),
                              Text(
                                question['userName'] ?? 'مستخدم مجهول',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: screenWidth * 0.04,
                                  color: Color(0xFF333333),
                                ),
                              ),
                              Spacer(),
                              Text(
                                question['timeAgo'],
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: screenWidth * 0.035,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.015),

                          // Question
                          Text(
                            question['question'],
                            style: TextStyle(
                              fontSize: screenWidth * 0.042,
                              color: Color(0xFF333333),
                              height: 1.5,
                            ),
                          ),

                          if (question['isAnswered'] == true) ...[
                            SizedBox(height: screenHeight * 0.02),
                            Container(
                              padding: EdgeInsets.all(screenWidth * 0.03),
                              decoration: BoxDecoration(
                                color: Color(0xFFF0F8F8),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Doctor Info
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Color(0xFF2E7D7B),
                                        radius: screenWidth * 0.04,
                                        child: Icon(
                                          Icons.local_hospital,
                                          color: Colors.white,
                                          size: screenWidth * 0.04,
                                        ),
                                      ),
                                      SizedBox(width: screenWidth * 0.02),
                                      Text(
                                        question['doctorName'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: screenWidth * 0.04,
                                          color: Color(0xFF2E7D7B),
                                        ),
                                      ),
                                      Spacer(),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: screenWidth * 0.02,
                                          vertical: screenWidth * 0.01,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Color(0xFF2E7D7B),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          question['specialty'],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: screenWidth * 0.03,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: screenHeight * 0.01),

                                  // Answer
                                  Text(
                                    question['answer'] ?? 'لا توجد إجابة متاحة',
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.038,
                                      color: Color(0xFF333333),
                                      height: 1.6,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }
}
