

class NotificationNavigation {
   static String commonNotificationMessage ;

   static Future<String> getCommonNotificationMessage() async{
      return commonNotificationMessage;
   }

  static Future<void> setCommonNotificationMessage(String notificationMessage) async{
      commonNotificationMessage = notificationMessage;
   }
}
