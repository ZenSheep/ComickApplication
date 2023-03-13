import 'IComicModel.dart';

class TopComic extends IComic {
  final String contentRating;
  final List<int> genres;
  final num lastChapter;

  const TopComic({
    required this.contentRating,
    required this.genres,
    required this.lastChapter,
    required demographic,
    required mdCovers,
    required slug,
    required title,
  }) : super(
          demographic: demographic,
          mdCovers: mdCovers,
          slug: slug,
          title: title,
        );

  factory TopComic.fromJson(Map<String, dynamic> json) {
    return TopComic(
      demographic: json["demographic"],
      mdCovers: (json["md_covers"] as List<dynamic>)
          .map((e) => MdCover.fromJson(e))
          .toList(),
      slug: json["slug"],
      title: json["title"],
      contentRating: json["content_rating"],
      genres: (json["genres"] as List<dynamic>).map((e) => e as int).toList(),
      lastChapter: json["last_chapter"],
    );
  }

  @override
  String getRate() {
    return contentRating;
  }
}
