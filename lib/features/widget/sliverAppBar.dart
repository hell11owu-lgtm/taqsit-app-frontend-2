import 'package:flutter/material.dart';

class SliverAppBarDashboard extends StatelessWidget {
  final String userName;
  final double creditLimit; // سقف الائتمان (الرصيد الافتراضي)
  final double nextInstallment; // القسط القادم
  final String dueDate; // تاريخ الدفع
  final int loyaltyPoints; // نقاط الكفاءة (تزيد وتنقص)
  final bool isOverdue; // هل العميل متأخر؟ (لتغيير الألوان)

  const SliverAppBarDashboard({
    super.key,
    required this.userName,
    required this.creditLimit,
    required this.nextInstallment,
    required this.dueDate,
    this.loyaltyPoints = 500, // قيمة افتراضية
    this.isOverdue = false,
  });

  @override
  Widget build(BuildContext context) {
    // تحديد لون الحالة بناءً على الالتزام (أخضر للالتزام، أحمر للتأخير)
    Color statusColor = isOverdue ? Colors.redAccent : Colors.greenAccent;

    return SliverAppBar(
      expandedHeight: 280.0,
      pinned: true,
      elevation: 0,
      backgroundColor: const Color(0xFF673AB7),

      // العنوان الثابت (الاسم والصورة)
      title: _buildStaticHeader(),

      actions: [_buildNotificationIcon(), const SizedBox(width: 10)],

      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF512DA8), Color(0xFF7E57C2)],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // 1. عرض نقاط الكفاءة (التي تزيد وتنقص)
              _buildEfficiencyScore(loyaltyPoints),

              const SizedBox(height: 15),

              // 2. سقف الائتمان (الرصيد الذي يتأثر بالالتزام)
              const Text(
                "الرصيد الحالي في البنك",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${creditLimit.toStringAsFixed(0)} ",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Real",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // 3. بيانات الأقساط (تتغير ألوانها إذا تأخر المستخدم)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildChip(
                    icon: Icons.calendar_month,
                    label: "الموعد: $dueDate",
                    iconColor: isOverdue ? Colors.orange : Colors.white,
                    bgColor: isOverdue
                        ? Colors.red.withOpacity(0.3)
                        : Colors.white.withOpacity(0.15),
                  ),
                  const SizedBox(width: 10),
                  _buildChip(
                    icon: Icons.payment_rounded,
                    label: "القسط: $nextInstallment",
                    iconColor: statusColor,
                    bgColor: Colors.white.withOpacity(0.15),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // محرك عرض "نقاط الكفاءة"
  Widget _buildEfficiencyScore(int points) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.amber.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.stars_rounded, color: Colors.amber, size: 18),
          const SizedBox(width: 6),
          Text(
            "$points نقطة كفاءة",
            style: const TextStyle(
              color: Colors.amber,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  // تصميم العنوان الثابت
  Widget _buildStaticHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: Colors.white24,
          child: Text(
            userName[0].toUpperCase(),
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              userName,
              style: const TextStyle(fontSize: 15, color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNotificationIcon() {
    return const Padding(
      padding: EdgeInsets.only(top: 8),
      child: Badge(
        label: Text("1"),
        child: Icon(Icons.notifications_none_outlined, color: Colors.white),
      ),
    );
  }

  Widget _buildChip({
    required IconData icon,
    required String label,
    required Color iconColor,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
