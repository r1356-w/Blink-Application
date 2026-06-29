/// Arabic strings — keys must stay in lockstep with `en_us.dart`.
final Map<String, String> arSA = {
  // Common
  'common_retry': 'إعادة المحاولة',
  'common_loading': 'جار التحميل...',
  'common_error_generic': 'حدث خطأ ما. حاول مرة أخرى.',
  'common_no_internet_connection': 'لا يوجد اتصال بالإنترنت.',
  'common_cancel': 'إلغاء',
  'common_confirm': 'تأكيد',
  'common_load_more': 'تحميل المزيد',

  // Exception messages (keys match AppException default messages 1:1)
  'no_internet_connection': 'لا يوجد اتصال بالإنترنت.',
  'request_timeout': 'انتهت مهلة الطلب. حاول مرة أخرى.',
  'session_expired': 'انتهت صلاحية جلستك. يرجى تسجيل الدخول مرة أخرى.',
  'validation_error': 'بعض المعلومات التي أدخلتها غير صحيحة.',
  'resource_not_found': 'لم يتم العثور على المورد المطلوب.',
  'server_error': 'حدث خطأ من جانبنا. يرجى المحاولة لاحقاً.',
  'unknown_error': 'حدث خطأ غير متوقع.',
  'insecure_connection': 'تعذر إنشاء اتصال آمن.',
  'request_cancelled': 'تم إلغاء الطلب.',

  // Auth
  'auth_login_title': 'مرحباً بك في بلينك',
  'auth_phone_hint': 'أدخل رقم هاتفك',
  'auth_send_otp': 'إرسال الرمز',
  'auth_otp_title': 'أدخل رمز التحقق',
  'auth_otp_subtitle': 'تم إرسال رمز إلى {phone}',
  'auth_verify': 'تحقق',
  'auth_resend_code': 'إعادة إرسال الرمز',
  'auth_session_expired': 'انتهت صلاحية جلستك. يرجى تسجيل الدخول مرة أخرى.',
  'auth_invalid_phone': 'يرجى إدخال رقم هاتف صحيح',
  'auth_invalid_otp': 'يرجى إدخال رمز صحيح من 4 أرقام',

  // Home
  'home_title': 'الرئيسية',
  'home_featured_stores': 'المتاجر المميزة',
  'home_empty': 'لا يوجد شيء لعرضه الآن',
  'home_section_unsupported': 'محتوى جديد — حدّث التطبيق لعرضه',

  // Store
  'store_products': 'المنتجات',
  'store_empty_products': 'لا توجد منتجات في هذا المتجر بعد',
  'store_category_all': 'الكل',

  // Profile
  'profile_title': 'الملف الشخصي',
  'profile_language': 'اللغة',
  'profile_logout': 'تسجيل الخروج',
  'profile_logout_confirm_title': 'تسجيل الخروج؟',
  'profile_logout_confirm_body': 'هل أنت متأكد أنك تريد تسجيل الخروج؟',
  'profile_first_name_hint': 'الاسم الأول',
  'profile_last_name_hint': 'اسم العائلة',
  'profile_email_hint': 'البريد الإلكتروني',
  'profile_save': 'حفظ التغييرات',
  'profile_update_success': 'تم تحديث ملفك الشخصي.',
  'profile_required_field': 'هذا الحقل مطلوب',
  'profile_invalid_email': 'يرجى إدخال بريد إلكتروني صحيح',
  'profile_language_en': 'English',
  'profile_language_ar': 'العربية',

  // Notifications
  'notifications_title': 'الإشعارات',
  'notifications_empty': 'لا توجد إشعارات حتى الآن',
};
