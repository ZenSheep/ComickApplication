class Comick {
  final int? demographic;
  final int followCount;
  final int id;
  final List<MdCover> mdCovers;
  final List<MdTitle> mdTitles;
  final String? rating;
  final int ratingCount;
  final String slug;
  final String title;
  final int userFollowCount;
  
  const Comick({
    required this.demographic,
    required this.followCount,
    required this.id,
    required this.mdCovers,
    required this.mdTitles,
    required this.rating,
    required this.ratingCount,
    required this.slug,
    required this.title,
    required this.userFollowCount,
  });

  factory Comick.fromJson(Map<String, dynamic> json) {
    return Comick(
      demographic: json["demographic"],
      followCount: json["follow_count"],
      id: json["id"],
      mdCovers: (json["md_covers"] as List<dynamic>).map((e) => MdCover.fromJson(e)).toList(),
      mdTitles: (json["md_titles"] as List<dynamic>).map((e) => MdTitle.fromJson(e)).toList(),
      rating: json["rating"],
      ratingCount: json["rating_count"],
      slug: json["slug"],
      title: json["title"],
      userFollowCount: json["user_follow_count"],
    );
  }

  String? getImageUrl() {
    if (mdCovers.isEmpty) {
      return null;
    }
    return mdCovers.first.getImageUrl();
  }
}

class MdCover {
  final String b2key;
  final int h;
  final String? vol;
  final int w;

  MdCover({
    required this.b2key,
    required this.h,
    required this.vol,
    required this.w,
  });

  factory MdCover.fromJson(Map<String, dynamic> json) {
    return MdCover(
      b2key: json["b2key"],
      h: json["h"],
      vol: json["vol"],
      w: json["w"],
    );
  }

  String getImageUrl() {
    return 'https://meo.comick.pictures/${b2key}';
  }
}

class MdTitle {
  final String title;

  MdTitle({
    required this.title,
  });

  factory MdTitle.fromJson(Map<String, dynamic> json) {
    return MdTitle(
      title: json["title"],
    );
  }
}