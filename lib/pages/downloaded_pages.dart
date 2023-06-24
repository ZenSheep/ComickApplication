import 'dart:ffi';
import 'dart:io';
import 'dart:developer' as developer;

import 'package:comick_application/pages/downloaded_chapter.dart';
import 'package:comick_application/requests/requests.dart';
import 'package:comick_application/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class DownloadedPagesMainWidget extends StatefulWidget {
  final DownloadedChapter chapter;
  final Storage storage;
  const DownloadedPagesMainWidget(
      {Key? key, required this.chapter, required this.storage})
      : super(key: key);

  @override
  State<DownloadedPagesMainWidget> createState() =>
      _DownloadedPagesMainWidgetState();
}

class _DownloadedPagesMainWidgetState extends State<DownloadedPagesMainWidget> {
  late Future<List<String>> pages;
  List<String> _chapters = [];
  int? _currentIndex;
  late Directory _chaptersDirectory;
  late String chap = widget.chapter.chap;

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  var maxIndex = 0;
  var isPreviousMaxIndexLoaded = false;

  @override
  void initState() {
    super.initState();
    pages = getChaptersPath(widget.chapter.title, widget.chapter.comicSlug,
            widget.chapter.groupSlug)
        .then(((value) async {
      var list = <String>[];
      final downloadsDirectory =
          Directory(path.join(value, widget.chapter.chap));
      if (downloadsDirectory.existsSync()) {
        for (var elt in downloadsDirectory.listSync()) {
          list.add(elt.path);
        }
      }
      final chaptersDirectory = Directory(value);
      if (chaptersDirectory.existsSync()) {
        final chaptersList = chaptersDirectory
            .listSync()
            .map((e) => path.basename(e.path))
            .toList();
        chaptersList
            .sort((a, b) => (double.parse(a).compareTo(double.parse(b))));
        final chapterIndex = chaptersList.indexOf(widget.chapter.chap);
        setState(() {
          _currentIndex = chapterIndex;
          _chapters = chaptersList;
          _chaptersDirectory = chaptersDirectory;
          chap = widget.chapter.chap;
        });
      }
      return list;
    }));

    widget.storage
        .getPageRead(widget.chapter.comicSlug, widget.chapter.groupSlug, chap)
        .then((value) {
      maxIndex = value ?? 0;
      isPreviousMaxIndexLoaded = true;
    });

    itemPositionsListener.itemPositions.addListener(() {
      final firstCardPos = itemPositionsListener.itemPositions.value.first;
      final lastCardPos = itemPositionsListener.itemPositions.value.last;
      final areCardLoaded = lastCardPos.index - firstCardPos.index <
          (itemPositionsListener.itemPositions.value.length < 20
              ? 5
              : itemPositionsListener.itemPositions.value.length / 5);

      var isGreaterThanPreviousIndex = lastCardPos.index > maxIndex;
      final canSave = areCardLoaded &&
          isGreaterThanPreviousIndex &&
          isPreviousMaxIndexLoaded;

      if (canSave) {
        maxIndex = lastCardPos.index;
        developer.log('set page saw ${widget.chapter.chap} $maxIndex');
        widget.storage.setPageSaw(
            widget.chapter.comicSlug, widget.chapter.groupSlug, chap, maxIndex);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      alignment: Alignment.topLeft,
      children: <Widget>[
        Column(
          children: [
            Expanded(
              child: FutureBuilder<List<String>>(
                future: pages,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    final data = snapshot.data!;
                    return ScrollablePositionedList.builder(
                      shrinkWrap: true,
                      itemCount: data.length + 2,
                      itemScrollController: itemScrollController,
                      itemPositionsListener: itemPositionsListener,
                      addAutomaticKeepAlives: false,
                      addRepaintBoundaries: false,
                      addSemanticIndexes: false,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return SafeArea(
                              child: ElevatedButton(
                            onPressed: maxIndex == 0
                                ? null
                                : () {
                                    developer.log('scroll to $maxIndex');
                                    itemScrollController.scrollTo(
                                        index: maxIndex,
                                        duration: const Duration(seconds: 1),
                                        curve: Curves.easeInOutCubic);
                                  },
                            child: const Text("Scroll to last view"),
                          ));
                        }
                        if (index - 1 == data.length) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: ElevatedButton.icon(
                                    onPressed: _currentIndex == null ||
                                            _currentIndex! <= 0
                                        ? null
                                        : () {
                                            var list = <String>[];
                                            final downloadsDirectory =
                                                Directory(path.join(
                                                    _chaptersDirectory.path,
                                                    _chapters[
                                                        _currentIndex! - 1]));
                                            if (downloadsDirectory
                                                .existsSync()) {
                                              for (var elt in downloadsDirectory
                                                  .listSync()) {
                                                list.add(elt.path);
                                              }
                                            }
                                            setState(() {
                                              pages = Future.value(list);
                                              chap =
                                                  _chapters[_currentIndex! - 1];
                                              _currentIndex =
                                                  _currentIndex! - 1;
                                            });
                                          },
                                    icon: const Icon(Icons.arrow_back_ios),
                                    label: const Text("Previous"),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: ElevatedButton.icon(
                                    onPressed: _currentIndex == null ||
                                            _currentIndex! >=
                                                _chapters.length - 1
                                        ? null
                                        : () {
                                            var list = <String>[];
                                            final downloadsDirectory =
                                                Directory(path.join(
                                                    _chaptersDirectory.path,
                                                    _chapters[
                                                        _currentIndex! + 1]));
                                            if (downloadsDirectory
                                                .existsSync()) {
                                              for (var elt in downloadsDirectory
                                                  .listSync()) {
                                                list.add(elt.path);
                                              }
                                            }
                                            setState(() {
                                              pages = Future.value(list);
                                              chap =
                                                  _chapters[_currentIndex! + 1];
                                              _currentIndex =
                                                  _currentIndex! + 1;
                                            });
                                          },
                                    icon: const Icon(Icons.arrow_forward_ios),
                                    label: const Text("Next"),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }

                        final page = data[index - 1];
                        return DownloadedPagesCustomCard(page: page);
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}\n${snapshot.stackTrace}");
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
        SafeArea(
          child: Padding(
              padding: const EdgeInsets.only(left: 10, top: 10),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                iconSize: 30,
                onPressed: () {
                  Navigator.pop(context);
                },
              )),
        )
      ],
    ));
  }
}

class DownloadedPagesCustomCard extends StatefulWidget {
  final String page;
  const DownloadedPagesCustomCard({Key? key, required this.page})
      : super(key: key);

  @override
  State<DownloadedPagesCustomCard> createState() =>
      _DownloadedPagesCustomCardState();
}

class _DownloadedPagesCustomCardState extends State<DownloadedPagesCustomCard> {
  @override
  Widget build(BuildContext context) {
    final imageWidth = MediaQuery.of(context).size.width < 600
        ? MediaQuery.of(context).size.width
        : 600;
    return Card(
      margin: EdgeInsets.zero,
      semanticContainer: false,
      elevation: 0,
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        SizedBox(
          width: imageWidth.toDouble(),
          child: Image.file(
            File(widget.page),
            fit: BoxFit.fitWidth,
          ),
        ),
      ]),
    );
  }
}
