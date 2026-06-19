// lib/features/home/presentation/pages/installments_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:installment/data/model/bank_model.dart';
import '../../../../data/repository/home_repository.dart';
import '../../bloc/home_bloc.dart';

class InstallmentsPage extends StatelessWidget {
  const InstallmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: const Color(0xFFF8F9FA),
          appBar: AppBar(
            title: const Text(
              "سجل الأقساط والمالية",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: 'cairo', fontSize: 18),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
            bottom: const TabBar(
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.blue,
              tabs: [
                Tab(child: Text("الأقساط المتبقية", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'cairo'))),
                Tab(child: Text("الأقساط المدفوعة", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'cairo'))),
              ],
            ),
          ),
          body: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading || state is HomeInitial) {
                return const Center(child: CircularProgressIndicator(color: Colors.blue));
              }

              if (state is HomeLoaded) {
                // تصفية الأقساط بناءً على رد لارافل الجديد
                final activeInstallments = state.bankData.installments.where((i) => !i.isPaid).toList();
                final paidInstallments = state.bankData.installments.where((i) => i.isPaid).toList();

                return TabBarView(
                  children: [
                    _buildInstallmentList(context, activeInstallments, isActive: true),
                    _buildInstallmentList(context, paidInstallments, isActive: false),
                  ],
                );
              }

              if (state is HomeError) {
                return Center(
                  child: Text(
                    "خطأ من الخادم: ${state.message}",
                    style: const TextStyle(fontFamily: 'cairo', color: Colors.red),
                  ),
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInstallmentList(BuildContext context, List<InstallmentItem> installments, {required bool isActive}) {
    if (installments.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long_outlined, size: 48, color: Colors.grey),
            SizedBox(height: 12),
            Text("لا توجد أقساط في هذا القسم حالياً", style: TextStyle(fontFamily: 'cairo', color: Colors.grey, fontSize: 14)),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: installments.length,
      itemBuilder: (context, index) {
        final item = installments[index];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: item.isLate && isActive 
                ? Border.all(color: Colors.redAccent.withOpacity(0.5), width: 1.5) // تمييز القسط المتعثر بإطار أحمر خفيف
                : null,
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6, offset: const Offset(0, 2)),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // القسم الأيمن: أيقونة تناسب حالة المنتج وتفاصيل العملية المالية والزر
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: item.isPaid 
                            ? Colors.green.withOpacity(0.1) 
                            : (item.isLate ? Colors.red.withOpacity(0.1) : Colors.blue.withOpacity(0.1)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        item.isPaid 
                            ? Icons.check_circle_outline 
                            : (item.isLate ? Icons.gpp_bad_outlined : Icons.pending_actions),
                        color: item.isPaid ? Colors.green : (item.isLate ? Colors.red : Colors.blue),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // اسم المنتج المجلوب من سيرفرك
                          Text(
                            item.productName.toUpperCase(),
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'cairo', color: Colors.black87),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${item.amount.toStringAsFixed(2)} ريال",
                            style: TextStyle(
                              fontSize: 16, 
                              fontWeight: FontWeight.bold, 
                              color: item.isPaid ? Colors.green : (item.isLate ? Colors.red : Colors.blue),
                              fontFamily: 'cairo'
                            ),
                          ),
                          const SizedBox(height: 8),
                          
                          // الأزرار والحالات الملونة حسب حالة القسط
                          isActive
                              ? ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: item.isLate ? Colors.redAccent : Colors.blue, // أحمر للمتعثر وأزرق للمنتظم
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                    minimumSize: const Size(100, 32),
                                  ),
                                  onPressed: () async {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("جاري معالجة عملية السداد...", style: TextStyle(fontFamily: 'cairo')), duration: Duration(seconds: 1)),
                                    );
                                    try {
                                      bool isPaid = await HomeRepository().payInstallment(item.id);
                                      if (isPaid && context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text("🎉 تم سداد القسط بنجاح وتحديث حسابك", style: TextStyle(fontFamily: 'cairo')), backgroundColor: Colors.green),
                                        );
                                        context.read<HomeBloc>().add(FetchHomeData());
                                      }
                                    } catch (e) {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''), style: const TextStyle(fontFamily: 'cairo')), backgroundColor: Colors.red),
                                        );
                                      }
                                    }
                                  },
                                  child: Text(
                                    item.isLate ? "سداد المتعثر" : "سداد الآن",
                                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'cairo'),
                                  ),
                                )
                              : Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(color: Colors.green.withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.check, color: Colors.green, size: 14),
                                      SizedBox(width: 4),
                                      Text("مدفوع ومكتمل", style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'cairo')),
                                    ],
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // القسم الأيسر: نوع القسط وتاريخ الاستحقاق
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: item.isLate && isActive ? Colors.red.withOpacity(0.1) : Colors.grey[100],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      item.isLate && isActive ? "قسط متعثر" : "قسط مستحق",
                      style: TextStyle(
                        fontSize: 11, 
                        fontWeight: FontWeight.bold, 
                        fontFamily: 'cairo', 
                        color: item.isLate && isActive ? Colors.red : Colors.black54
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(item.dueDate, style: const TextStyle(color: Colors.grey, fontSize: 12, fontFamily: 'cairo')),
                      const SizedBox(width: 4),
                      const Icon(Icons.calendar_month, size: 15, color: Colors.grey),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}