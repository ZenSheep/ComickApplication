abstract class IComic {
  final String slug;
  final String title;
  final int? demographic;
  final List<MdCover> mdCovers;

  const IComic({
    required this.slug,
    required this.title,
    required this.demographic,
    required this.mdCovers,
  });

  String? getImageUrl() {
    if (mdCovers.isEmpty) {
      return null;
    }
    return mdCovers.first.getImageUrl();
  }

  String getRate();
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
    return 'https://meo.comick.pictures/$b2key';
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
