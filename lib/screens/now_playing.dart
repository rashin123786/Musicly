import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicly/screens/lyrics.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../controllers/all_songs.dart';
import '../widgets/styles.dart';
import 'favourites/favourite_music.dart';

// ignore: must_be_immutable
class NowPlaying extends StatefulWidget {
  NowPlaying({super.key, required this.songModelList, this.count = 0});
  List<SongModel> songModelList;
  int count;

  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  Duration _duration = const Duration();
  Duration _position = const Duration();
  bool _firstsong = false;
  bool _lastSong = false;
  int large = 0;
  bool _isShuffling = false;
  List<AudioSource> songList = [];
  int currentIndex = 0;

  int counter = 0;
  @override
  void initState() {
    GetAllSongController.audioPlayer.currentIndexStream.listen((index) {
      if (index != null) {
        GetAllSongController.currentIndexes = index;
        setState(() {
          large = widget.count - 1;
          currentIndex = index;
          index == 0 ? _firstsong = true : _firstsong = false;
          index == large ? _lastSong = true : _lastSong = false;
        });

        log('index of last song ${widget.count}');
      }
    });
    super.initState();
    playSong();
  }

  String _formatDuration(Duration? duration) {
    if (duration == null) {
      return '';
    } else {
      String minutes = duration.inMinutes.toString().padLeft(2, '0');
      String seconds =
          duration.inSeconds.remainder(60).toString().padLeft(2, '0');
      return '$minutes:$seconds';
    }
  }

  void playSong() {
    GetAllSongController.audioPlayer.play();
    GetAllSongController.audioPlayer.durationStream.listen((d) {
      setState(() {
        _duration = d!;
      });
    });
    GetAllSongController.audioPlayer.positionStream.listen((p) {
      setState(() {
        _position = p;
      });
    });
  }

