// import 'package:velocity_x/velocity_x.dart';

class Api {
  static String get baseUrl {
    return "https://fuodz.edentech.online/api";
    // return "http://192.168.8.145:8000/api";
  }

  static const appSettings = "/app/settings";

  static const login = "/login";
  static const logout = "/logout";
  static const forgotPassword = "/password/reset/init";
  static const verifyPhoneAccount = "/verify/phone";
  static const updateProfile = "/profile/update";
  static const updatePassword = "/profile/password/update";
  static const myProfile = "/my/profile";
  //
  static const sendOtp = "/otp/send";
  static const verifyOtp = "/otp/verify";

  static const orders = "/orders";
  static const chat = "/chat/notification";

  //
  static const earning = "/earning/user";
  //
  //wallet
  static const walletBalance = "/wallet/balance";
  static const walletTopUp = "/wallet/topup";
  static const walletTransactions = "/wallet/transactions";
  static const transferWalletBalance = "/wallet/transfer";

  //Payment accounts
  static const paymentAccount = "/payment/accounts";
  static const payoutRequest = "/payouts/request";

  //Taxi booking
  static const currentTaxiBooking = "/taxi/current/order";
  static const cancelTaxiBooking = "/taxi/order/cancel";
  static const rejectTaxiBookingAssignment = "/taxi/order/asignment/reject";
  static const rating = "/rating";

  // Other pages
  static String get privacyPolicy {
    final webUrl = baseUrl.replaceAll('/api', '');
    return "$webUrl/privacy/policy";
  }

  static String get terms {
    final webUrl = baseUrl.replaceAll('/api', '');
    return "$webUrl/pages/terms";
  }

  //
  static String get register {
    final webUrl = baseUrl.replaceAll('/api', '');
    return "$webUrl/register#driver";
  }

  static String get contactUs {
    final webUrl = baseUrl.replaceAll('/api', '');
    return "$webUrl/pages/contact";
  }
}
