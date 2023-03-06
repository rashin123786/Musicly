import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:musicly/providers/DbProviders/fav_db_controller.dart';
import 'package:musicly/providers/DbProviders/playlist_controller.dart';
import 'package:musicly/providers/fav_music_play_controller.dart';
import 'package:musicly/screens/splash_screen.dart';
import 'package:musicly/providers/search_controller.dart';
import 'package:musicly/widgets/song_model.dart';
import 'package:provider/provider.dart';
import 'model/musicly_model.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'providers/bottom_nav_controller.dart';
import 'providers/my_music_controller.dart';
import 'widgets/all_songs_view.dart';

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
        ListenableProvider(
          create: (context) => SearchController(),
        ),
        ListenableProvider(
          create: (context) => FavouriteDb(),
        ),
        ListenableProvider(
          create: (context) => BottomNavControll(),
        ),
        ListenableProvider(
          create: (context) => AllSongsView(),
        ),
        ListenableProvider(
          create: (context) => MyMusicController(),
        ),
        ListenableProvider(
          create: (context) => FavMusicPlayController(),
        ),
        ListenableProvider(
          create: (context) => PlayListDb(),
        )
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
