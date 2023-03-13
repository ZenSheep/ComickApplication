import 'IComicModel.dart';

class Comic extends IComic {
  final int followCount;
  final int id;
  final List<MdTitle> mdTitles;
  final String? rating;
  final int ratingCount;
  final int userFollowCount;

  const Comic({
    required this.followCount,
    required this.id,
    required this.mdTitles,
    required this.rating,
    required this.ratingCount,
    required this.userFollowCount,
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

  factory Comic.fromJson(Map<String, dynamic> json) {
    return Comic(
      demographic: json["demographic"],
      followCount: json["follow_count"] ?? 0,
      id: json["id"],
      mdCovers: (json["md_covers"] as List<dynamic>)
          .map((e) => MdCover.fromJson(e))
          .toList(),
      mdTitles: (json["md_titles"] as List<dynamic>)
          .map((e) => MdTitle.fromJson(e))
          .toList(),
      rating: json["rating"],
      ratingCount: json["rating_count"],
      slug: json["slug"],
      title: json["title"],
      userFollowCount: json["user_follow_count"],
    );
  }

  @override
  String getRate() {
    return rating ?? "";
  }
}
