import 'package:comick_application/pages/comick.dart';
import 'package:comick_application/requests/Models/comicDto.dart';
import 'package:comick_application/requests/requests.dart';
import 'package:flutter/material.dart';

class SearchMainWidget extends StatefulWidget {
  const SearchMainWidget({Key? key}) : super(key: key);

  @override
  State<SearchMainWidget> createState() => _SearchMainWidgetState();
}

class _SearchMainWidgetState extends State<SearchMainWidget> {
  late Future<List<ComicDto>> comics;
  String _searchValue = "Solo Leveling";

  @override
  void initState() {
    super.initState();
    comics = getTopComics();
  }

  void updateSearchValue(String value) {
    setState(() {
      _searchValue = value.isEmpty ? "" : value;
      comics = Future<List<ComicDto>>.value([]);
      if (value.isEmpty) {
        getTopComics().then((value) {
          setState(() {
            comics = Future<List<ComicDto>>.value(value);
          });
        });
      } else {
          getComicsByName(_searchValue).then((value) {
          setState(() {
            comics = Future<List<ComicDto>>.value(value);
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Column(
        children: <Widget>[
          SearchBar(updateSearchValue: updateSearchValue),
          Expanded(
            child: FutureBuilder<List<ComicDto>>(
              future: comics,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return ListView.separated(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final comick = snapshot.data![index];
                      return SearchCustomCard(comick: comick);
                    },
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return const SizedBox(
                  height: 100,
                  width: 100,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.pink,
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

class SearchBar extends StatefulWidget {
  final ValueChanged<String> updateSearchValue;

  const SearchBar({Key? key, required this.updateSearchValue})
      : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: TextField(
        cursorColor: Colors.pink,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, color: Colors.pink),
          hintText: 'Search...',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.pink,
            ),
          ),
        ),
        onSubmitted: (value) {
          widget.updateSearchValue(value);
        },
      ),
    );
  }
}

class SearchCustomCard extends StatefulWidget {
  final ComicDto comick;

  const SearchCustomCard({Key? key, required this.comick}) : super(key: key);

  @override
  State<SearchCustomCard> createState() => _SearchCustomCardState();
}

class _SearchCustomCardState extends State<SearchCustomCard> {
  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.comick.getImageUrl();
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.94,
      height: MediaQuery.of(context).size.width * 0.28,
      child: GestureDetector(
        onTap: () async {
          var comic = widget.comick;
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    ComickMainWidget(comick: comic),
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
                  child: imageUrl != ""
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
                        widget.comick.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Rating: ${widget.comick.content_rating}",
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
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
