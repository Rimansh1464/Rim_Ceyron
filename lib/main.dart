import 'package:ceyron_app/Api/Controller/kyc_provider.dart';
import 'package:ceyron_app/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
// ignore_for_file: prefer_const_constructors
import 'Agent/providers/internet_provider.dart';
import 'Agent/splash/splash.dart';
import 'Api/Controller/auth_provider.dart';
import 'Api/Controller/getx_controller.dart';
import 'Api/Controller/local_stuff.dart';
import 'Api/Controller/transaction_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


void main() async {
  await GetStorage.init();
  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});
  static void setLocale(BuildContext context, Locale newLocale) {
    MyAppState? state = context.findAncestorStateOfType<MyAppState>();
    state!.setLocale(newLocale);
  }
  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  int? storagePermissionCheck;

  GetController getController = Get.put(GetController());

  setLocale(Locale locale) {
    setState(() {
      getController.locales = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getController.getLocale().then((locale) {
      setState(() {
        getController.locales = locale;
      });
    });
    super.didChangeDependencies();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => InternetProvider()),
        ChangeNotifierProvider(create: (context) => TransactionProvider()),
        ChangeNotifierProvider(create: (context) => KycProvider()),

      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        locale: getController.locales,
        supportedLocales: const [
          Locale("fr", "FR"),
          Locale("es", "ES"),
          Locale("it", "IT"),
          Locale("ar", "SA"),
          Locale("hi", "IN"),
          Locale("zh", "ZH"),
          Locale("pt", "PT"),
          Locale("ru", "RU"),
          Locale("en", "US")
        ],
        localizationsDelegates: const [
          LocalizationStuff.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale!.languageCode &&
                supportedLocale.countryCode == locale.countryCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
        initialRoute: 'Splash',
        routes: routes,
      ),
    );
  }
}
