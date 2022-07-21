import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  //en,fr,es,de
  static var _t = Translations("en") +
      {
        "en": "Payment Accounts",
        "fr": "Comptes de paiement",
        "es": "Cuentas de pago",
        "de": "Zahlungskonten",
        "pt": "Contas de pagamento",
        "ar": "حسابات الدفع",
        "ko": "지불 계정",
        "my": "ငွေပေးချေမှုအကောင့်များ"
      } +
      {
        "en": "New",
        "fr": "Nouveau",
        "es": "Nuevo",
        "de": "Neu",
        "pt": "Novo",
        "ar": "جديد",
        "ko": "새로운",
        "my": "အသစ်"
      } +
      {
        "en": "Payment Account Not Found",
        "fr": "Compte de paiement introuvable",
        "es": "Cuenta de pago no encontrada",
        "de": "Zahlungskonto nicht gefunden",
        "pt": "Conta de pagamento não encontrada",
        "ar": "حساب الدفع غير موجود",
        "ko": "지불 계정을 찾을 수 없음",
        "my": "ငွေပေးချေမှုအကောင့်ကို ရှာမတွေ့ပါ။"
      } +
      {
        "en":
            "Please create a new payment account. This can be use to receive earning from the platform",
        "fr":
            "Veuillez créer un nouveau compte de paiement. Cela peut être utilisé pour recevoir des revenus de la plate-forme",
        "es":
            "Cree una nueva cuenta de pago. Esto se puede utilizar para recibir ganancias de la plataforma.",
        "de":
            "Bitte erstellen Sie ein neues Zahlungskonto. Dies kann verwendet werden, um Einnahmen von der Plattform zu erhalten",
        "pt":
            "Crie uma nova conta de pagamento. Isso pode ser usado para receber ganhos da plataforma",
        "ar":
            "الرجاء إنشاء حساب دفع جديد. يمكن استخدام هذا لتلقي أرباح من النظام الأساسي",
        "ko": "새 결제 계정을 만드세요. 플랫폼에서 수익을 받는 데 사용할 수 있습니다.",
        "my":
            "ငွေပေးချေမှုအကောင့်အသစ်တစ်ခု ဖန်တီးပါ။ ပလက်ဖောင်းမှ ၀င်ငွေရရှိရန် ၎င်းကို အသုံးပြုနိုင်သည်။"
      } +
      {
        "en": "New Payment Account",
        "fr": "Nouveau compte de paiement",
        "es": "Nueva cuenta de pago",
        "de": "Neues Zahlungskonto",
        "pt": "Nova conta de pagamento",
        "ar": "حساب دفع جديد",
        "ko": "새 지불 계정",
        "my": "ငွေပေးချေမှုအကောင့်အသစ်"
      } +
      {
        "en": "Account Name",
        "fr": "Nom du compte",
        "es": "Nombre de la cuenta",
        "de": "Kontobezeichnung",
        "pt": "Nome da conta",
        "ar": "إسم الحساب",
        "ko": "계정 이름",
        "my": "အကောင့်အမည်"
      } +
      {
        "en": "Account Number",
        "fr": "Numéro de compte",
        "es": "Número de cuenta",
        "de": "Kontonummer",
        "pt": "Número de conta",
        "ar": "رقم حساب",
        "ko": "계좌 번호",
        "my": "အကောင့်နံပါတ်"
      } +
      {
        "en": "Instructions",
        "fr": "Instructions",
        "es": "Instrucciones",
        "de": "Anweisungen",
        "pt": "Instruções",
        "ar": "تعليمات",
        "ko": "지침",
        "my": "ညွှန်ကြားချက်များ"
      } +
      {
        "en": "Save",
        "fr": "sauvegarder",
        "es": "Ahorrar",
        "de": "Speichern",
        "pt": "Salve ",
        "ar": "يحفظ",
        "ko": "구하다",
        "my": "သိမ်းဆည်းပါ။"
      } +
      {
        "en": "Successful",
        "fr": "À succès",
        "es": "Exitoso",
        "de": "Erfolgreich",
        "pt": "Bem-sucedido",
        "ar": "ناجح",
        "ko": "성공적인",
        "my": "အောင်မြင်တယ်။"
      } +
      {
        "en": "Active",
        "fr": "actif",
        "es": "Activo",
        "de": "Aktiv",
        "pt": "Ativo",
        "ar": "نشيط",
        "ko": "활동적인",
        "my": "လှုပ်လှုပ်ရှားရှား"
      } +
      {
        "en": "Edit Payment Account",
        "fr": "Modifier le compte de paiement",
        "es": "Editar cuenta de pago",
        "de": "Zahlungskonto bearbeiten",
        "pt": "Editar conta de pagamento",
        "ar": "تحرير حساب الدفع",
        "ko": "결제 계정 수정",
        "my": "ငွေပေးချေမှုအကောင့်ကို တည်းဖြတ်ပါ။"
      };

  String get i18n => localize(this, _t);
  String fill(List<Object> params) => localizeFill(this, params);
}
