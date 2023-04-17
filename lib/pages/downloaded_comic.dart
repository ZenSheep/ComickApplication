import 'dart:io';

import 'package:comick_application/pages/downloaded_chapter.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart' as path;

import '../requests/Models/DownloadedComic.dart';

class DownloadedComicMainWidget extends StatefulWidget {
  const DownloadedComicMainWidget({Key? key}) : super(key: key);

  @override
  State<DownloadedComicMainWidget> createState() =>
      _DownloadedComicMainWidgetState();
}

class _DownloadedComicMainWidgetState extends State<DownloadedComicMainWidget> {
  late Future<List<DownloadedComic>> comics;

  @override
  void initState() {
    super.initState();
    comics =
        path_provider.getApplicationDocumentsDirectory().then(((value) async {
      final downloadsDirectory = Directory(path.join(value.path, 'downloads'));
      if (downloadsDirectory.existsSync()) {
        var list = <DownloadedComic>[];
        for (var elt in downloadsDirectory.listSync()) {
          final comic = DownloadedComic(elt.path);
          list.add(comic);
        }
        return list;
      }
      return [];
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: FutureBuilder<List<DownloadedComic>>(
            future: comics,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return ListView.separated(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final comic = snapshot.data![index];
                    return DownloadedCustomCard(comic: comic);
                  },
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('No downloaded comic'),
                );
              }
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.pink,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class DownloadedCustomCard extends StatefulWidget {
  final DownloadedComic comic;

  const DownloadedCustomCard({Key? key, required this.comic}) : super(key: key);

  @override
  State<DownloadedCustomCard> createState() => _DownloadedCustomCardState();
}

class _DownloadedCustomCardState extends State<DownloadedCustomCard> {
  @override
  Widget build(BuildContext context) {
    
    // @hack: if we remove, the app doesn't find the cover because of the spaces in the path
    // ignore: unnecessary_string_interpolations
    final cover = File('${widget.comic.cover}');
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.94,
      height: MediaQuery.of(context).size.width * 0.28,
      child: GestureDetector(
        onTap: () async {
          await Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  DownloadedChapterMainWidget(slug: widget.comic.slug, title: widget.comic.title,),
            ),
          );
        },
        child: Card(
          color: const Color(0x00fafafa),
          elevation: 0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width * 0.20,
                    maxWidth: MediaQuery.of(context).size.width * 0.20,
                    minHeight: MediaQuery.of(context).size.width * 0.28,
                    maxHeight: MediaQuery.of(context).size.width * 0.28,
                  ),
                  child: cover.existsSync()
                      ? Image.file(
                          cover,
                          fit: BoxFit.fill,
                        )
                      : null,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.comic.title ?? widget.comic.slug,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: Align(
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.arrow_forward_ios)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