  bool isLyrics = false;
  String resultext = 'not Found';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(
                        width: 70,
                      ),
                      Text(
                        'Now Playing',
                        style: AppStyles().myMusicStyleHead,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Center(
                  child: isLyrics
                      ? Card(
                          elevation: 5,
                          shadowColor: const Color.fromARGB(255, 98, 255, 103),
                          color: const Color.fromARGB(255, 27, 28, 27),
                          child: SizedBox(
                            height: 310,
                            width: 350,
                            child: ListView(
                              children: [
                                const Text(
                                  'Lyrics',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(255, 66, 255, 138)),
                                ),
                                Center(
                                  child: Text(
                                    resultext,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      : const CircleAvatar(
                          backgroundColor: Colors.greenAccent,
                          radius: 100,
                          child: Icon(
                            Icons.music_note_rounded,
                            size: 80,
                          ),
                        ),
                ),
                const SizedBox(
                  height: 70,
                ),
                Text(
                  widget.songModelList[currentIndex].displayNameWOExt,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () async {
                          setState(() {
                            if (isLyrics) {
                              const CircleAvatar(
                                backgroundColor: Colors.greenAccent,
                                radius: 100,
                                child: Icon(
                                  Icons.music_note_rounded,
                                  size: 80,
                                ),
                              );
                            } else {
                              Text(
                                resultext,
                              );
                            }
                            isLyrics = !isLyrics;
                          });

                          final allresult = await LyricsSong().getLyrics(
                              title: widget
                                  .songModelList[currentIndex].displayNameWOExt,
                              artist:
                                  '${widget.songModelList[currentIndex].artist}');
                          setState(() {
                            resultext = allresult;
                          });
                        },
                        icon: const Icon(
                          Icons.lyrics,
                          color: Colors.greenAccent,
                        )),
                    const SizedBox(
                      width: 10,
                    ),
                    FavMusicPlay(
                        songFavoriteMusicPlaying:
                            widget.songModelList[currentIndex]),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  child: SizedBox(
                    height: 30,
                    width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                                thumbColor: Colors.transparent,
                                thumbShape: const RoundSliderThumbShape(
                                    enabledThumbRadius: 0)),
                            child: Slider(
                              min: const Duration(microseconds: 0)
                                  .inSeconds
                                  .toDouble(),
                              value: _position.inSeconds.toDouble(),
                              max: _duration.inSeconds.toDouble(),
                              onChanged: (value) {
                                setState(() {
                                  changeToSeconds(value.toInt());
                                  value = value;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_formatDuration(_position),
                          style: const TextStyle(
                              color: Colors.white, fontFamily: 'poppins')),
                      Text(_formatDuration(_duration),
                          style: const TextStyle(
                              color: Colors.white, fontFamily: 'poppins')),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _isShuffling == false
                              ? GetAllSongController.audioPlayer
                                  .setShuffleModeEnabled(true)
                              : GetAllSongController.audioPlayer
                                  .setShuffleModeEnabled(false);
                        });
                      },
                      icon: StreamBuilder<bool>(
                        stream: GetAllSongController
                            .audioPlayer.shuffleModeEnabledStream,
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          _isShuffling = snapshot.data;
                          if (_isShuffling) {
                            return const Icon(
                              Icons.shuffle_rounded,
                              color: Colors.purpleAccent,
                            );
                          } else {
                            return const Icon(
                              Icons.shuffle_rounded,
                              color: Colors.white,
                            );
                          }
                        },
                      ),
                    ),
                    _firstsong
                        ? const IconButton(
                            iconSize: 40,
                            onPressed: null,
                            icon: Icon(
                              Icons.skip_previous_outlined,
                              color: Color.fromARGB(210, 102, 94, 121),
                            ))
                        : IconButton(
                            iconSize: 40,
                            onPressed: () {
                              if (GetAllSongController
                                  .audioPlayer.hasPrevious) {
                                GetAllSongController.audioPlayer
                                    .seekToPrevious();
                              }
                            },
                            icon: const Icon(
                              Icons.skip_previous_outlined,
                              color: Colors.white,
                            )),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 31, 31, 31),
                          shape: const CircleBorder()),
                      onPressed: () async {
                        if (GetAllSongController.audioPlayer.playing) {
                          await GetAllSongController.audioPlayer.pause();
                        } else {
                          await GetAllSongController.audioPlayer.play();
                          setState(() {});
                        }
                      },
                      child: StreamBuilder<bool>(
                        stream: GetAllSongController.audioPlayer.playingStream,
                        builder: (context, snapshot) {
                          bool? playingStage = snapshot.data;
                          if (playingStage != null && playingStage) {
                            return const Padding(
                              padding: EdgeInsets.all(6.0),
                              child: Icon(
                                Icons.pause_circle,
                                color: Colors.greenAccent,
                                size: 80,
                              ),
                            );
                          } else {
                            return const Padding(
                              padding: EdgeInsets.all(6.0),
                              child: Icon(
                                Icons.play_circle,
                                color: Colors.greenAccent,
                                size: 80,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    _lastSong
                        ? const IconButton(
                            iconSize: 40,
                            onPressed: null,
                            icon: Icon(
                              Icons.skip_next_outlined,
                              color: Color.fromARGB(210, 102, 94, 121),
                            ))
                        : IconButton(
                            iconSize: 40,
                            onPressed: () {
                              if (GetAllSongController.audioPlayer.hasNext) {
                                GetAllSongController.audioPlayer.seekToNext();
                              }
                            },
                            icon: const Icon(
                              Icons.skip_next_outlined,
                              color: Colors.white,
                            )),
                    IconButton(
                      onPressed: () {
                        GetAllSongController.audioPlayer.loopMode ==
                                LoopMode.one
                            ? GetAllSongController.audioPlayer
                                .setLoopMode(LoopMode.all)
                            : GetAllSongController.audioPlayer
                                .setLoopMode(LoopMode.one);
                      },
                      icon: StreamBuilder<LoopMode>(
                        stream: GetAllSongController.audioPlayer.loopModeStream,
                        builder: (context, snapshot) {
                          final loopMode = snapshot.data;
                          if (LoopMode.one == loopMode) {
                            return const Icon(Icons.repeat,
                                color: Colors.purpleAccent);
                          } else {
                            return const Icon(
                              Icons.repeat,
                              color: Colors.white,
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  void changeToSeconds(int seconds) {
    Duration duration = Duration(seconds: seconds);
    GetAllSongController.audioPlayer.seek(duration);
  }

  check() {
    if (resultext.isEmpty) {
      const Text(
        'no lyrics',
        style: TextStyle(color: Colors.white),
      );
    } else {
      Text(
        resultext,
        style: const TextStyle(color: Colors.white),
      );
    }
  }
}
