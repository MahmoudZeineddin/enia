import 'package:flutter/material.dart';

// نموذج البيانات (يحاكي Firebase Document)
class ConversationModel {
  final String id;
  final String name;
  final String lastMessage;
  final DateTime lastMessageTime;
  final List<String> participants;
  final bool isGroup;
  final bool isDoctor;
  final int unreadCount;
  final Map<String, bool> readStatus;
  final String? avatarUrl;

  ConversationModel({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.participants,
    this.isGroup = false,
    this.isDoctor = false,
    this.unreadCount = 0,
    this.readStatus = const {},
    this.avatarUrl,
  });

  // تحويل من Map (يحاكي Firebase Document data)
  factory ConversationModel.fromMap(String id, Map<String, dynamic> data) {
    return ConversationModel(
      id: id,
      name: data['name'] ?? '',
      lastMessage: data['lastMessage'] ?? '',
      lastMessageTime: DateTime.fromMillisecondsSinceEpoch(
        data['lastMessageTime'] ?? 0,
      ),
      participants: List<String>.from(data['participants'] ?? []),
      isGroup: data['isGroup'] ?? false,
      isDoctor: data['isDoctor'] ?? false,
      unreadCount: data['unreadCount'] ?? 0,
      readStatus: Map<String, bool>.from(data['readStatus'] ?? {}),
      avatarUrl: data['avatarUrl'],
    );
  }
}

