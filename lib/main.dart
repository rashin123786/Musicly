import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:musicly/controllers/DbProviders/fav_db_controller.dart';
import 'package:musicly/controllers/DbProviders/playlist_controller.dart';
import 'package:musicly/controllers/providers/my_music_controller.dart';

import 'package:musicly/screens/splashScreen/splash_screen.dart';

import 'package:musicly/widgets/song_model.dart';
import 'package:provider/provider.dart';
import 'controllers/providers/bottom_nav_controller.dart';
import 'controllers/providers/fav_music_play_controller.dart';
import 'controllers/providers/search_controller.dart';
import 'model/musicly_model.dart';
import 'package:just_audio_background/just_audio_background.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(MusiclyModelAdapter().typeId)) {
    Hive.registerAdapter(MusiclyModelAdapter());
  }
  await Hive.openBox<int>('FavoriteDB');
  await Hive.openBox<MusiclyModel>('playlistDb');
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  runApp(ChangeNotifierProvider(
    create: (context) => SongModelProvider(),
    child: const Musicly(),
  ));
}

class Musicly extends StatelessWidget {
  const Musicly({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SearchController(),
        ),
        ChangeNotifierProvider(
          create: (context) => FavouriteDb(),
        ),
        ChangeNotifierProvider(
          create: (context) => BottomNavControll(),
        ),
        ChangeNotifierProvider(
          create: (context) => MyMusicController(),
        ),
        ChangeNotifierProvider(
          create: (context) => FavMusicPlayController(),
        ),
        ChangeNotifierProvider(
          create: (context) => PlayListDb(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
          primarySwatch: Colors.green,
        ),
        home: const ScreenSplash(),
      ),
    );
  }
}
