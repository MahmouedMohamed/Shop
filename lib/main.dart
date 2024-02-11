import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ny_shop/BackgroundScreen.dart';
import 'package:ny_shop/CustomWidgets/CustomSpacing.dart';
import 'package:ny_shop/GeneralInfo.dart';
import 'package:ny_shop/ProductsScreen.dart';
import 'package:ny_shop/RegisterationScreens/ForgetPasswordScreen.dart';
import 'package:ny_shop/RegisterationScreens/LoginScreen.dart';
import 'package:ny_shop/RegisterationScreens/RegisterScreen.dart';
import 'package:ny_shop/Session/SessionManager.dart';
import 'package:ny_shop/SharedData/AppLanguage.dart';
import 'package:ny_shop/SharedData/AppTheme.dart';
import 'package:ny_shop/SharedData/ButtonData.dart';
import 'package:ny_shop/SharedData/CartData.dart';
import 'package:ny_shop/SharedData/CommonData.dart';
import 'package:ny_shop/SplashScreen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  ErrorWidget.builder = (errorDetails) {
    return const Text('Something went wrong');
  };
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Delius',
        textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Delius'),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      routes: <String, WidgetBuilder>{
        'SplashScreen': (BuildContext context) => const SplashScreen(),
        'MainScreen': (BuildContext context) => MainScreen(),
        'LoginScreen': (BuildContext context) => const LoginScreen(),
        'RegisterScreen': (BuildContext context) => const RegisterScreen(),
        'ForgetPasswordScreen': (BuildContext context) =>
            const ForgetPasswordScreen(),
      },
    );
  }
}

