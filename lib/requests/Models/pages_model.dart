import 'chapters_model.dart';
import 'comick_model.dart';

class Pages {
 String? canonical;
 String? chapTitle;
 ComickChapter chapter;
 List<ChapterLangList> chapterLangList;
 List<Prev> chapters;
 bool checkVol2Chap1;
 List<Prev> dupGroupChapters;
 bool matureContent;
 Prev? next;
 Prev? prev;
 String? seoDescription;
 String? seoTitle;

  Pages({
    required this.canonical,
    required this.chapTitle,
    required this.chapter,
    required this.chapterLangList,
    required this.chapters,
    required this.checkVol2Chap1,
    required this.dupGroupChapters,
    required this.matureContent,
    required this.next,
    required this.prev,
    required this.seoDescription,
    required this.seoTitle,
  });

  factory Pages.fromJson(Map<String, dynamic> json) {
    return Pages(
      canonical: json["canonical"],
      chapTitle: json["chapTitle"],
      chapter: ComickChapter.fromJson(json["chapter"]),
      chapterLangList: (json["chapterLangList"] as List<dynamic>).map((e) => ChapterLangList.fromJson(e)).toList(),
      chapters: (json["chapters"] as List<dynamic>).map((e) => Prev.fromJson(e)).toList(),
      checkVol2Chap1: json["checkVol2Chap1"],
      dupGroupChapters: (json["dupGroupChapters"] as List<dynamic>).map((e) => Prev.fromJson(e)).toList(),
      matureContent: json["matureContent"],
      next: json["next"] == null ? null : Prev.fromJson(json["next"]),
      prev: json["prev"] == null ? null : Prev.fromJson(json["prev"]),
      seoDescription: json["seoDescription"],
      seoTitle: json["seoTitle"],
    );
  }
}

class ComickChapter {
 String? chap;
 int? chapterId;
 int commentCount;
 String? createdAt;
 int downCount;
 List<String> groupName;
 String? hash;
 String? hid;
 int id;
 String? lang;
 List<MdChaptersGroup> mdChaptersGroups;
 MdComics mdComics;
 List<MdImage> mdImages;
 String? mdid;
 String? mseid;
 String? server;
 String? status;
 String? title;
 int upCount;
 String? vol;

  ComickChapter({
    required this.chap,
    required this.chapterId,
    required this.commentCount,
    required this.createdAt,
    required this.downCount,
    required this.groupName,
    required this.hash,
    required this.hid,
    required this.id,
    required this.lang,
    required this.mdChaptersGroups,
    required this.mdComics,
    required this.mdImages,
    required this.mdid,
    required this.mseid,
    required this.server,
    required this.status,
    required this.title,
    required this.upCount,
    required this.vol,
  });

  factory ComickChapter.fromJson(Map<String, dynamic> json) {
    return ComickChapter(
      chap: json["chap"],
      chapterId: json["chapter_id"],
      commentCount: json["comment_count"],
      createdAt: json["created_at"],
      downCount: json["down_count"],
      groupName: List<String>.from(json["group_name"].map((x) => x)),
      hash: json["hash"],
      hid: json["hid"],
      id: json["id"],
      lang: json["lang"],
      mdChaptersGroups: (json["md_chapters_groups"] as List<dynamic>).map((e) => MdChaptersGroup.fromJson(e)).toList(),
      mdComics: MdComics.fromJson(json["md_comics"]),
      mdImages: (json["md_images"] as List<dynamic>).map((e) => MdImage.fromJson(e)).toList(),
      mdid: json["mdid"],
      mseid: json["mseid"],
      server: json["server"],
      status: json["status"],
      title: json["title"],
      upCount: json["up_count"],
      vol: json["vol"],
    );
  }
}

class MdChaptersGroup {
 int mdGroupId;
 MdGroup mdGroups;

  MdChaptersGroup({
    required this.mdGroupId,
    required this.mdGroups,
  });
  factory MdChaptersGroup.fromJson(Map<String, dynamic> json) {
    return MdChaptersGroup(
      mdGroupId: json["md_group_id"],
      mdGroups: MdGroup.fromJson(json["md_groups"]),
    );
  }
}

