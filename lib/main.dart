import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:musicly/screens/splash_screen.dart';
import 'package:musicly/widgets/song_model.dart';
import 'package:provider/provider.dart';
import 'model/musicly_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(MusiclyModelAdapter().typeId)) {
    Hive.registerAdapter(MusiclyModelAdapter());
  }

  await Hive.openBox<int>('FavoriteDB');
  await Hive.openBox<MusiclyModel>('playlistDb');

  runApp(ChangeNotifierProvider(
    create: (context) => SongModelProvider(),
    child: const Musicly(),
  ));
}

class Musicly extends StatelessWidget {
  const Musicly({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
        primarySwatch: Colors.green,
      ),
      home: const ScreenSplash(),
    );
  }
}
