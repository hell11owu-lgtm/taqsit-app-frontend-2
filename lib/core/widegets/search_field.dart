import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  const SearchField({super.key});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  bool isExpanded = false;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
        width: isExpanded ? MediaQuery.of(context).size.width - 32 : 50,
        height: 50,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 224, 224, 224),
          borderRadius: BorderRadius.circular(isExpanded ? 15 : 25),
        ),
        // الحل السحري هنا: استخدام SingleChildScrollView مع اتجاه أفقي
        // لمنع الـ Row من الاعتراض على المساحة الضيقة أثناء الحركة
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics:
              const NeverScrollableScrollPhysics(), // منع المستخدم من سحب المحتوى يدوياً
          child: SizedBox(
            // نحدد العرض هنا ليكون مساوياً لعرض الحاوية المتمددة
            width: isExpanded ? MediaQuery.of(context).size.width - 32 : 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // زر الإلغاء يظهر فقط عند التمدد وبشفافية متدرجة
                if (isExpanded)
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: isExpanded ? 1 : 0,
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        size: 20,
                        color: Colors.redAccent,
                      ),
                      onPressed: () {
                        setState(() {
                          _controller.clear();
                          isExpanded = false;
                        });
                      },
                    ),
                  ),

                // حقل النص
                Expanded(
                  child: isExpanded
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextField(
                            controller: _controller,
                            autofocus: true,
                            textAlign: TextAlign.right,
                            cursorColor: Colors.black,
                            style: const TextStyle(fontSize: 14),
                            decoration: const InputDecoration(
                              hintText: "ابحث عن منتج...",
                              hintStyle: TextStyle(fontSize: 13),
                              border: InputBorder.none,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),

                // أيقونة البحث (الثابتة في اليمين)
                IconButton(
                  icon: Icon(
                    isExpanded ? Icons.search : Icons.search_rounded,
                    color: Colors.black54,
                  ),
                  onPressed: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
