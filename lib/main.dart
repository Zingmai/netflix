import 'package:flutter/material.dart';
import 'package:netflix/providers/account.dart';
import 'package:netflix/providers/entry.dart';
import 'package:netflix/providers/watchlist.dart';
import 'package:netflix/screens/onboarding.dart';
import 'package:provider/provider.dart';
import 'screens/navaigation.dart';

Future<void> main()async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => AccountProvider(),),
      ChangeNotifierProvider(create: (context) => EntryProvider(),),
      ChangeNotifierProvider(create: (context) => WatchListProvider(),),
    ],
      child: const Main()),
  );
}

class Main extends StatelessWidget {
  const Main({Key? key}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Netflix',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: context.read<AccountProvider>().isValid(),
        builder: (context, snapshot) => context.watch<AccountProvider>().session == null ? const OnboardingScreen(): const NavScreen(),
      ),
    );
  }
}
