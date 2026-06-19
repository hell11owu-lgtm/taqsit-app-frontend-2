// lib/features/home/presentation/pages/profile_page.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../data/repository/home_repository.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final HomeRepository _repository = HomeRepository();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // محاذاة كاملة للغة العربية
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA), // خلفية هادئة ونظيفة
        appBar: AppBar(
          title: const Text(
            'الملف الشخصي والمالي',
            style: TextStyle(
              fontFamily: 'cairo',
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: FutureBuilder<Map<String, dynamic>>(
          future: _repository.getUserProfile(), // استدعاء الدالة الديناميكية المحدثة
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.deepOrange),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 50),
                      const SizedBox(height: 12),
                      Text(
                        'خطأ: ${snapshot.error.toString().replaceAll('Exception: ', '')}',
                        style: const TextStyle(fontFamily: 'cairo', fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            } else if (!snapshot.hasData) {
              return const Center(
                child: Text(
                  'لا توجد بيانات للمستخدم حالياً',
                  style: TextStyle(fontFamily: 'cairo'),
                ),
              );
            }

            // قراءة الخريطة الموحدة الراجعة من الـ Repository بالملي
            final profileData = snapshot.data!;
            String name = profileData['full_name'] ?? 'مرحباً بك';
            String email = profileData['email'] ?? 'لا يوجد بريد إلكتروني';
            String phone = profileData['phone_number'] ?? 'لا يوجد رقم هاتف';
            String accountNumber = profileData['account_number'] ?? 'لا يوجد رقم حساب';
            
            double balance = double.tryParse(profileData['balance']?.toString() ?? '0.0') ?? 0.0;
            double maxLimit = double.tryParse(profileData['max_credit_limit']?.toString() ?? '0.0') ?? 0.0;
            int creditScore = int.tryParse(profileData['credit_score']?.toString() ?? '0') ?? 0;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // 🌟 1. الكرت البنكي الفخم (الـ Gradient الأزرق الكحلي الاحترافي)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blueGrey[900]!, Colors.blueGrey[800]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
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
                              name,
                              style: const TextStyle(
                                fontFamily: 'cairo',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const Icon(Icons.credit_card_rounded, color: Colors.white70, size: 28),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          phone,
                          style: TextStyle(
                            fontFamily: 'cairo',
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                        const Divider(color: Colors.white24, height: 30),
                        const Text(
                          'رقم الحساب البنكي المعتمد',
                          style: TextStyle(fontFamily: 'cairo', color: Colors.white54, fontSize: 11),
                        ),
                        Text(
                          accountNumber,
                          style: const TextStyle(
                            fontFamily: 'cairo',
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('الرصيد الحالي', style: TextStyle(fontFamily: 'cairo', color: Colors.white54, fontSize: 11)),
                                const SizedBox(height: 2),
                                Text('${balance.toStringAsFixed(2)} ريال', style: const TextStyle(fontFamily: 'cairo', color: Colors.greenAccent, fontSize: 16, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('الحد الائتماني المتاح', style: TextStyle(fontFamily: 'cairo', color: Colors.white54, fontSize: 11)),
                                const SizedBox(height: 2),
                                Text('${maxLimit.toStringAsFixed(2)} ريال', style: const TextStyle(fontFamily: 'cairo', color: Colors.amberAccent, fontSize: 16, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                        const Divider(color: Colors.white24, height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'مؤشر الثقة والائتمان (Credit Score):',
                              style: TextStyle(fontFamily: 'cairo', color: Colors.white70, fontSize: 13),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '$creditScore',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 🌟 2. قائمة تفاصيل البيانات الشخصية من الباك إيند
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 0,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          _buildProfileItem(
                            icon: Icons.person_outline,
                            title: 'الاسم الكامل للمستخدم',
                            value: name,
                          ),
                          const Divider(height: 24, color: Color(0xFFF1F3F5)),
                          _buildProfileItem(
                            icon: Icons.email_outlined,
                            title: 'البريد الإلكتروني',
                            value: email,
                          ),
                          const Divider(height: 24, color: Color(0xFFF1F3F5)),
                          _buildProfileItem(
                            icon: Icons.phone_android_outlined,
                            title: 'رقم الهاتف المعتمد',
                            value: phone,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 🌟 3. زر تسجيل الخروج المتناسق مع الهوية المخصصة للتطبيق
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.deepOrange, width: 1.2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        backgroundColor: Colors.deepOrange.withOpacity(0.02),
                      ),
                      onPressed: () async {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        await prefs.clear(); // مسح كامل الكاش والتوكن
                        if (context.mounted) {
                          Navigator.of(context).pushReplacementNamed('/login'); 
                        }
                      },
                      icon: const Icon(Icons.logout, color: Colors.deepOrange, size: 20),
                      label: const Text(
                        'تسجيل الخروج من التطبيق',
                        style: TextStyle(
                          fontFamily: 'cairo',
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.blueGrey[600], size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontFamily: 'cairo', fontSize: 11, color: Colors.grey),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontFamily: 'cairo',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}