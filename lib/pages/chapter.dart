import 'dart:async';
import 'dart:developer' as developer;

import 'package:comick_application/requests/Models/chapterDto.dart';
import 'package:comick_application/requests/Models/mdImageDto.dart';
import 'package:comick_application/requests/requests.dart';
import 'package:comick_application/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../requests/Models/chapterWithPagesInformationDto.dart';

class ChapterMainWidget extends StatefulWidget {
  final ChapterDto chapter;
  final Storage storage;
  final String slug;

  const ChapterMainWidget(
      {Key? key,
      required this.chapter,
      required this.storage,
      required this.slug})
      : super(key: key);

  @override
  State<ChapterMainWidget> createState() => _ChapterMainWidgetState();
}

class _ChapterMainWidgetState extends State<ChapterMainWidget> {
  late Future<ChapterWithPagesInformationDto> pages;
  late String? chap;
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  var maxIndex = 0;
  var isPreviousMaxIndexLoaded = false;

  @override
  void initState() {
    super.initState();
    pages = getPagesFromHid(widget.chapter.hid);
    chap = widget.chapter.chap;

    widget.storage
        .getPageRead(
            widget.slug, widget.chapter.getGroupName(), widget.chapter.chap)
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
        widget.storage.setPageSaw(widget.slug, widget.chapter.getGroupName(),
            widget.chapter.chap, maxIndex);
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
              child: FutureBuilder<ChapterWithPagesInformationDto>(
                future: pages,
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.data?.chapter.md_images != null &&
                      snapshot.data!.chapter.md_images.isNotEmpty) {
                    final data = snapshot.data!;
                    return ScrollablePositionedList.builder(
                      shrinkWrap: true,
                      itemCount: data.chapter.md_images.length + 2,
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
                        if (index - 1 == data.chapter.md_images.length) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: ElevatedButton.icon(
                                    onPressed: data.prev == null
                                        ? null
                                        : () {
                                            setState(() {
                                              pages = getPagesFromHid(
                                                  data.prev!.hid);
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
                                    onPressed: data.next == null
                                        ? null
                                        : () {
                                            setState(() {
                                              pages = getPagesFromHid(
                                                  data.next!.hid);
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

                        final page = data.chapter.md_images[index - 1];
                        return ChapterCustomCard(page: page);
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

class ChapterCustomCard extends StatefulWidget {
  final MdImageDto page;
  const ChapterCustomCard({Key? key, required this.page}) : super(key: key);

  @override
  State<ChapterCustomCard> createState() => _ChapterCustomCardState();
}

class _ChapterCustomCardState extends State<ChapterCustomCard> {
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
          child: Image.network(
            widget.page.getImageUrl(),
            fit: BoxFit.fitWidth,
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
          ),
        ),
      ]),
    );
  }
}
