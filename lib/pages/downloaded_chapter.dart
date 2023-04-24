import 'dart:io';

import 'package:comick_application/pages/downloaded_pages.dart';
import 'package:comick_application/requests/requests.dart';
import 'package:comick_application/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

class DownloadedChapter {
  String chap;
  String comicSlug;
  String groupSlug;
  String? title;

  DownloadedChapter(
      {required this.chap, required this.comicSlug, required this.groupSlug, required this.title});
}

class DownloadedChapterMainWidget extends StatefulWidget {
  final String slug;
  final String? title;
  const DownloadedChapterMainWidget({Key? key, required this.slug, required this.title})
      : super(key: key);

  @override
  State<DownloadedChapterMainWidget> createState() =>
      _DownloadedChapterMainWidgetState();
}

class _DownloadedChapterMainWidgetState
    extends State<DownloadedChapterMainWidget> {
  late Future<List<DownloadedChapter>> chapters;
  Storage storage = Storage('comick');

  void resetStorage() {
    setState(() {
      storage = Storage('comick');
    });
  }

  @override
  void initState() {
    super.initState();
    chapters = getComicPath(widget.title, widget.slug).then(((value) async {
      final downloadsDirectory = Directory(value);
      if (downloadsDirectory.existsSync()) {
        var list = <DownloadedChapter>[];
        for (var groupSlug in downloadsDirectory.listSync()) {
          if (groupSlug.path.endsWith("cover.png")) {
            continue;
          }
          for (var chapter in Directory(groupSlug.path).listSync()) {
            final downloadedChapter = DownloadedChapter(
                title: widget.title,
                chap: path.basename(chapter.path),
                comicSlug: widget.slug,
                groupSlug: path.basename(groupSlug.path));
            list.add(downloadedChapter);
          }
        }
        return list;
      }
      return [];
    }));
  }

  void removeChapter(DownloadedChapter chapter) async {
    getChaptersPath(chapter.title, chapter.comicSlug, chapter.groupSlug).then(((value) {
      final chapterDirectory = Directory(path.join(value, chapter.chap));
      chapterDirectory.deleteSync(recursive: true);
      chapters.then((value) {
        value.remove(chapter);
        if (value.isEmpty) {
          getComicPath(chapter.title, chapter.comicSlug).then(((value) {
            final downloadsDirectory = Directory(value);
            downloadsDirectory.deleteSync(recursive: true);
          }));
        }
        setState(() {
          chapters = Future.value(value);
        });
      });
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? widget.slug),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<DownloadedChapter>>(
              future: chapters,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.separated(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final chapter = snapshot.data![index];
                      return DownloadedChapterCustomCard(
                          chapter: chapter, removeChapter: removeChapter, storage: storage, resetStorage: resetStorage,);
                    },
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return const Center(
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.pink,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DownloadedChapterCustomCard extends StatefulWidget {
  final DownloadedChapter chapter;
  final Function removeChapter;
  final Storage storage;
  final VoidCallback resetStorage;

  const DownloadedChapterCustomCard(
      {Key? key, required this.chapter, required this.removeChapter, required this.storage, required this.resetStorage})
      : super(key: key);

  @override
  State<DownloadedChapterCustomCard> createState() =>
      _DownloadedChapterCustomCardState();
}

class _DownloadedChapterCustomCardState
    extends State<DownloadedChapterCustomCard> {

  bool isRead = false;

  @override
  void initState() {
    super.initState();
    widget.storage.wasChapterRead(widget.chapter.comicSlug, widget.chapter.groupSlug, widget.chapter.chap).then((value) {
      setState(() {
        isRead = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
              return DownloadedPagesMainWidget(
                chapter: widget.chapter,
                storage: widget.storage,
              );
            }),
          ).then((value) => setState(() { widget.resetStorage(); }));
        },
        child: Card(
          color: const Color(0x00fafafa),
          elevation: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Chap. ${widget.chapter.chap} - ${widget.chapter.groupSlug}',
                style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isRead ? Colors.grey : Colors.white),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  widget.removeChapter(widget.chapter);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