class MessagesScreen extends StatefulWidget {
  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  List<ConversationModel> conversations = [];
  bool isLoading = true;
  final String currentUserId = "user123"; // يحاكي Firebase Auth current user

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  // محاكاة جلب البيانات من Firebase
  Future<void> _loadConversations() async {
    // محاكاة وقت التحميل من الشبكة
    await Future.delayed(Duration(milliseconds: 1500));

    // البيانات الوهمية (تحاكي Firestore Collection)
    List<Map<String, dynamic>> dummyData = [
      {
        'name': 'د. سارة أحمد',
        'lastMessage':
            'شكراً لك على المتابعة، أراك في الموعد القادم والله يعافيك',
        'lastMessageTime': DateTime.now()
            .subtract(Duration(minutes: 10))
            .millisecondsSinceEpoch,
        'participants': ['user123', 'doctor_sarah'],
        'isGroup': false,
        'isDoctor': true,
        'unreadCount': 0,
        'readStatus': {'user123': true, 'doctor_sarah': true},
      },
      {
        'name': 'مجموعة مرضى السكري',
        'lastMessage': 'أحمد: شكراً للنصائح المفيدة، استفدت كثيراً من تجاربكم',
        'lastMessageTime': DateTime.now()
            .subtract(Duration(minutes: 30))
            .millisecondsSinceEpoch,
        'participants': [
          'user123',
          'ahmad_diabetes',
          'sara_patient',
          'doctor_omar',
        ],
        'isGroup': true,
        'isDoctor': false,
        'unreadCount': 2,
        'readStatus': {'user123': false, 'ahmad_diabetes': true},
      },
      {
        'name': 'د. محمد حسن',
        'lastMessage':
            'لا تنس تناول الدواء في المواعيد المحددة وراجعني إذا شعرت بأي أعراض',
        'lastMessageTime': DateTime.now()
            .subtract(Duration(hours: 1))
            .millisecondsSinceEpoch,
        'participants': ['user123', 'doctor_mohammad'],
        'isGroup': false,
        'isDoctor': true,
        'unreadCount': 1,
        'readStatus': {'user123': false, 'doctor_mohammad': true},
      },
      {
        'name': 'مجموعة العلاج الطبيعي',
        'lastMessage': 'نور: التمارين التي شاركتها رائعة، بدأت أشعر بتحسن',
        'lastMessageTime': DateTime.now()
            .subtract(Duration(hours: 2))
            .millisecondsSinceEpoch,
        'participants': [
          'user123',
          'noor_patient',
          'therapist_ali',
          'manager_clinic',
        ],
        'isGroup': true,
        'isDoctor': false,
        'unreadCount': 0,
        'readStatus': {'user123': true, 'noor_patient': true},
      },
      {
        'name': 'د. فاطمة الزهراء',
        'lastMessage': 'نتائج التحاليل جيدة، استمر على نفس العلاج',
        'lastMessageTime': DateTime.now()
            .subtract(Duration(days: 1))
            .millisecondsSinceEpoch,
        'participants': ['user123', 'doctor_fatima'],
        'isGroup': false,
        'isDoctor': true,
        'unreadCount': 0,
        'readStatus': {'user123': true, 'doctor_fatima': true},
      },
      {
        'name': 'مجموعة دعم المرضى',
        'lastMessage': 'خالد: كل الشكر للدكتور على المتابعة المستمرة',
        'lastMessageTime': DateTime.now()
            .subtract(Duration(days: 2))
            .millisecondsSinceEpoch,
        'participants': [
          'user123',
          'khalid_support',
          'mariam_support',
          'doctor_ahmad',
        ],
        'isGroup': true,
        'isDoctor': false,
        'unreadCount': 5,
        'readStatus': {'user123': false, 'khalid_support': true},
      },
    ];

    // تحويل البيانات إلى نماذج
    List<ConversationModel> loadedConversations = [];
    for (int i = 0; i < dummyData.length; i++) {
      loadedConversations.add(
        ConversationModel.fromMap('conversation_$i', dummyData[i]),
      );
    }

    // ترتيب المحادثات حسب آخر رسالة (الأحدث أولاً)
    loadedConversations.sort(
      (a, b) => b.lastMessageTime.compareTo(a.lastMessageTime),
    );

    setState(() {
      conversations = loadedConversations;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: Text(
            'الرسائل',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,

          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Container(height: 1, color: Colors.grey[200]),
          ),
        ),
        body: Container(
          color: Colors.white,
          child: isLoading
              ? _buildLoadingState()
              : conversations.isEmpty
              ? _buildEmptyState()
              : _buildConversationsList(),
        ),
      ),
    );
  }

  // حالة التحميل
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Color(0xFF0D9488), strokeWidth: 3),
          SizedBox(height: 16),
          Text(
            'جاري تحميل المحادثات...',
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
        ],
      ),
    );
  }

  // حالة عدم وجود محادثات
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 80, color: Colors.grey[300]),
          SizedBox(height: 24),
          Text(
            'لا توجد محادثات',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'ابدأ محادثة جديدة مع طبيبك',
            style: TextStyle(fontSize: 14, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  // قائمة المحادثات
  Widget _buildConversationsList() {
    return RefreshIndicator(
      onRefresh: _loadConversations,
      color: Color(0xFF0D9488),
      child: ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: conversations.length,
        itemBuilder: (context, index) {
          return _buildConversationTile(conversations[index]);
        },
      ),
    );
  }

  // عرض كل محادثة
  Widget _buildConversationTile(ConversationModel conversation) {
    bool isUnread =
        conversation.readStatus[currentUserId] == true &&
        conversation.unreadCount > 0;

    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[100]!, width: 1)),
        color: isUnread
            ? Colors.blue[50]?.withOpacity(0.3)
            : Colors.transparent,
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: CircleAvatar(
          radius: 26,
          backgroundColor: conversation.isDoctor
              ? Color(0xFF0D9488)
              : conversation.isGroup
              ? Color(0xFFB2F5EA)
              : Color(0xFF0D9488),
          child: Icon(
            conversation.isDoctor
                ? Icons.local_hospital
                : conversation.isGroup
                ? Icons.group
                : Icons.person,
            color: conversation.isDoctor
                ? Colors.white
                : conversation.isGroup
                ? Color(0xFF0F766E)
                : Colors.white,
            size: 26,
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                conversation.name,
                style: TextStyle(
                  fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                  color: Colors.grey[900],
                  fontSize: 16,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 8),
            if (isUnread && conversation.unreadCount > 0)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(0xFF0D9488),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  conversation.unreadCount > 99
                      ? '99+'
                      : '${conversation.unreadCount}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 6),
            Text(
              conversation.lastMessage,
              style: TextStyle(
                color: isUnread ? Colors.grey[700] : Colors.grey[600],
                fontSize: 14,
                fontWeight: isUnread ? FontWeight.w500 : FontWeight.normal,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatTime(conversation.lastMessageTime),
                  style: TextStyle(
                    color: isUnread ? Color(0xFF0D9488) : Colors.grey[400],
                    fontSize: 12,
                    fontWeight: isUnread ? FontWeight.w500 : FontWeight.normal,
                  ),
                ),
                if (conversation.isGroup &&
                    conversation.participants.length > 0)
                  Text(
                    '${conversation.participants.length} مشاركين',
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  ),
              ],
            ),
          ],
        ),
        onTap: () {
          // تحديث حالة القراءة
          _markAsRead(conversation.id);

          // الانتقال إلى صفحة المحادثة
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                conversationId: conversation.id,
                conversationName: conversation.name,
              ),
            ),
          );
        },
      ),
    );
  }

  // تنسيق الوقت
  String _formatTime(DateTime messageTime) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(messageTime);

    if (difference.inMinutes < 1) {
      return 'الآن';
    } else if (difference.inMinutes < 60) {
      return 'منذ ${difference.inMinutes} د';
    } else if (difference.inHours < 24) {
      return 'منذ ${difference.inHours} س';
    } else if (difference.inDays < 7) {
      return 'منذ ${difference.inDays} يوم';
    } else {
      return '${messageTime.day}/${messageTime.month}';
    }
  }

  // تحديد الرسالة كمقروءة (محاكاة Firebase update)
  void _markAsRead(String conversationId) {
    setState(() {
      int index = conversations.indexWhere((c) => c.id == conversationId);
      if (index != -1) {
        // محاكاة تحديث readStatus في Firebase
        conversations[index] = ConversationModel(
          id: conversations[index].id,
          name: conversations[index].name,
          lastMessage: conversations[index].lastMessage,
          lastMessageTime: conversations[index].lastMessageTime,
          participants: conversations[index].participants,
          isGroup: conversations[index].isGroup,
          isDoctor: conversations[index].isDoctor,
          unreadCount: 0, // إزالة العداد
          readStatus: {...conversations[index].readStatus, currentUserId: true},
          avatarUrl: conversations[index].avatarUrl,
        );
      }
    });

    // هنا ستضع كود Firebase لاحقاً
    print('تم تحديد المحادثة $conversationId كمقروءة');
  }
}