class MdComics {
 String? contentRating;
 String? country;
 String? desc;
 List<int> genres;
 bool hentai;
 int id;
 Links links;
 List<MdCover> mdCovers;
 String? slug;
 String? title;

  MdComics({
    required this.contentRating,
    required this.country,
    required this.desc,
    required this.genres,
    required this.hentai,
    required this.id,
    required this.links,
    required this.mdCovers,
    required this.slug,
    required this.title,
  });

  factory MdComics.fromJson(Map<String, dynamic> json) {
    return MdComics(
      contentRating: json["content_rating"],
      country: json["country"],
      desc: json["desc"],
      genres: List<int>.from(json["genres"].map((x) => x)),
      hentai: json["hentai"],
      id: json["id"],
      links: Links.fromJson(json["links"]),
      mdCovers: (json["md_covers"] as List<dynamic>).map((e) => MdCover.fromJson(e)).toList(),
      slug: json["slug"],
      title: json["title"],
    );
  }
}

class Links {
 String? al;
 String? amz;
 String? ap;
 String? bw;
 String? ebj;
 String? engtl;
 String? kt;
 String? mal;
 String? mu;
 String? nu;
 String? raw;

  Links({
    required this.al,
    required this.amz,
    required this.ap,
    required this.bw,
    required this.ebj,
    required this.engtl,
    required this.kt,
    required this.mal,
    required this.mu,
    required this.nu,
    required this.raw,
  });

  factory Links.fromJson(Map<String, dynamic> json) {
    return Links(
      al: json["al"],
      amz: json["amz"],
      ap: json["ap"],
      bw: json["bw"],
      ebj: json["ebj"],
      engtl: json["engtl"],
      kt: json["kt"],
      mal: json["mal"],
      mu: json["mu"],
      nu: json["nu"],
      raw: json["raw"],
    );
  }
}

class MdImage {
 String? b2key;
 String? gpurl;
 int h;
 String? name;
 int? optimized;
 int s;
 int w;

  MdImage({
    required this.b2key,
    required this.gpurl,
    required this.h,
    required this.name,
    required this.optimized,
    required this.s,
    required this.w,
  });

  factory MdImage.fromJson(Map<String, dynamic> json) {
    return MdImage(
      b2key: json["b2key"],
      gpurl: json["gpurl"],
      h: json["h"],
      name: json["name"],
      optimized: json["optimized"],
      s: json["s"],
      w: json["w"],
    );
  }

  String getImageUrl()
  {
    print("https://meo.comick.pictures/$b2key");
    return "https://meo.comick.pictures/$b2key";
  }
}

class ChapterLangList {
 String? hid;
 String? lang;

  ChapterLangList({
    required this.hid,
    required this.lang,
  });

  factory ChapterLangList.fromJson(Map<String, dynamic> json) {
    return ChapterLangList(
      hid: json["hid"],
      lang: json["lang"],
    );
  }
}

class Prev {
 String? chap;
 List<String> groupName;
 String hid;
 String? href;
 int id;
 String? lang;
 List<int> mdChaptersGroups;
 int? mdGroupId;
 String? title;
 String? vol;

  Prev({
    required this.chap,
    required this.groupName,
    required this.hid,
    required this.id,
    required this.lang,
    required this.mdChaptersGroups,
    required this.mdGroupId,
    required this.title,
    required this.vol,
  });
  factory Prev.fromJson(Map<String, dynamic> json) {
    return Prev(
      chap: json["chap"],
      groupName: List<String>.from(json["group_name"].map((x) => x)),
      hid: json["hid"],
      id: json["id"],
      lang: json["lang"],
      mdChaptersGroups: List<int>.from(json["md_chapters_groups"].map((x) => x)),
      mdGroupId: json["md_group_id"],
      title: json["title"],
      vol: json["vol"],
    );
  }
}
