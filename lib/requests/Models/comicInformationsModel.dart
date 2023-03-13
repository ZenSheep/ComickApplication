import 'package:comick_application/requests/Models/IComicModel.dart';
import 'package:comick_application/requests/Models/pagesModel.dart';

class ComicInformations {
  List<Artist> artists;
  List<Artist> authors;
  ComicInformation comic;
  String demographic;
  String? englishLink;
  List<Artist> genres;
  List<String>? langList;
  bool? matureContent;

  ComicInformations({
    required this.artists,
    required this.authors,
    required this.comic,
    required this.demographic,
    this.englishLink,
    required this.genres,
    required this.langList,
    required this.matureContent,
  });

  factory ComicInformations.fromJson(Map<String, dynamic> json) {
    return ComicInformations(
      artists: (json["artists"] as List<dynamic>)
          .map((e) => Artist.fromJson(e))
          .toList(),
      authors: (json["authors"] as List<dynamic>)
          .map((e) => Artist.fromJson(e))
          .toList(),
      comic: ComicInformation.fromJson(json["comic"]),
      demographic: json["demographic"],
      englishLink: json["english_link"],
      genres: (json["genres"] as List<dynamic>)
          .map((e) => Artist.fromJson(e))
          .toList(),
      langList: json["lang_list"],
      matureContent: json["mature_content"],
    );
  }

  String? getImageUrl() {
    if (comic.mdCovers.isEmpty) {
      return null;
    }
    return comic.mdCovers.first.getImageUrl();
  }
}

class Artist {
  String name;
  String slug;

  Artist({
    required this.name,
    required this.slug,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      name: json["name"],
      slug: json["slug"],
    );
  }
}

class ComicInformation extends IComic {
  String? bayesianRating;
  int chapterCount;
  int commentCount;
  String contentRating;
  String country;
  String desc;
  int followCount;
  int followRank;
  bool hentai;
  int id;
  String iso639_1;
  String? langName;
  String? langNative;
  double? lastChapter;
  Links links;
  List<MdComicMdGenre> mdComicMdGenre;
  List<MdTitle> mdTitles;
  int? mdid;
  Mies? mies;
  MuComics? muComics;
  String parsed;
  int ratingCount;
  List<dynamic> relateFrom;
  int status;
  int userFollowCount;
  int? verificationStatus;
  int year;

  ComicInformation({
    required this.bayesianRating,
    required this.chapterCount,
    required this.commentCount,
    required this.contentRating,
    required this.country,
    required this.desc,
    required this.followCount,
    required this.followRank,
    required this.hentai,
    required this.id,
    required this.iso639_1,
    required this.langName,
    required this.langNative,
    required this.lastChapter,
    required this.links,
    required this.mdComicMdGenre,
    required this.mdTitles,
    required this.mdid,
    required this.mies,
    required this.muComics,
    required this.parsed,
    required this.ratingCount,
    required this.relateFrom,
    required this.status,
    required this.userFollowCount,
    required this.verificationStatus,
    required this.year,
    required title,
    required slug,
    required demographic,
    required mdCovers,
  }) : super(
          title: title,
          slug: slug,
          demographic: demographic,
          mdCovers: mdCovers,
        );

  factory ComicInformation.fromJson(Map<String, dynamic> json) {
    return ComicInformation(
      bayesianRating: json["bayesian_rating"],
      chapterCount: json["chapter_count"],
      commentCount: json["comment_count"],
      contentRating: json["content_rating"],
      country: json["country"],
      demographic: json["demographic"],
      desc: json["desc"],
      followCount: json["follow_count"],
      followRank: json["follow_rank"],
      hentai: json["hentai"],
      id: json["id"],
      iso639_1: json["iso639_1"],
      langName: json["lang_name"],
      langNative: json["lang_native"],
      lastChapter: json["last_chapter"] + .0,
      links: Links.fromJson(json["links"]),
      mdComicMdGenre: (json["md_comic_md_genres"] as List<dynamic>)
          .map((e) => MdComicMdGenre.fromJson(e))
          .toList(),
      mdCovers: (json["md_covers"] as List<dynamic>)
          .map((e) => MdCover.fromJson(e))
          .toList(),
      mdTitles: (json["md_titles"] as List<dynamic>)
          .map((e) => MdTitle.fromJson(e))
          .toList(),
      mdid: json["mdid"],
      mies: json["mies"] != null ? Mies.fromJson(json["mies"]) : null,
      muComics: json["mu_comics"] != null
          ? MuComics.fromJson(json["mu_comics"])
          : null,
      parsed: json["parsed"],
      ratingCount: json["rating_count"],
      relateFrom: List<dynamic>.from(json["relate_from"].map((x) => x)),
      slug: json["slug"],
      status: json["status"],
      title: json["title"],
      userFollowCount: json["user_follow_count"],
      verificationStatus: json["verification_status"],
      year: json["year"],
    );
  }

