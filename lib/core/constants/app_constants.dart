class AppConstants {
  // الرابط الأساسي للـ API (تأكد من ثبات الـ IP الخاص بجهازك)
  static const String baseUrl = 'http://172.16.29.54:8000/api';

  // روابط فرعية (Endpoints) متطابقة 100% مع الـ api.php في الباك إيند
  static const String login = '/login';
  static const String products = '/products';
  //  التعديل هنا: ربط البنك بالمسار المدمج الصحيح
  static const String bankDetails = '/user/profile';
  //  التعديل هنا: مسار السداد الفعلي في لاراڤيل
  static const String payInstallment = '/installments/pay';
}
