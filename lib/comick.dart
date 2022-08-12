import 'package:comick_application/requests/Models/chapters_model.dart';
import 'package:comick_application/requests/Models/comick_model.dart';
import 'package:comick_application/requests/requests.dart';
import 'package:flutter/material.dart';
import 'package:flag/flag.dart';
import 'package:pager/pager.dart';


class ComickMainWidget extends StatefulWidget {
  final Comick comick;

  const ComickMainWidget({Key? key, required this.comick}) : super(key: key);

  @override
  State<ComickMainWidget> createState() => _ComickMainWidgetState();
}

class _ComickMainWidgetState extends State<ComickMainWidget> {
  late Future<Chapters> chapters;
  var _currentPage = 1;
  var _totalPages = 1;

  @override
  void initState() {
    super.initState();
    chapters = getChaptersFromId(widget.comick.id, _currentPage);
    chapters.then((value) => setState(() {
      _totalPages = value.getNumberOfPages();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(  
        title: Text(widget.comick.title),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: FutureBuilder<Chapters>(
              future: chapters,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  return ListView.separated(
                    itemCount: snapshot.data!.chapters.length,
                    itemBuilder: (context, index) {
                      final chapter = snapshot.data!.chapters[index];
                      return ChapterCustomCard(chapter: chapter);
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
          Pager(
            currentPage: _currentPage,
            totalPages: _totalPages,
            numberButtonSelectedColor: Colors.pink,
            pagesView: 5,
            onPageChanged: (page) {
              setState(() {
                _currentPage = page;
                chapters = Future<Chapters>.value(Chapters(chapters: [], total: 0));
                getChaptersFromId(widget.comick.id, _currentPage).then((value) {
                  setState(() {
                    chapters = Future<Chapters>.value(value);
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
  final Chapter chapter;

  const ChapterCustomCard({Key? key, required this.chapter}) : super(key: key);

  @override
  State<ChapterCustomCard> createState() => _ChapterCustomCardState();
}

class _ChapterCustomCardState extends State<ChapterCustomCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Card(
        color: const Color(0x00fafafa),
        elevation: 0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      TextSpan(text: 'CH. ${widget.chapter.chap} ', style: const TextStyle(fontWeight: FontWeight.bold)),
                      if (widget.chapter.vol != null || widget.chapter.title != null)
                        const TextSpan(text: '\n'),
                      TextSpan(text: widget.chapter.vol != null ? "Vol. ${widget.chapter.vol} ${widget.chapter.title != null ? ' - ${widget.chapter.title}' : ''}" : widget.chapter.title ?? ''),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  const Icon(Icons.arrow_upward),
                  Text("${widget.chapter.upCount}", style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  const Icon(Icons.update),
                  const SizedBox( width: 5,),
                  Text(widget.chapter.getCreatedDate()),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  SizedBox(
                    width: 30,
                    height: 20,
                    child: Flag.fromString(widget.chapter.getFlagCode(), borderRadius: 8,),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Text(widget.chapter.groupName ?? "unknow", textAlign: TextAlign.end,),
                    ),
                  const SizedBox( width: 5,),

                    const Icon(Icons.group),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}