/// English strings. Keys are namespaced by feature to avoid collisions
/// as the dictionary grows (e.g. `auth_`, `home_`, `common_`).
final Map<String, String> enUS = {
  // Common
  'common_retry': 'Retry',
  'common_loading': 'Loading...',
  'common_error_generic': 'Something went wrong. Please try again.',
  'common_no_internet_connection': 'No internet connection.',
  'common_cancel': 'Cancel',
  'common_confirm': 'Confirm',
  'common_load_more': 'Load more',

  // Exception messages (keys match AppException default messages 1:1)
  'no_internet_connection': 'No internet connection.',
  'request_timeout': 'The request timed out. Please try again.',
  'session_expired': 'Your session has expired. Please log in again.',
  'validation_error': 'Some of the information you entered is invalid.',
  'resource_not_found': 'The requested resource was not found.',
  'server_error': 'Something went wrong on our end. Please try again later.',
  'unknown_error': 'An unexpected error occurred.',
  'insecure_connection': 'Could not establish a secure connection.',
  'request_cancelled': 'Request cancelled.',

  // Auth
  'auth_login_title': 'Welcome to Blink',
  'auth_phone_hint': 'Enter your phone number',
  'auth_send_otp': 'Send OTP',
  'auth_otp_title': 'Enter verification code',
  'auth_otp_subtitle': 'We sent a code to {phone}',
  'auth_verify': 'Verify',
  'auth_resend_code': 'Resend code',
  'auth_session_expired': 'Your session has expired. Please log in again.',
  'auth_invalid_phone': 'Please enter a valid phone number',
  'auth_invalid_otp': 'Please enter a valid 4-digit code',

  // Home
  'home_title': 'Home',
  'home_featured_stores': 'Featured stores',
  'home_empty': 'Nothing to show right now',
  'home_section_unsupported': 'New content — update the app to see this',

  // Store
  'store_products': 'Products',
  'store_empty_products': 'No products in this store yet',
  'store_category_all': 'All',

  // Profile
  'profile_title': 'Profile',
  'profile_language': 'Language',
  'profile_logout': 'Log out',
  'profile_logout_confirm_title': 'Log out?',
  'profile_logout_confirm_body': 'Are you sure you want to log out?',
  'profile_first_name_hint': 'First name',
  'profile_last_name_hint': 'Last name',
  'profile_email_hint': 'Email address',
  'profile_save': 'Save changes',
  'profile_update_success': 'Your profile has been updated.',
  'profile_required_field': 'This field is required',
  'profile_invalid_email': 'Please enter a valid email address',
  'profile_language_en': 'English',
  'profile_language_ar': 'العربية',

  // Notifications
  'notifications_title': 'Notifications',
  'notifications_empty': 'You have no notifications yet',
};
