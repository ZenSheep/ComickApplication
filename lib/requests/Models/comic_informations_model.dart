import 'package:comick_application/requests/Models/comick_model.dart';
import 'package:comick_application/requests/Models/pages_model.dart';

class ComicInformations {
 List<Artist> artists;
 List<Artist> authors;
 Comic comic;
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
      artists: (json["artists"] as List<dynamic>).map((e) => Artist.fromJson(e)).toList(),
      authors: (json["authors"] as List<dynamic>).map((e) => Artist.fromJson(e)).toList(),
      comic: Comic.fromJson(json["comic"]),
      demographic: json["demographic"],
      englishLink: json["english_link"],
      genres: (json["genres"] as List<dynamic>).map((e) => Artist.fromJson(e)).toList(),
      langList: json["lang_list"],
      matureContent: json["mature_content"],
    );
  }

  String? getImageUrl()
  {
    if(comic.md_covers.isEmpty)
    {
      return null;
    }
    return comic.md_covers.first.getImageUrl();
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

class Comic {
 String? bayesian_rating;
 int chapter_count;
 int comment_count;
 String content_rating;
 String country;
 int demographic;
 String desc;
 int follow_count;
 int follow_rank;
 bool hentai;
 int id;
 String iso639_1;
 String? lang_name;
 String? lang_native;
 double? last_chapter;
 Links links;
 List<MdComicMdGenre> md_comic_md_genres;
 List<MdCover> md_covers;
 List<MdTitle> md_titles;
 int? mdid;
 Mies? mies;
 MuComics mu_comics;
 String parsed;
 int rating_count;
 List<dynamic> relate_from;
 String slug;
 int status;
 String title;
 int user_follow_count;
 int verification_status;
 int year;

  Comic({
    required this.bayesian_rating,
    required this.chapter_count,
    required this.comment_count,
    required this.content_rating,
    required this.country,
    required this.demographic,
    required this.desc,
    required this.follow_count,
    required this.follow_rank,
    required this.hentai,
    required this.id,
    required this.iso639_1,
    required this.lang_name,
    required this.lang_native,
    required this.last_chapter,
    required this.links,
    required this.md_comic_md_genres,
    required this.md_covers,
    required this.md_titles,
    required this.mdid,
    required this.mies,
    required this.mu_comics,
    required this.parsed,
    required this.rating_count,
    required this.relate_from,
    required this.slug,
    required this.status,
    required this.title,
    required this.user_follow_count,
    required this.verification_status,
    required this.year,
  });

  factory Comic.fromJson(Map<String, dynamic> json) {
    return Comic(
      bayesian_rating: json["bayesian_rating"],
      chapter_count: json["chapter_count"],
      comment_count: json["comment_count"],
      content_rating: json["content_rating"],
      country: json["country"],
      demographic: json["demographic"],
      desc: json["desc"],
      follow_count: json["follow_count"],
      follow_rank: json["follow_rank"],
      hentai: json["hentai"],
      id: json["id"],
      iso639_1: json["iso639_1"],
      lang_name: json["lang_name"],
      lang_native: json["lang_native"],
      last_chapter: json["last_chapter"] + .0,
      links: Links.fromJson(json["links"]),
      md_comic_md_genres: (json["md_comic_md_genres"] as List<dynamic>).map((e) => MdComicMdGenre.fromJson(e)).toList(),
      md_covers: (json["md_covers"] as List<dynamic>).map((e) => MdCover.fromJson(e)).toList(),
      md_titles: (json["md_titles"] as List<dynamic>).map((e) => MdTitle.fromJson(e)).toList(),
      mdid: json["mdid"],
      mies: json["mies"] != null ? Mies.fromJson(json["mies"]) : null,
      mu_comics: MuComics.fromJson(json["mu_comics"]),
      parsed: json["parsed"],
      rating_count: json["rating_count"],
      relate_from: List<dynamic>.from(json["relate_from"].map((x) => x)),
      slug: json["slug"],
      status: json["status"],
      title: json["title"],
      user_follow_count: json["user_follow_count"],
      verification_status: json["verification_status"],
      year: json["year"],
    );
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
 List<MyRelatedsMiesTomyRelatedsRelatedID> my_relateds_miesTomy_relateds_related_id;

  Mies({
    required this.my_relateds_miesTomy_relateds_my_id,
    required this.my_relateds_miesTomy_relateds_related_id,
  });

  factory Mies.fromJson(Map<String, dynamic> json) {
    return Mies(
      my_relateds_miesTomy_relateds_my_id: List<dynamic>.from(json["my_relateds_miesTomy_relateds_my_id"].map((x) => x)),
      my_relateds_miesTomy_relateds_related_id: (json["my_relateds_miesTomy_relateds_related_id"] as List<dynamic>).map((e) => MyRelatedsMiesTomyRelatedsRelatedID.fromJson(e)).toList(),
    );
  }
}

class MyRelatedsMiesTomyRelatedsRelatedID {
 MiesMiesTomyRelatedsMyID mies_miesTomy_relateds_my_id;

  MyRelatedsMiesTomyRelatedsRelatedID({
    required this.mies_miesTomy_relateds_my_id,
  });

  factory MyRelatedsMiesTomyRelatedsRelatedID.fromJson(Map<String, dynamic> json) {
    return MyRelatedsMiesTomyRelatedsRelatedID(
      mies_miesTomy_relateds_my_id: MiesMiesTomyRelatedsMyID.fromJson(json["mies_miesTomy_relateds_my_id"]),
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
 bool completely_scanlated;
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
      mu_comic_categories: (json["mu_comic_categories"] as List<dynamic>).map((e) => MuComicCategory.fromJson(e)).toList(),
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
