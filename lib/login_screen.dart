import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordHidden = true;
  bool _isLoginSelected = true;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? screenWidth * 0.2 : screenWidth * 0.06,
              vertical: screenHeight * 0.02,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.08),

                // العنوان الرئيسي
                Text(
                  'عناية',
                  style: TextStyle(
                    fontSize: isTablet ? 40 : screenWidth * 0.08,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A9B8E),
                  ),
                ),

                SizedBox(height: screenHeight * 0.01),
                Text(
                  'مرحباً بك في تطبيق الرعاية التطبيقية',
                  style: TextStyle(
                    fontSize: isTablet ? 18 : screenWidth * 0.04,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: screenHeight * 0.08),

                // بطاقة تسجيل الدخول
                Expanded(
                  child: Container(
                    width: double.infinity,
                    constraints: BoxConstraints(
                      maxWidth: isTablet ? 500 : double.infinity,
                    ),
                    padding: EdgeInsets.all(isTablet ? 32 : screenWidth * 0.06),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // عنوان البطاقة
                        Text(
                          'الدخول إلى حسابك',
                          style: TextStyle(
                            fontSize: isTablet ? 24 : screenWidth * 0.05,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.01),

                        Text(
                          'اختر إنشاء حساب جديد أو تسجيل الدخول',
                          style: TextStyle(
                            fontSize: isTablet ? 16 : screenWidth * 0.035,
                            color: Colors.grey[600],
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.04),

                        // أزرار الاختيار
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    _isLoginSelected = false;
                                  });
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RegisterScreen(),
                                    ),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.015,
                                  ),
                                  side: BorderSide(color: Color(0xFF4A9B8E)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  'إنشاء حساب',
                                  style: TextStyle(
                                    color: Color(0xFF4A9B8E),
                                    fontSize: isTablet
                                        ? 16
                                        : screenWidth * 0.04,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(width: screenWidth * 0.04),

                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _isLoginSelected = true;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF4A9B8E),
                                  padding: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.015,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  'تسجيل دخول',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isTablet
                                        ? 16
                                        : screenWidth * 0.04,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: screenHeight * 0.03),

                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // حقل البريد الإلكتروني
                                Text(
                                  'البريد الإلكتروني',
                                  style: TextStyle(
                                    fontSize: isTablet
                                        ? 16
                                        : screenWidth * 0.035,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),

                                SizedBox(height: screenHeight * 0.01),

                                TextField(
                                  controller: _emailController,
                                  textDirection: TextDirection.ltr,
                                  keyboardType: TextInputType.emailAddress,
                                  style: TextStyle(
                                    fontSize: isTablet
                                        ? 16
                                        : screenWidth * 0.04,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'أدخل بريدك الإلكتروني',
                                    hintStyle: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: isTablet
                                          ? 16
                                          : screenWidth * 0.04,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: Colors.grey[300]!,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: Colors.grey[300]!,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: Color(0xFF4A9B8E),
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.04,
                                      vertical: screenHeight * 0.015,
                                    ),
                                  ),
                                ),

                                SizedBox(height: screenHeight * 0.025),

                                // حقل كلمة المرور
                                Text(
                                  'كلمة المرور',
                                  style: TextStyle(
                                    fontSize: isTablet
                                        ? 16
                                        : screenWidth * 0.035,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),

                                SizedBox(height: screenHeight * 0.01),

                                TextField(
                                  controller: _passwordController,
                                  textDirection: TextDirection.ltr,
                                  obscureText: _isPasswordHidden,
                                  style: TextStyle(
                                    fontSize: isTablet
                                        ? 16
                                        : screenWidth * 0.04,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'أدخل كلمة المرور',
                                    hintStyle: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: isTablet
                                          ? 16
                                          : screenWidth * 0.04,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: Colors.grey[300]!,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: Colors.grey[300]!,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: Color(0xFF4A9B8E),
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.04,
                                      vertical: screenHeight * 0.015,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isPasswordHidden
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: Colors.grey[500],
                                        size: isTablet
                                            ? 24
                                            : screenWidth * 0.05,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isPasswordHidden =
                                              !_isPasswordHidden;
                                        });
                                      },
                                    ),
                                  ),
                                ),

                                SizedBox(height: screenHeight * 0.04),

                                // زر الدخول
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // منطق تسجيل الدخول
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF4A9B8E),
                                      padding: EdgeInsets.symmetric(
                                        vertical: screenHeight * 0.02,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: Text(
                                      'دخول',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: isTablet
                                            ? 18
                                            : screenWidth * 0.04,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(height: screenHeight * 0.03),

                                // خط الفاصل
                                Row(
                                  children: [
                                    Expanded(
                                      child: Divider(
                                        color: Colors.grey[300],
                                        thickness: 1,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.04,
                                      ),
                                      child: Text(
                                        'أو',
                                        style: TextStyle(
                                          color: Colors.grey[500],
                                          fontSize: isTablet
                                              ? 16
                                              : screenWidth * 0.035,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Divider(
                                        color: Colors.grey[300],
                                        thickness: 1,
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: screenHeight * 0.03),

                                // زر تسجيل الدخول بجوجل
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      // منطق تسجيل الدخول بجوجل
                                    },
                                    style: OutlinedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                        vertical: screenHeight * 0.015,
                                      ),
                                      side: BorderSide(
                                        color: Colors.grey[300]!,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    icon: Container(
                                      width: isTablet ? 24 : screenWidth * 0.05,
                                      height: isTablet
                                          ? 24
                                          : screenWidth * 0.05,
                                      child: Image.network(
                                        'https://developers.google.com/identity/images/g-logo.png',
                                        fit: BoxFit.contain,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return Icon(
                                                Icons.g_mobiledata,
                                                color: Colors.red,
                                                size: isTablet
                                                    ? 24
                                                    : screenWidth * 0.05,
                                              );
                                            },
                                      ),
                                    ),
                                    label: Text(
                                      'الدخول باستخدام جوجل',
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: isTablet
                                            ? 16
                                            : screenWidth * 0.04,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _fullNameController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordHidden = true;
  bool _isConfirmPasswordHidden = true;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.grey[700],
              size: isTablet ? 28 : screenWidth * 0.06,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? screenWidth * 0.2 : screenWidth * 0.06,
              vertical: screenHeight * 0.01,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // العنوان الرئيسي
                Text(
                  'الدخول إلى حسابك',
                  style: TextStyle(
                    fontSize: isTablet ? 24 : screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),

                SizedBox(height: screenHeight * 0.01),
                Text(
                  'اختر إنشاء حساب جديد أو تسجيل الدخول',
                  style: TextStyle(
                    fontSize: isTablet ? 16 : screenWidth * 0.035,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: screenHeight * 0.03),

                // أزرار الاختيار
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF4A9B8E),
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.015,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'إنشاء حساب',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isTablet ? 16 : screenWidth * 0.04,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: screenWidth * 0.04),

                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.015,
                          ),
                          side: BorderSide(color: Colors.grey[300]!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'تسجيل دخول',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: isTablet ? 16 : screenWidth * 0.04,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: screenHeight * 0.02),

                // فورم إنشاء الحساب
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // الاسم الكامل
                        _buildInputField(
                          label: 'الاسم الكامل',
                          controller: _fullNameController,
                          hintText: 'أدخل اسمك الكامل',
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                          isTablet: isTablet,
                        ),

                        SizedBox(height: screenHeight * 0.02),

                        // تاريخ الميلاد
                        _buildInputField(
                          label: 'تاريخ الميلاد',
                          controller: _birthDateController,
                          hintText: 'dd/mm/yyyy',
                          keyboardType: TextInputType.datetime,
                          suffixIcon: Icons.calendar_today,
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                          isTablet: isTablet,
                        ),

                        SizedBox(height: screenHeight * 0.02),

                        // العنوان
                        _buildInputField(
                          label: 'العنوان',
                          controller: _addressController,
                          hintText: 'أدخل عنوانك',
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                          isTablet: isTablet,
                        ),

                        SizedBox(height: screenHeight * 0.02),

                        // البريد الإلكتروني
                        _buildInputField(
                          label: 'البريد الإلكتروني',
                          controller: _emailController,
                          hintText: 'أدخل بريدك الإلكتروني',
                          keyboardType: TextInputType.emailAddress,
                          textDirection: TextDirection.ltr,
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                          isTablet: isTablet,
                        ),

                        SizedBox(height: screenHeight * 0.02),

                        // رقم الهاتف
                        _buildInputField(
                          label: 'رقم الهاتف',
                          controller: _phoneController,
                          hintText: 'أدخل رقم هاتفك',
                          keyboardType: TextInputType.phone,
                          textDirection: TextDirection.ltr,
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                          isTablet: isTablet,
                        ),

                        SizedBox(height: screenHeight * 0.02),

                        // كلمة المرور
                        _buildInputField(
                          label: 'كلمة المرور',
                          controller: _passwordController,
                          hintText: 'أدخل كلمة المرور',
                          isPassword: true,
                          isPasswordHidden: _isPasswordHidden,
                          onTogglePassword: () {
                            setState(() {
                              _isPasswordHidden = !_isPasswordHidden;
                            });
                          },
                          textDirection: TextDirection.ltr,
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                          isTablet: isTablet,
                        ),

                        SizedBox(height: screenHeight * 0.02),

                        // تأكيد كلمة المرور
                        _buildInputField(
                          label: 'تأكيد كلمة المرور',
                          controller: _confirmPasswordController,
                          hintText: 'أعد إدخال كلمة المرور',
                          isPassword: true,
                          isPasswordHidden: _isConfirmPasswordHidden,
                          onTogglePassword: () {
                            setState(() {
                              _isConfirmPasswordHidden =
                                  !_isConfirmPasswordHidden;
                            });
                          },
                          textDirection: TextDirection.ltr,
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                          isTablet: isTablet,
                        ),

                        SizedBox(height: screenHeight * 0.04),

                        // زر التأكيد
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // منطق إنشاء الحساب
                              _handleRegister();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF4A9B8E),
                              padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.02,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'تأكيد',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isTablet ? 18 : screenWidth * 0.045,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.02),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required double screenWidth,
    required double screenHeight,
    required bool isTablet,
    TextInputType? keyboardType,
    bool isPassword = false,
    bool isPasswordHidden = true,
    VoidCallback? onTogglePassword,
    IconData? suffixIcon,
    TextDirection? textDirection,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTablet ? 16 : screenWidth * 0.035,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: isPassword ? isPasswordHidden : false,
          textDirection: textDirection,
          style: TextStyle(fontSize: isTablet ? 16 : screenWidth * 0.04),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: isTablet ? 16 : screenWidth * 0.04,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xFF4A9B8E)),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04,
              vertical: screenHeight * 0.015,
            ),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      isPasswordHidden
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey[500],
                      size: isTablet ? 24 : screenWidth * 0.05,
                    ),
                    onPressed: onTogglePassword,
                  )
                : suffixIcon != null
                ? Icon(
                    suffixIcon,
                    color: Colors.grey[500],
                    size: isTablet ? 24 : screenWidth * 0.05,
                  )
                : null,
          ),
        ),
      ],
    );
  }

  void _handleRegister() {
    // التحقق من صحة البيانات
    if (_fullNameController.text.isEmpty ||
        _birthDateController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('يرجى ملء جميع الحقول'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('كلمات المرور غير متطابقة'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // هنا يمكن إضافة منطق إنشاء الحساب
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم إنشاء الحساب بنجاح'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _birthDateController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
