import 'dart:io';

import 'package:comick_application/downloaded_chapter.dart';
import 'package:comick_application/requests/Models/comicInformationsModel.dart';
import 'package:comick_application/requests/requests.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart' as path;

class DownloadedComicMainWidget extends StatefulWidget {
  const DownloadedComicMainWidget({Key? key}) : super(key: key);

  @override
  State<DownloadedComicMainWidget> createState() =>
      _DownloadedComicMainWidgetState();
}

class _DownloadedComicMainWidgetState extends State<DownloadedComicMainWidget> {
  late Future<List<ComicInformations>> comics;

  @override
  void initState() {
    super.initState();
    comics =
        path_provider.getApplicationDocumentsDirectory().then(((value) async {
      final downloadsDirectory = Directory(path.join(value.path, 'downloads'));
      if (downloadsDirectory.existsSync()) {
        var list = <ComicInformations>[];
        for (var elt in downloadsDirectory.listSync()) {
          final comic = await getComicInformations(path.basename(elt.path));
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
          child: FutureBuilder<List<ComicInformations>>(
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
  final ComicInformations comic;

  const DownloadedCustomCard({Key? key, required this.comic}) : super(key: key);

  @override
  State<DownloadedCustomCard> createState() => _DownloadedCustomCardState();
}

class _DownloadedCustomCardState extends State<DownloadedCustomCard> {
  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.comic.getImageUrl();
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.94,
      height: MediaQuery.of(context).size.width * 0.28,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  DownloadedChapterMainWidget(slug: widget.comic.comic.slug),
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
                  child: imageUrl != null
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.fill,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
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
                        widget.comic.comic.title,
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
