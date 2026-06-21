// lib/features/home/presentation/pages/product_details_page.dart
import 'package:flutter/material.dart';
import '../../../../data/repository/home_repository.dart';
import '../../data/model/product_model.dart';

class ProductDetailsPage extends StatefulWidget {
  final ProductModel? product;
  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  final HomeRepository _repository = HomeRepository();
  int _selectedMonths = 3; // افتراضياً التقسيط على 3 أشهر
  bool _isLoading = false;

  // 🚀 دالة إظهار الحوار التأكيدي قبل الشراء
  void _showConfirmDialog(double downPaymentAmount) {
    showDialog(
      context: context,
      barrierDismissible: false, // يجب الإجابة بنعم أو لا
      builder: (BuildContext dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.amber,
                  size: 28,
                ),
                SizedBox(width: 8),
                Text(
                  'تأكيد عملية التقسيط',
                  style: TextStyle(
                    fontFamily: 'cairo',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            content: Text(
              'تنبيه: سيتم خصم مبلغ مقدم وقدره (${downPaymentAmount.toStringAsFixed(2)} ريال) من حسابك البنكي فوراً لبدء خطة التقسيط على $_selectedMonths أشهر. هل أنت موافق؟',
              style: const TextStyle(
                fontFamily: 'cairo',
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () =>
                    Navigator.pop(dialogContext), // إغلاق الحوار وإلغاء العملية
                child: const Text(
                  'إلغاء',
                  style: TextStyle(
                    fontFamily: 'cairo',
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(dialogContext); // إغلاق الحوار
                  _handlePurchase(
                    downPaymentAmount,
                  ); // البدء في الشراء الحقيقي الفوري
                },
                child: const Text(
                  'موافق، شراء',
                  style: TextStyle(
                    fontFamily: 'cairo',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 🚀 دالة تفعيل الشراء والربط مع الباك إيند بعد الموافقة
  void _handlePurchase(double downPayment) async {
    if (widget.product == null) return;

    setState(() => _isLoading = true);
    try {
      final int intProductId = int.tryParse(widget.product!.id) ?? 0;

      // 🌟 تمرير البيانات ديناميكياً وحسب ما اختاره الزبون بالملي
      bool success = await _repository.purchaseProductWithInstallment(
        productId: intProductId,
        months: _selectedMonths,
        downPayment: downPayment, // تمرير نصف قيمة المنتج ديناميكياً
      );

      if (success && mounted) {
        _showStyledSnackBar(
          message: '🎉 تمت عملية الشراء وتوليد جدول الأقساط بنجاح الملي!',
          isError: false,
        );
        Navigator.pop(context); // العودة للرئيسية وتحديث البيانات تلقائياً
      }
    } catch (e) {
      if (mounted) {
        // 🌟 عرض رسائل الباك إيند الحقيقية بتنسيق فخم وممتاز
        _showStyledSnackBar(
          message: e.toString().replaceAll('Exception: ', ''),
          isError: true,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // دالة مخصصة لعرض الـ SnackBar بشكل منسق وجذاب ومريح للعين
  void _showStyledSnackBar({required String message, required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontFamily: 'cairo',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.product == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            'بيانات المنتج غير متوفرة',
            style: TextStyle(fontFamily: 'cairo'),
          ),
        ),
      );
    }

    final product = widget.product!;
    // حساب القسط الشهري بناءً على السعر الصحيح من الموديل
    double monthlyInstallment = (product.price / _selectedMonths);
    // 🌟 حساب قيمة الدفعة المقدمة (نصف سعر المنتج الحالي للزبون)
    double calculatedDownPayment = product.price / 2;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            product.name,
            style: const TextStyle(
              fontFamily: 'cairo',
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 350,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: product.image.isEmpty
                      ? Image.asset('assets/images/img2.png', fit: BoxFit.cover)
                      : product.image.startsWith('http')
                      ? Image.network(
                          product.image,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/img2.png',
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      : Image.asset(
                          product.image,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/img2.png',
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                product.name,
                style: const TextStyle(
                  fontFamily: 'cairo',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${product.price} ريال',
                style: const TextStyle(
                  fontFamily: 'cairo',
                  fontSize: 18,
                  color: Colors.deepOrange,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (product.description.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  product.description,
                  style: const TextStyle(
                    // fontFamily: 'cairo',
                    fontSize: 14,
                    color: Color.fromARGB(255, 9, 9, 9),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              const Text(
                'خطة التقسيط المناسبة لك:',
                style: TextStyle(
                  fontFamily: 'cairo',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [3, 6, 12].map((months) {
                  return ChoiceChip(
                    label: Text(
                      '$months أشهر',
                      style: const TextStyle(fontFamily: 'cairo'),
                    ),
                    selected: _selectedMonths == months,
                    selectedColor: Colors.deepOrange,
                    labelStyle: TextStyle(
                      color: _selectedMonths == months
                          ? Colors.white
                          : Colors.black,
                    ),
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedMonths = months);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Card(
                color: Colors.grey[100],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          'القسط الشهري التقريبي:',
                          style: TextStyle(
                            // fontFamily: 'cairo',
                            fontSize: 15,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${monthlyInstallment.toStringAsFixed(2)} ريال / شهر',
                        style: const TextStyle(
                          fontFamily: 'cairo',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _isLoading
                      ? null
                      : () => _showConfirmDialog(
                          calculatedDownPayment,
                        ), // استدعاء الحوار التأكيدي أولاً
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'طلب شراء بالتقسيط الفوري',
                          style: TextStyle(
                            fontFamily: 'cairo',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// كلاس مساعد لتحديد اللون الأخضر المريح للعين بشكل مخصص وثابت
extension ColorsExtension on Colors {
  static const Color emeraldGreen = Color(0xFF2EC4B6);
}
