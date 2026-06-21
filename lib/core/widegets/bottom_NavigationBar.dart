import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const MainBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // تم تغليف الـ BottomNavigationBar بـ Directionality لإجباره على البدء من اليمين
    return Directionality(
      textDirection: TextDirection.rtl, // تحديد الاتجاه من اليمين لليصار
      child: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        currentIndex: currentIndex,
        onTap: onTap,
        selectedLabelStyle: const TextStyle(
          fontFamily: 'cairo',
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'cairo',
          fontWeight: FontWeight.bold,
        ),
        selectedItemColor: const Color.fromARGB(228, 255, 141, 34),
        unselectedItemColor: const Color.fromARGB(255, 100, 100, 100),
        type: BottomNavigationBarType.fixed,
        iconSize: 24,
        selectedFontSize: 12,
        unselectedFontSize: 11,
        items: const [
          // الأندكس 0: سيظهر الآن في أقصى اليمين تماماً
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.house),
            activeIcon: Icon(CupertinoIcons.house_fill),
            label: "الرئيسية",
          ),

          // الأندكس 1: الثاني من اليمين
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.creditcard),
            activeIcon: Icon(CupertinoIcons.creditcard_fill),
            label: "أقساطي",
          ),

          // الأندكس 2: الثالث من اليمين
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.doc_text),
            activeIcon: Icon(CupertinoIcons.doc_text_fill),
            label: "العمليات",
          ),

          // الأندكس 3: الأخير في أقصى اليسار
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            activeIcon: Icon(CupertinoIcons.person_fill),
            label: "حسابي",
          ),
        ],
      ),
    );
  }
}
