import 'dart:io';

import 'package:comick_application/pages/chapter.dart';
import 'package:comick_application/requests/Models/chapterDto.dart';
import 'package:comick_application/requests/Models/comicDto.dart';
import 'package:comick_application/requests/Models/comicInformationsChaptersDto.dart';
import 'package:comick_application/requests/requests.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flag/flag.dart';
import 'package:pager/pager.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;

import '../enums/download_state.dart';
import '../utils/storage.dart';

class ComickMainWidget extends StatefulWidget {
  final ComicDto comick;

  const ComickMainWidget({Key? key, required this.comick}) : super(key: key);

  @override
  State<ComickMainWidget> createState() => _ComickMainWidgetState();
}

class _ComickMainWidgetState extends State<ComickMainWidget> {
  late Future<ComicInformationsChaptersDto> chapters;
  var _currentPage = 1;
  var _totalPages = 1;
  var _favorite = false;
  late Future<SharedPreferences> _preferences;
  Storage _storage = Storage('comick');

  void resetStorage() {
    setState(() {
      _storage = Storage('comick');
    });
  }

  @override
  void initState() {
    super.initState();
    var comic = widget.comick;
    chapters = getChaptersFromSlug(comic.slug, _currentPage);
    chapters.then((value) => setState(() {
          _totalPages = value.getNumberOfPages();
        }));
    _preferences = SharedPreferences.getInstance();
    _preferences.then((value) => setState(() {
          _favorite = value.getInt(widget.comick.slug) != null;
        }));
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.comick.getImageUrl();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.comick.title),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              SizedBox(
                height: 300,
                width: 225,
                child: imageUrl != ""
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.fill,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      )
                    : null,
              ),
              FutureBuilder<SharedPreferences>(
                future: _preferences,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return ButtonBar(
                      alignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(_favorite
                              ? Icons.favorite
                              : Icons.favorite_border),
                          onPressed: () {
                            if (_favorite) {
                              snapshot.data!.remove(widget.comick.slug);
                            } else {
                              snapshot.data!.setInt(widget.comick.slug, 1);
                            }
                            setState(() {
                              _favorite = !_favorite;
                            });
                          },
                        ),
                      ],
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
            ],
          ),
          Expanded(
            child: FutureBuilder<ComicInformationsChaptersDto>(
              future: chapters,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  return ListView.separated(
                    itemCount: snapshot.data!.chapters.length,
                    itemBuilder: (context, index) {
                      final chapter = snapshot.data!.chapters[index];
                      return ChapterCustomCard(
                          chapter: chapter, slug: widget.comick.slug, imageUrl: imageUrl, title: widget.comick.title, storage: _storage, resetStorage: resetStorage,);
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
          Pager(
            currentPage: _currentPage,
            totalPages: _totalPages,
            numberButtonSelectedColor: Colors.pink,
            pagesView: 3,
            numberTextSelectedColor: Colors.white,
            numberTextUnselectedColor: Colors.white,
            onPageChanged: (page) {
              setState(() {
                _currentPage = page;
                chapters =
                    Future<ComicInformationsChaptersDto>.value(ComicInformationsChaptersDto.empty());
                getChaptersFromSlug(widget.comick.slug, _currentPage).then((value) {
                  setState(() {
                    chapters = Future<ComicInformationsChaptersDto>.value(value);
                  });
                });
              });
            },
          ),
        ],
      ),
    );
  }
}

class ChapterCustomCard extends StatefulWidget {
  final ChapterDto chapter;
  final String slug;
  final String imageUrl;
  final String title;
  final Storage storage;
  final VoidCallback resetStorage;

  const ChapterCustomCard({Key? key, required this.chapter, required this.slug, required this.imageUrl, required this.title, required this.storage, required this.resetStorage})
      : super(key: key);

  @override
  State<ChapterCustomCard> createState() => _ChapterCustomCardState();
}

class _ChapterCustomCardState extends State<ChapterCustomCard> {
  var _downloading = DownloadState.notDownloaded;
  var _isRead = false;
  var _percent = 0.0;

  @override
  void initState() {
    super.initState();

    widget.storage.wasChapterRead(widget.slug, widget.chapter.getGroupName(), widget.chapter.chap).then((value) {
      setState(() {
        _isRead = value;
      });
    });

    getChaptersPath(widget.title, widget.slug, widget.chapter.getGroupName()).then((value) {
      final directoryPath = path.join(value, widget.chapter.chap);
      if (Directory(directoryPath).existsSync()) {
        setState(() {
          _downloading = DownloadState.downloaded;
        });
      }
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
              pageBuilder: (context, animation, secondaryAnimation) =>
                  ChapterMainWidget(chapter: widget.chapter, slug: widget.slug, storage: widget.storage),
            ),
          ).then((value) => setState(() { widget.resetStorage(); }));
        },
        child: Card(
          color: const Color(0x00fafafa),
          elevation: 0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 12.0,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'CH. ${widget.chapter.chap} ',
                            style:
                                TextStyle(fontWeight: FontWeight.bold, color: _isRead ? Colors.grey : Colors.white)),
                        if (widget.chapter.vol != null ||
                            widget.chapter.title != null)
                          const TextSpan(text: '\n'),
                        TextSpan(
                            text: widget.chapter.vol != null
                                ? "Vol. ${widget.chapter.vol} ${widget.chapter.title != null ? ' - ${widget.chapter.title}' : ''}"
                                : widget.chapter.title),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.arrow_upward),
                          const SizedBox(
                            width: 5,
                          ),
                          Text("${widget.chapter.up_count}"),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.update),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(widget.chapter.getCreatedDate()),
                        ],
                      ),
                    ],
                  )),
              Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.group),
                          const SizedBox(
                            width: 5,
                          ),
                          Flexible(
                            child: Text(
                              widget.chapter.getGroupName(),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 30,
                            height: 20,
                            child: Flag.fromString(
                              widget.chapter.getFlagCode(),
                              borderRadius: 8,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
              Expanded(
                flex: 1,
                child: ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    _downloading == DownloadState.downloading
                        ? CircularPercentIndicator(
                            radius: 25.0,
                            percent: _percent,
                            center: Text("${(_percent * 100).toInt()}%"),
                            progressColor: Colors.green,
                          )
                        : _downloading == DownloadState.notDownloaded
                            ? IconButton(
                                icon: const Icon(Icons.file_download),
                                onPressed: kIsWeb
                                    ? null
                                    : () {
                                        setState(() {
                                          _downloading = DownloadState.downloading;
                                        });
                                        downloadChapter(widget.title, widget.chapter.hid, widget.slug, widget.imageUrl)
                                            .forEach((element) {
                                          setState(() {
                                            if (element == -1) {
                                              showDialog(
                                                  context: context,
                                                  builder: (BuildContext
                                                          context) =>
                                                      const AlertDialog(
                                                          title: Text(
                                                              "Error during download")));
                                              _downloading = DownloadState.notDownloaded;
                                              _percent = 0.0;
                                            } else if (element == 1) {
                                              _downloading = DownloadState.downloaded;
                                              _percent = 0.0;
                                            } else {
                                              _percent = element;
                                            }
                                          });
                                        });
                                      },
                              )
                            : const Icon(Icons.check),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