  @override
  String getRate() {
    // TODO: implement getRate
    throw UnimplementedError();
  }
}

class MdComicMdGenre {
  MdGenres md_genres;

  MdComicMdGenre({
    required this.md_genres,
  });

  factory MdComicMdGenre.fromJson(Map<String, dynamic> json) {
    return MdComicMdGenre(
      md_genres: MdGenres.fromJson(json["md_genres"]),
    );
  }
}

class MdGenres {
  String group;
  String name;
  String slug;
  String? type;

  MdGenres({
    required this.group,
    required this.name,
    required this.slug,
    this.type,
  });

  factory MdGenres.fromJson(Map<String, dynamic> json) {
    return MdGenres(
      group: json["group"],
      name: json["name"],
      slug: json["slug"],
      type: json["type"],
    );
  }
}

class Mies {
  List<dynamic> my_relateds_miesTomy_relateds_my_id;
  List<MyRelatedsMiesTomyRelatedsRelatedID>
      my_relateds_miesTomy_relateds_related_id;

  Mies({
    required this.my_relateds_miesTomy_relateds_my_id,
    required this.my_relateds_miesTomy_relateds_related_id,
  });

  factory Mies.fromJson(Map<String, dynamic> json) {
    return Mies(
      my_relateds_miesTomy_relateds_my_id: List<dynamic>.from(
          json["my_relateds_miesTomy_relateds_my_id"].map((x) => x)),
      my_relateds_miesTomy_relateds_related_id:
          (json["my_relateds_miesTomy_relateds_related_id"] as List<dynamic>)
              .map((e) => MyRelatedsMiesTomyRelatedsRelatedID.fromJson(e))
              .toList(),
    );
  }
}

class MyRelatedsMiesTomyRelatedsRelatedID {
  MiesMiesTomyRelatedsMyID mies_miesTomy_relateds_my_id;

  MyRelatedsMiesTomyRelatedsRelatedID({
    required this.mies_miesTomy_relateds_my_id,
  });

  factory MyRelatedsMiesTomyRelatedsRelatedID.fromJson(
      Map<String, dynamic> json) {
    return MyRelatedsMiesTomyRelatedsRelatedID(
      mies_miesTomy_relateds_my_id: MiesMiesTomyRelatedsMyID.fromJson(
          json["mies_miesTomy_relateds_my_id"]),
    );
  }
}

class MiesMiesTomyRelatedsMyID {
  List<dynamic> anidbs;
  int myid;

  MiesMiesTomyRelatedsMyID({
    required this.anidbs,
    required this.myid,
  });

  factory MiesMiesTomyRelatedsMyID.fromJson(Map<String, dynamic> json) {
    return MiesMiesTomyRelatedsMyID(
      anidbs: List<dynamic>.from(json["anidbs"].map((x) => x)),
      myid: json["myid"],
    );
  }
}

class MuComics {
  bool? completely_scanlated;
  bool licensed_in_english;
  List<MuComicCategory> mu_comic_categories;

  MuComics({
    required this.completely_scanlated,
    required this.licensed_in_english,
    required this.mu_comic_categories,
  });

  factory MuComics.fromJson(Map<String, dynamic> json) {
    return MuComics(
      completely_scanlated: json["completely_scanlated"],
      licensed_in_english: json["licensed_in_english"],
      mu_comic_categories: (json["mu_comic_categories"] as List<dynamic>)
          .map((e) => MuComicCategory.fromJson(e))
          .toList(),
    );
  }
}

class MuComicCategory {
  MuCategories mu_categories;
  int negative_vote;
  int positive_vote;

  MuComicCategory({
    required this.mu_categories,
    required this.negative_vote,
    required this.positive_vote,
  });

  factory MuComicCategory.fromJson(Map<String, dynamic> json) {
    return MuComicCategory(
      mu_categories: MuCategories.fromJson(json["mu_categories"]),
      negative_vote: json["negative_vote"],
      positive_vote: json["positive_vote"],
    );
  }
}

class MuCategories {
  String slug;
  String title;

  MuCategories({
    required this.slug,
    required this.title,
  });

  factory MuCategories.fromJson(Map<String, dynamic> json) {
    return MuCategories(
      slug: json["slug"],
      title: json["title"],
    );
  }
}
