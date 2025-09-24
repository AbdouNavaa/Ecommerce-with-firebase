import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_with_firebase/features/auth/presentation/pages/signup_screen.dart';
import 'package:flutter_with_firebase/features/home/pages/homePage.dart';
import 'package:flutter_with_firebase/features/product/presentation/pages/FavoritesScreen.dart';
import 'package:flutter_with_firebase/features/search/pages/search.dart';
import 'package:flutter_with_firebase/features/admin/presentation/pages/addProduct.dart';
import 'package:flutter_with_firebase/features/admin/presentation/pages/adminHome.dart';
import 'package:flutter_with_firebase/features/admin/presentation/pages/editProduct.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/configs/theme/app_theme.dart';
import 'core/configs/theme/theme_cubit.dart';
import 'core/firebase_options.dart';
import 'core/localization/app_localization.dart';
import 'features/product/domain/usecases/get_products.dart';
import 'features/product/presentation/cubit/get_porducts_cubit.dart';
import 'features/splash/splash.dart';
import 'service_locator.dart';
import 'package:device_preview/device_preview.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDependencies();
  // runApp(
  //   DevicePreview(
  //     enabled: !kReleaseMode,
  //     builder: (context) => MyApp(), // Wrap your app
  //   ),
  // );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  static void setLocale(BuildContext context, Locale newLocale) async {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);

    // ✅ On sauvegarde le choix de la langue
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', newLocale.languageCode);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    _loadLocale();
  }

  void _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('locale');
    if (languageCode != null) {
      setState(() {
        _locale = Locale(languageCode);
      });
    }
  }

  void setLocale(Locale newLocale) {
    setState(() {
      _locale = newLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(
          create:
              (context) => ProductCubit(GetProductsUseCase())..loadProducts(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return ScreenUtilInit(
            designSize: const Size(360, 690),
            child: MaterialApp(
              // themeMode: ThemeMode.system,
              locale: _locale,
              supportedLocales: [Locale('en', ''), Locale('ar', '')],
              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              localeResolutionCallback: (locale, supportedLocales) {
                if (locale == null) return supportedLocales.first;
                for (var supportedLocale in supportedLocales) {
                  if (supportedLocale.languageCode == locale.languageCode) {
                    return supportedLocale;
                  }
                }
                return supportedLocales.first;
              },
              themeMode: themeMode,
              theme: AppTheme.appThemeLight,
              darkTheme: AppTheme.appThemeDark,
              debugShowCheckedModeBanner: false,
              home: AdminHome(),
              // home: SplashScreen(),
              routes: {
                MyFavoritesPage.id: (context) => MyFavoritesPage(),
                EditProduct.id: (context) => EditProduct(),
                SearchPage.id: (context) => SearchPage(),
                SignupScreen.id: (context) => SignupScreen(),
                HomePage.id: (context) => HomePage(),
                AdminHome.id: (context) => AdminHome(),
                AddProduct.id: (context) => AddProduct(),
              },
            ),
          );
        },
      ),
    );
  }
}