class MainScreen extends StatelessWidget {
  final SessionManager sessionManager = SessionManager();
  static late AppTheme appTheme;
  static late AppLanguage appLanguage;
  final CommonData commonData = CommonData();
  final CartData cartData = CartData();
  final ButtonData buttonData = ButtonData();
  MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    appTheme = AppTheme(context);
    appLanguage = AppLanguage(sessionManager.loadPreferredLanguage());
    return MultiProvider(providers: [
      ChangeNotifierProvider<AppTheme>(
        create: (context) => appTheme,
      ),
      ChangeNotifierProvider<AppLanguage>(
        create: (context) => appLanguage,
      ),
      ChangeNotifierProvider<CommonData>(
        create: (context) => commonData,
      ),
      ChangeNotifierProvider<CartData>(
        create: (context) => cartData,
      ),
      ChangeNotifierProvider<ButtonData>(
        create: (context) => buttonData,
      ),
    ], child: const BackgroundScreen());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late final TabController tabController;
  static late double w, h;
  late final SessionManager sessionManager = SessionManager();
  static late CommonData commonData;
  static late CartData cartData;
  static late AppLanguage appLanguage;
  static late AppTheme appTheme;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    commonData = Provider.of<CommonData>(context);
    cartData = Provider.of<CartData>(context);
    appTheme = Provider.of<AppTheme>(context);
    appLanguage = Provider.of<AppLanguage>(context);
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: h / 10,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Image.asset(
            'assets/images/NY.png',
            fit: BoxFit.contain,
            height: h / 15,
          ),
          actions: [
            IconButton(
                onPressed: () {
                  commonData.changeStep(Pages.CheckoutScreen.index);
                  return;
                },
                icon: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: w / 50, vertical: h / 50),
                      child: Icon(
                        Icons.shopping_cart_outlined,
                        color: const Color.fromRGBO(140, 158, 182, 1.0),
                        size: h / 25,
                      ),
                    ),
                    if (cartData.cartData.isNotEmpty)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          margin: EdgeInsets.zero,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                          child: Text(cartData.cartData.length.toString(),
                              style: const TextStyle(color: Colors.white)),
                        ),
                      )
                  ],
                ))
          ],
          leadingWidth: w / 7,
          leading: GestureDetector(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: w / 100),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 3),
                    shape: BoxShape.circle,
                  ),
                  child: PopupMenuButton(
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: ClipOval(
                        child: sessionManager.user!.photoUrl != null
                            ? Image.network(
                                sessionManager.user!.photoUrl!,
                                fit: BoxFit.contain,
                                width: w / 7,
                                height: h / 25,
                              )
                            : Image.asset(
                                'assets/images/user.png',
                                fit: BoxFit.cover,
                                width: w / 7,
                                height: h / 25,
                              ),
                      ),
                    ),
                    onSelected: (value) {
                      if (value == 'Profile') {
                        commonData.changeStep(Pages.ProfileScreen.index);
                        return;
                      } else if (value == 'Logout') {
                        sessionManager.logout();
                        FirebaseAuth.instance.signOut();
                        Navigator.popUntil(context, (route) => false);
                        Navigator.pushNamed(context, 'LoginScreen');
                        return;
                      }
                    },
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          value: 'Profile',
                          child: Text(
                            'My Profile',
                            style: appTheme.nonStaticGetTextStyle(
                                1.5,
                                Colors.black,
                                appTheme.mediumTextSize(context),
                                FontWeight.w500,
                                1.0,
                                TextDecoration.none),
                          ),
                        ),
                        PopupMenuItem(
                          value: 'Logout',
                          child: Text(
                            'Logout',
                            style: appTheme.nonStaticGetTextStyle(
                                1.5,
                                Colors.black,
                                appTheme.mediumTextSize(context),
                                FontWeight.w500,
                                1.0,
                                TextDecoration.none),
                          ),
                        ),
                      ];
                    },
                  ),
                )),
          )),
      body: Container(
        color: const Color.fromRGBO(241, 244, 249, 1),
        child: Column(children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(
                top: h / 40, left: w / 30, right: w / 30, bottom: h / 50),
            alignment: Alignment.topLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Home',
                  style: appTheme.nonStaticGetTextStyle(
                      1.5,
                      const Color.fromRGBO(24, 44, 84, 1),
                      appTheme.largeTextSize(context),
                      FontWeight.w700,
                      1.0,
                      TextDecoration.none),
                ),
                const CustomSpacing(value: 50),
                TextField(
                  cursorColor: const Color.fromRGBO(127, 148, 174, 1),
                  enabled: false,
                  decoration: InputDecoration(
                    hintText: 'Watches, straps, accessories',
                    isDense: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(),
                    hintStyle: appTheme.nonStaticGetTextStyle(
                        1.5,
                        Colors.grey.withOpacity(0.5),
                        appTheme.mediumTextSize(context),
                        FontWeight.w600,
                        1.0,
                        TextDecoration.none),
                    hintFadeDuration: const Duration(milliseconds: 500),
                    fillColor: const Color.fromRGBO(241, 244, 249, 1),
                    hoverColor: const Color.fromRGBO(241, 244, 249, 1),
                    focusColor: const Color.fromRGBO(241, 244, 249, 1),
                    prefixIcon: Padding(
                      padding: EdgeInsets.symmetric(horizontal: w / 40),
                      child: Icon(Icons.search,
                          color: const Color.fromRGBO(127, 148, 174, 1),
                          weight: h / 30,
                          size: h / 30),
                    ),
                    filled: true,
                    prefixIconConstraints:
                        BoxConstraints(minWidth: w / 20, minHeight: h / 20),
                  ),
                ),
                TabBar(
                  controller: tabController,
                  labelColor: const Color.fromRGBO(31, 52, 90, 1),
                  indicatorColor: const Color.fromRGBO(228, 174, 138, 1),
                  unselectedLabelColor: Colors.grey.withOpacity(0.7),
                  labelStyle: appTheme.nonStaticGetTextStyle(
                      1.5,
                      const Color.fromRGBO(24, 44, 84, 1),
                      appTheme.mediumTextSize(context) * 1.5,
                      FontWeight.w400,
                      1.0,
                      TextDecoration.none),
                  unselectedLabelStyle: appTheme.nonStaticGetTextStyle(
                      1.5,
                      Colors.grey.withOpacity(0.5),
                      appTheme.mediumTextSize(context) * 1.2,
                      FontWeight.w600,
                      1.0,
                      TextDecoration.none),
                  dividerHeight: 0,
                  indicator: UnderlineTabIndicator(
                      insets: EdgeInsets.symmetric(horizontal: w / 30),
                      borderSide: const BorderSide(
                          color: Color.fromRGBO(228, 174, 138, 1), width: 3)),
                  tabs: const <Widget>[
                    Tab(
                      icon: Text(
                        'Watches',
                      ),
                    ),
                    Tab(
                      icon: Text('Wallets'),
                    ),
                    Tab(
                      icon: Text('Belts'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const CustomSpacing(
            value: 100,
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: const <Widget>[
                Center(
                  child: ProductsScreen(type: 'watches'),
                ),
                Center(
                  child: ProductsScreen(type: 'wallets'),
                ),
                Center(
                  child: ProductsScreen(type: 'belts'),
                ),
              ],
            ),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Call Us',
        backgroundColor: Colors.brown.shade400,
        child: const Icon(Icons.phone, color: Colors.white),
      ),
    );
  }
}
