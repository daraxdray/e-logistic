import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  //en,fr,es,de
  static var _t = Translations("en") +
      {
        "en": "Online",
        "fr": "En ligne",
        "es": "En línea",
        "de": "Online",
        "pt": "Conectados",
        "ar": "متصل",
        "ko": "온라인"
      } +
      {
        "en": "Offline",
        "fr": "Hors ligne",
        "es": "Desconectado",
        "de": "Offline",
        "pt": "desligada",
        "ar": "غير متصل على الانترنت",
        "ko": "오프라인"
      } +
      {
        "en": "New Order Alert",
        "fr": "Alerte de nouvelle commande",
        "es": "Alerta de pedido nuevo",
        "de": "Benachrichtigung über neue Bestellungen",
        "pt": "Alerta de novo pedido",
        "ar": "تنبيه طلب جديد",
        "ko": "새 주문 알림"
      } +
      {
        "en": "Pickup Distance",
        "fr": "Distance de prise en charge",
        "es": "Distancia de recogida",
        "de": "Abholentfernung",
        "pt": "Distância de coleta",
        "ar": "مسافة الالتقاط",
        "ko": "픽업 거리"
      } +
      {
        "en": "Trip Distance",
        "fr": "Distance du trajet",
        "es": "Distancia de viaje",
        "de": "Reisedistanz",
        "pt": "Distância da viagem",
        "ar": "مسافة الرحلة",
        "ko": "여행 거리"
      } +
      {
        "en": "Accept",
        "fr": "J'accepte",
        "es": "Aceptar",
        "de": "Annehmen",
        "pt": "Aceitar",
        "ar": "قبول",
        "ko": "수용하다"
      } +
      {
        "en": "Swipe to accept order",
        "fr": "Glissez pour accepter la commande",
        "es": "Desliza para aceptar el pedido",
        "de": "Wischen Sie, um die Bestellung anzunehmen",
        "pt": "Deslize para aceitar o pedido",
        "ar": "مرر لقبول الطلب",
        "ko": "스와이프하여 주문 수락"
      } +
      {
        "en": "Arrived",
        "fr": "Arrivée",
        "es": "Llegó",
        "de": "Ist eingetroffen",
        "pt": "Chegado",
        "ar": "وصل",
        "ko": "도착했다"
      } +
      {
        "en": "Swipe to notify rider",
        "fr": "Glissez pour avertir le passager",
        "es": "Desliza para notificar al pasajero",
        "de": "Wischen, um den Fahrer zu benachrichtigen",
        "pt": "Deslize para notificar o piloto",
        "ar": "انتقد لإعلام الراكب",
        "ko": "스와이프하여 라이더에게 알림"
      } +
      {
        "en": "End Trip",
        "fr": "Fin du voyage",
        "es": "Fin de viaje",
        "de": "Reise beenden",
        "pt": "Fim da viagem",
        "ar": "نهاية الرحلة",
        "ko": "여행 종료"
      } +
      {
        "en": "Start Trip",
        "fr": "Commencer le voyage",
        "es": "Iniciar viaje",
        "de": "Reise starten",
        "pt": "Iniciar viagem",
        "ar": "ابدأ الرحلة",
        "ko": "여행 시작"
      } +
      {
        "en": "Message",
        "fr": "Un message",
        "es": "Mensaje",
        "de": "Nachricht",
        "pt": "Mensagem",
        "ar": "رسالة",
        "ko": "메세지"
      } +
      {
        "en": "Pickup Address",
        "fr": "Adresse de retrait",
        "es": "Dirección de entrega",
        "de": "Abholadresse",
        "pt": "Endereço de retirada",
        "ar": "عنوان الاستلام",
        "ko": "픽업 주소"
      } +
      {
        "en": "Dropoff Address",
        "fr": "Adresse de dépôt",
        "es": "Dirección de entrega",
        "de": "Abgabeadresse",
        "pt": "Endereço de entrega",
        "ar": "عنوان الإنزال",
        "ko": "하차 주소"
      } +
      {
        "en": "Rate Rider",
        "fr": "Avenant de taux",
        "es": "Tarifa de ciclista",
        "de": "Fahrer bewerten",
        "pt": "Classificar piloto",
        "ar": "معدل رايدر",
        "ko": "레이트 라이더"
      } +
      {
        "en": "Comment",
        "fr": "Commenter",
        "es": "Comentario",
        "de": "Kommentar",
        "pt": "Comente",
        "ar": "تعليق",
        "ko": "논평"
      } +
      {
        "en": "Rider Rating",
        "fr": "Note du coureur",
        "es": "Calificación del ciclista",
        "de": "Fahrerbewertung",
        "pt": "Classificação do piloto",
        "ar": "تقييم رايدر",
        "ko": "라이더 등급"
      } +
      {
        "en": "Submit",
        "fr": "Soumettre",
        "es": "Enviar",
        "de": "einreichen",
        "pt": "Enviar",
        "ar": "يقدم",
        "ko": "제출하다"
      } +
      {
        "en": "Total",
        "fr": "Le total",
        "es": "Total",
        "de": "Gesamt",
        "pt": "Total",
        "ar": "المجموع",
        "ko": "총"
      };

  String get i18n => localize(this, _t);
}
