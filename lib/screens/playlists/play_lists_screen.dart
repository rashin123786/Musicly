import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:musicly/screens/playlists/play_lists_singl.dart';
import 'package:provider/provider.dart';

import '../../model/musicly_model.dart';
import '../../providers/DbProviders/playlist_controller.dart';
import '../../widgets/styles.dart';

class PlayListScreen extends StatelessWidget {
  const PlayListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<PlayListDb>(context).playlistDb;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        title: Text(
          'PlayLists',
          style: AppStyles().myMusicStyleHead,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          newplaylist(context, _formKey);
        },
        child: const Icon(Icons.add),
      ),
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: ValueListenableBuilder(
                  valueListenable:
                      Hive.box<MusiclyModel>('playlistDb').listenable(),
                  builder: (BuildContext context, Box<MusiclyModel> musicList,
                      Widget? child) {
                    return Hive.box<MusiclyModel>('playlistDb').isEmpty
                        ? Center(
                            child: SizedBox(
                              height: 300,
                              width: 200,
                              child: InkWell(
                                  onTap: () {
                                    newplaylist(context, _formKey);
                                  },
                                  child: Center(
                                    child: Text(
                                      'ADD NEW PLAYLISTS',
                                      style: AppStyles().myMusicStyleHead,
                                    ),
                                  )),
                            ),
                          )
                        : ListView.builder(
                            itemBuilder: ((context, index) {
                              final data = musicList.values.toList()[index];

                              return Card(
                                elevation: 5,
                                shadowColor:
                                    const Color.fromARGB(255, 98, 255, 103),
                                color: const Color.fromARGB(255, 27, 28, 27),
                                child: ListTile(
                                  title: Text(
                                    data.name,
                                    style: AppStyles().myMusicStyleHead,
                                  ),
                                  trailing: PopupMenuButton(
                                    icon: const Icon(
                                      Icons.more_vert,
                                      color: Colors.green,
                                    ),
                                    color:
                                        const Color.fromARGB(255, 54, 54, 54),
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(
                                        value: 1,
                                        child: Text(
                                          'Edit',
                                          style: TextStyle(color: Colors.green),
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        value: 2,
                                        child: Text(
                                          'Delete',
                                          style: TextStyle(color: Colors.green),
                                        ),
                                      )
                                    ],
                                    onSelected: (value) {
                                      if (value == 1) {
                                        editPlaylistName(context, data, index);
                                      } else if (value == 2) {
                                        deletePlayList(
                                            context, musicList, index);
                                      }
                                    },
                                  ),
                                  // trailing: IconButton(
                                  //     onPressed: (() {
                                  //       deletePlayList(
                                  //           context, musicList, index);
                                  //     }),
                                  //     icon: const Icon(
                                  //       Icons.delete,
                                  //       color: Colors.red,
                                  //     )),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PlayListSingle(
                                            playlist: data,
                                            findex: index,
                                          ),
                                        ));
                                  },
                                ),
                              );
                            }),
                            itemCount: musicList.length,
                          );
                  },
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
TextEditingController nameController = TextEditingController();

Future<dynamic> deletePlayList(
    BuildContext context, Box<MusiclyModel> musicList, int index) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: const Color.fromARGB(255, 56, 56, 56),
        title: const Text(
          'Delete Playlist',
          style: TextStyle(color: Colors.white, fontFamily: 'poppins'),
        ),
        content: const Text('Are you sure you want to delete this playlist?',
            style: TextStyle(color: Colors.white, fontFamily: 'poppins')),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('No',
                style: TextStyle(
                  color: Colors.greenAccent,
                )),
          ),
          TextButton(
            onPressed: () {
              musicList.deleteAt(index);
              Navigator.pop(context);
              const snackBar = SnackBar(
                backgroundColor: Colors.black,
                content: Text(
                  'Playlist is deleted',
                  style: TextStyle(color: Colors.white),
                ),
                duration: Duration(milliseconds: 350),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            child:
                const Text('Yes', style: TextStyle(color: Colors.greenAccent)),
          ),
        ],
      );
    },
  );
}

Future newplaylist(BuildContext context, formKey) {
  return showDialog(
    context: context,
    builder: (ctx) => SimpleDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      backgroundColor: const Color.fromARGB(255, 59, 59, 59),
      children: [
        SimpleDialogOption(
          child: Text(
            'New Playlist',
            style: AppStyles().myMusicStyleHead,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        SimpleDialogOption(
          child: Form(
            key: formKey,
            child: TextFormField(
              validator: (value) =>
                  value!.isEmpty ? 'Please Enter a Name' : null,
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter a Name',
                hintStyle: TextStyle(
                  color: Color.fromARGB(255, 99, 99, 99),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).pop();
                nameController.clear();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  saveButtonPressed(context);
                }
              },
              child: const Text(
                'Create',
                style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Future<void> saveButtonPressed(context) async {
  final name = nameController.text.trim();
  final music = MusiclyModel(name: name, songId: []);
  final datas =
      PlayListDb().playlistDb.values.map((e) => e.name.trim()).toList();
  if (name.isEmpty) {
    return;
  } else if (datas.contains(music.name)) {
    const snackbar3 = SnackBar(
        duration: Duration(milliseconds: 750),
        content: Text(
          'playlist already exist',
          style: TextStyle(color: Colors.redAccent),
        ));
    ScaffoldMessenger.of(context).showSnackBar(snackbar3);
    Navigator.of(context).pop();
  } else {
    Provider.of<PlayListDb>(context, listen: false).addPlaylist(music);
    const snackbar4 = SnackBar(
        duration: Duration(milliseconds: 750),
        backgroundColor: Colors.black,
        content: Text(
          'Added To PlayLists',
          style: TextStyle(color: Colors.white),
        ));
    ScaffoldMessenger.of(context).showSnackBar(snackbar4);
    Navigator.pop(context);
    nameController.clear();
  }
}

Future<dynamic> editPlaylistName(
    BuildContext context, MusiclyModel data, int index) {
  nameController = TextEditingController(text: data.name);
  return showDialog(
    context: context,
    builder: (ctx) => SimpleDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      backgroundColor: const Color.fromARGB(255, 39, 39, 39),
      children: [
        const SimpleDialogOption(
          child: Text(
            "Edit Playlist ",
            style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 18,
                fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        SimpleDialogOption(
          child: Form(
            key: _formKey,
            child: TextFormField(
              textAlign: TextAlign.center,
              controller: nameController,
              maxLength: 15,
              decoration: InputDecoration(
                  counterStyle: const TextStyle(
                      color: Colors.white, fontFamily: 'poppins'),
                  fillColor: Colors.white.withOpacity(0.7),
                  filled: true,
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.only(left: 15, top: 5)),
              style: const TextStyle(
                  fontFamily: 'poppins',
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Enter your playlist name";
                } else {
                  return null;
                }
              },
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).pop();
                nameController.clear();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 13,
                    fontWeight: FontWeight.w600),
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final name = nameController.text.trim();
                  if (name.isEmpty) {
                    return;
                  } else {
                    final playlistName = MusiclyModel(name: name, songId: []);
                    Provider.of<PlayListDb>(context, listen: false)
                        .editPlaylist(index, playlistName);
                  }
                  nameController.clear();
                  Navigator.pop(context);
                }
              },
              child: const Text(
                'Update',
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 13,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
