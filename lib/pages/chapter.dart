import 'dart:async';

import 'package:comick_application/requests/Models/chapterDto.dart';
import 'package:comick_application/requests/Models/mdImageDto.dart';
import 'package:comick_application/requests/requests.dart';
import 'package:comick_application/utils/storage.dart';
import 'package:flutter/material.dart';

import '../requests/Models/chapterWithPagesInformationDto.dart';

class ChapterMainWidget extends StatefulWidget {
  final ChapterDto chapter;
  final Storage storage;
  final String slug;

  const ChapterMainWidget({Key? key, required this.chapter, required this.storage, required this.slug}) : super(key: key);

  @override
  State<ChapterMainWidget> createState() => _ChapterMainWidgetState();
}

class _ChapterMainWidgetState extends State<ChapterMainWidget> {
  late Future<ChapterWithPagesInformationDto> pages;
  late String? chap;

  @override
  void initState() {
    super.initState();
    pages = getPagesFromHid(widget.chapter.hid);
    chap = widget.chapter.chap;
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
                  if (snapshot.hasData && snapshot.data != null) {
                    final data = snapshot.data!;

                    widget.storage.setChapterRead(widget.slug, widget.chapter.getGroupName(), data.chapter.chap);

                    return ListView(children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount: data.chapter.md_images.length,
                        addAutomaticKeepAlives: false,
                        addRepaintBoundaries: false,
                        addSemanticIndexes: false,
                        itemBuilder: (context, index) {
                          final page = data.chapter.md_images[index];
                          return ChapterCustomCard(page: page);
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: ElevatedButton.icon(
                                onPressed: data.prev == null
                                    ? null
                                    : () {
                                        setState(() {
                                          pages =
                                              getPagesFromHid(data.prev!.hid);
                                        });
                                      },
                                icon: const Icon(Icons.arrow_back_ios),
                                label: const Text("Previous"),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: ElevatedButton.icon(
                                onPressed: data.next == null
                                    ? null
                                    : () {
                                        setState(() {
                                          pages =
                                              getPagesFromHid(data.next!.hid);
                                        });
                                      },
                                icon: const Icon(Icons.arrow_forward_ios),
                                label: const Text("Next"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ]);
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
