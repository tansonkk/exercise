import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_2/Auth/auth_service.dart';
import 'package:flutter_application_2/Chatroom/page/Chatroom.dart';
import 'package:flutter_application_2/Shopping/page/menu_page.dart';
import 'package:flutter_application_2/gf/page/calendar_page.dart';
import 'package:flutter_application_2/gf/page/gf_page.dart';
import 'package:flutter_application_2/Shopping/cart_services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'Auth/Page/auth_page.dart';
import 'GoogleMap/shipping_page.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'gf/page/movie_page.dart';
import 'gf/page/restaurant_page.dart';
import 'notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationAPI().initialNotifications();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => CartServices()),
      ],
      child: const MyApp(),
    ),
  );
  //Remove this method to stop OneSignal Debugging
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

  OneSignal.initialize("ce5cdfe7-5f19-4d1e-963d-082c3cd25abe7");

// The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.Notifications.requestPermission(true);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthPage(),
      routes: {
        '/chatroom': (context) => const ChatroomPage(),
        '/cart': (context) => const ShoppingPage(),
        '/googlemapshipping': (context) => const ShippingPage(),
        '/home': (context) => const AuthPage(),
        '/gf': (context) => const GF_Page(),
        '/movie': (context) => const Movie_Page(),
        '/restaurant': (context) => const Restaurant_Page(),
        '/calendar': (context) => const Calendar_Page(),
      },
    );
  }
}
