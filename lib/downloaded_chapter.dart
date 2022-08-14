import 'dart:io';

import 'package:comick_application/downloaded_pages.dart';
import 'package:comick_application/requests/requests.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart' as path;

class DownloadedChapter {
  String chap;
  String comicSlug;
  String groupSlug;

  DownloadedChapter({required this.chap, required this.comicSlug, required this.groupSlug});
}

class DownloadedChapterMainWidget extends StatefulWidget {
  final String slug;
  const DownloadedChapterMainWidget({Key? key, required this.slug}) : super(key: key);

  @override
  State<DownloadedChapterMainWidget> createState() => _DownloadedChapterMainWidgetState();
}

class _DownloadedChapterMainWidgetState extends State<DownloadedChapterMainWidget> {
  late Future<List<DownloadedChapter>> chapters;


  @override
  void initState() {
    super.initState();
    chapters = getDownloadPath(widget.slug, "").then(((value) async {
      final downloadsDirectory = Directory(value);
      if (downloadsDirectory.existsSync())
      {
        var list = <DownloadedChapter>[];
        for (var groupSlug in downloadsDirectory.listSync()) {
          for (var chapter in Directory(groupSlug.path).listSync()) {
            final downloadedChapter = DownloadedChapter(
              chap: path.basename(chapter.path),
              comicSlug: widget.slug,
              groupSlug: path.basename(groupSlug.path)
            );
            list.add(downloadedChapter);
          }
        }
        return list;
      }
      return [];
    }));
  }

  void removeChapter(DownloadedChapter chapter) async {
    getDownloadPath(chapter.comicSlug, chapter.groupSlug).then(((value) {
      final chapterDirectory = Directory(path.join(value, chapter.chap));
      chapterDirectory.deleteSync(recursive: true);
      chapters.then((value) {
        value.remove(chapter);
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
        title: Text(widget.slug),
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
                      return DownloadedChapterCustomCard(chapter: chapter, removeChapter: removeChapter);
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
                      child: CircularProgressIndicator(color: Colors.pink,),
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
  const DownloadedChapterCustomCard({Key? key, required this.chapter, required this.removeChapter}) : super(key: key);

  @override
  State<DownloadedChapterCustomCard> createState() => _DownloadedChapterCustomCardState();
}

class _DownloadedChapterCustomCardState extends State<DownloadedChapterCustomCard> {
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
                  return DownloadedPagesMainWidget(chapter: widget.chapter, );
                }
              ),
            );
        },
        child: Card(
          color: const Color(0x00fafafa),
          elevation: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Chap. ${widget.chapter.chap} - ${widget.chapter.groupSlug}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
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