// نموذج الرسالة
class MessageModel {
  final String id;
  final String senderId;
  final String senderName;
  final String content;
  final DateTime timestamp;
  final bool isMe;
  final String? messageType; // text, image, file
  final bool isDelivered;
  final bool isRead;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.timestamp,
    required this.isMe,
    this.messageType = 'text',
    this.isDelivered = true,
    this.isRead = false,
  });
}

// شاشة المحادثة المتكاملة
class ChatScreen extends StatefulWidget {
  final String conversationId;
  final String conversationName;

  ChatScreen({required this.conversationId, required this.conversationName});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<MessageModel> messages = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  // محاكاة جلب الرسائل
  Future<void> _loadMessages() async {
    await Future.delayed(Duration(milliseconds: 800));

    // رسائل وهمية مختلفة حسب نوع المحادثة
    List<MessageModel> dummyMessages = _generateDummyMessages();

    setState(() {
      messages = dummyMessages;
      isLoading = false;
    });

    // التمرير للأسفل
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // توليد رسائل وهمية حسب نوع المحادثة
  List<MessageModel> _generateDummyMessages() {
    if (widget.conversationName.contains('د.')) {
      // رسائل مع طبيب
      return [
        MessageModel(
          id: '1',
          senderId: 'doctor',
          senderName: widget.conversationName,
          content: 'أهلاً وسهلاً، كيف حالتك اليوم؟',
          timestamp: DateTime.now().subtract(Duration(hours: 2)),
          isMe: false,
        ),
        MessageModel(
          id: '2',
          senderId: 'me',
          senderName: 'أنا',
          content: 'الحمد لله دكتور، أشعر بتحسن',
          timestamp: DateTime.now().subtract(Duration(hours: 1, minutes: 45)),
          isMe: true,
        ),
        MessageModel(
          id: '3',
          senderId: 'doctor',
          senderName: widget.conversationName,
          content: 'ممتاز، هل التزمت بتناول الأدوية في مواعيدها؟',
          timestamp: DateTime.now().subtract(Duration(hours: 1, minutes: 30)),
          isMe: false,
        ),
        MessageModel(
          id: '4',
          senderId: 'me',
          senderName: 'أنا',
          content: 'نعم دكتور، ملتزم تماماً بالجدول الذي وضعته لي',
          timestamp: DateTime.now().subtract(Duration(hours: 1, minutes: 15)),
          isMe: true,
        ),
        MessageModel(
          id: '5',
          senderId: 'doctor',
          senderName: widget.conversationName,
          content: 'عظيم، استمر على هذا النهج وراجعني بعد أسبوع',
          timestamp: DateTime.now().subtract(Duration(minutes: 10)),
          isMe: false,
        ),
      ];
    } else if (widget.conversationName.contains('مجموعة')) {
      // رسائل مجموعة
      return [
        MessageModel(
          id: '1',
          senderId: 'ahmad',
          senderName: 'أحمد محمد',
          content: 'السلام عليكم جميعاً، كيف الحال؟',
          timestamp: DateTime.now().subtract(Duration(hours: 3)),
          isMe: false,
        ),
        MessageModel(
          id: '2',
          senderId: 'sara',
          senderName: 'سارة أحمد',
          content: 'وعليكم السلام، الحمد لله بخير',
          timestamp: DateTime.now().subtract(Duration(hours: 2, minutes: 45)),
          isMe: false,
        ),
        MessageModel(
          id: '3',
          senderId: 'me',
          senderName: 'أنا',
          content: 'أهلاً بكم، سعيد بانضمامي للمجموعة',
          timestamp: DateTime.now().subtract(Duration(hours: 2, minutes: 30)),
          isMe: true,
        ),
        MessageModel(
          id: '4',
          senderId: 'doctor',
          senderName: 'د. عمر الطبيب',
          content: 'أهلاً بك معنا، هذه المجموعة للدعم المتبادل بين المرضى',
          timestamp: DateTime.now().subtract(Duration(hours: 2)),
          isMe: false,
        ),
        MessageModel(
          id: '5',
          senderId: 'noor',
          senderName: 'نور الهدى',
          content: 'بفضل نصائحكم بدأت أشعر بتحسن كبير، شكراً لكم جميعاً',
          timestamp: DateTime.now().subtract(Duration(minutes: 30)),
          isMe: false,
        ),
        MessageModel(
          id: '6',
          senderId: 'me',
          senderName: 'أنا',
          content: 'هذا رائع، أتمنى أن أستفيد من تجاربكم أيضاً',
          timestamp: DateTime.now().subtract(Duration(minutes: 5)),
          isMe: true,
        ),
      ];
    } else {
      // رسائل عادية
      return [
        MessageModel(
          id: '1',
          senderId: 'other',
          senderName: widget.conversationName,
          content: 'مرحباً، كيف الأحوال؟',
          timestamp: DateTime.now().subtract(Duration(hours: 1)),
          isMe: false,
        ),
        MessageModel(
          id: '2',
          senderId: 'me',
          senderName: 'أنا',
          content: 'الحمد لله تمام، وأنت كيفك؟',
          timestamp: DateTime.now().subtract(Duration(minutes: 45)),
          isMe: true,
        ),
        MessageModel(
          id: '3',
          senderId: 'other',
          senderName: widget.conversationName,
          content: 'بخير والحمد لله',
          timestamp: DateTime.now().subtract(Duration(minutes: 15)),
          isMe: false,
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.conversationName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'متصل الآن',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          backgroundColor: Color(0xFF0D9488),
          elevation: 1,
          iconTheme: IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              icon: Icon(Icons.videocam, color: Colors.white),
              onPressed: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('بدء مكالمة فيديو')));
              },
            ),
            IconButton(
              icon: Icon(Icons.call, color: Colors.white),
              onPressed: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('بدء مكالمة صوتية')));
              },
            ),
            IconButton(
              icon: Icon(Icons.more_vert, color: Colors.white),
              onPressed: () {
                _showOptionsMenu(context);
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // منطقة الرسائل
            Expanded(
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF0D9488),
                      ),
                    )
                  : messages.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 16),
                          Text(
                            'لا توجد رسائل',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'ابدأ المحادثة بإرسال رسالة',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        return _buildMessageBubble(messages[index]);
                      },
                    ),
            ),

            // شريط كتابة الرسالة
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // زر المرفقات
                  IconButton(
                    icon: Icon(Icons.attach_file, color: Color(0xFF0D9488)),
                    onPressed: () {
                      _showAttachmentOptions(context);
                    },
                  ),

                  // حقل النص
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'اكتب رسالة...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey[500]),
                        ),
                        maxLines: null,
                        onChanged: (text) {
                          setState(() {});
                        },
                      ),
                    ),
                  ),

                  SizedBox(width: 8),

                  // زر الإرسال
                  Container(
                    decoration: BoxDecoration(
                      color: _messageController.text.trim().isEmpty
                          ? Colors.grey[400]
                          : Color(0xFF0D9488),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.send, color: Colors.white, size: 20),
                      onPressed: _messageController.text.trim().isEmpty
                          ? null
                          : _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // بناء فقاعة الرسالة
  Widget _buildMessageBubble(MessageModel message) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: message.isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          // اسم المرسل (للمجموعات فقط)
          if (!message.isMe && widget.conversationName.contains('مجموعة'))
            Padding(
              padding: EdgeInsets.only(bottom: 4, right: 12),
              child: Text(
                message.senderName,
                style: TextStyle(
                  color: Color(0xFF0D9488),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

          // فقاعة الرسالة
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: message.isMe ? Color(0xFF0D9488) : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomLeft: message.isMe
                    ? Radius.circular(18)
                    : Radius.circular(4),
                bottomRight: message.isMe
                    ? Radius.circular(4)
                    : Radius.circular(18),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.content,
                  style: TextStyle(
                    color: message.isMe ? Colors.white : Colors.grey[800],
                    fontSize: 15,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 6),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatMessageTime(message.timestamp),
                      style: TextStyle(
                        color: message.isMe ? Colors.white70 : Colors.grey[500],
                        fontSize: 11,
                      ),
                    ),
                    if (message.isMe) ...[
                      SizedBox(width: 4),
                      Icon(
                        message.isRead
                            ? Icons.done_all
                            : message.isDelivered
                            ? Icons.done_all
                            : Icons.done,
                        size: 14,
                        color: message.isRead
                            ? Colors.blue[300]
                            : Colors.white70,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // تنسيق وقت الرسالة
  String _formatMessageTime(DateTime timestamp) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'الآن';
    } else if (difference.inHours < 24) {
      return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else {
      return '${timestamp.day}/${timestamp.month} ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }

  // إرسال رسالة
  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    MessageModel newMessage = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: 'me',
      senderName: 'أنا',
      content: _messageController.text.trim(),
      timestamp: DateTime.now(),
      isMe: true,
      isDelivered: true,
    );

    setState(() {
      messages.add(newMessage);
    });

    _messageController.clear();

    // التمرير للأسفل
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    // محاكاة رد تلقائي (اختياري)
    _simulateAutoReply();
  }

  // محاكاة رد تلقائي
  void _simulateAutoReply() {
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        List<String> autoReplies = [
          'شكراً لك على التواصل',
          'تم استلام رسالتك',
          'سأرد عليك قريباً',
          'تمام، مفهوم',
        ];

        MessageModel autoReply = MessageModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          senderId: 'other',
          senderName: widget.conversationName,
          content: autoReplies[messages.length % autoReplies.length],
          timestamp: DateTime.now(),
          isMe: false,
        );

        setState(() {
          messages.add(autoReply);
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }
    });
  }

  // قائمة خيارات إضافية
  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.info, color: Color(0xFF0D9488)),
              title: Text('معلومات المحادثة'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.search, color: Color(0xFF0D9488)),
              title: Text('البحث في المحادثة'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.block, color: Colors.red),
              title: Text('حظر المستخدم'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  // خيارات المرفقات
  void _showAttachmentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo, color: Color(0xFF0D9488)),
              title: Text('صورة من المعرض'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.camera_alt, color: Color(0xFF0D9488)),
              title: Text('التقاط صورة'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.insert_drive_file, color: Color(0xFF0D9488)),
              title: Text('ملف'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
