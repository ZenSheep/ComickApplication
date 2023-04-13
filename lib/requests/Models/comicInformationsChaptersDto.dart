
import 'chapterDto.dart';
import 'mdCoverDto.dart';

class ComicInformationsChaptersDto {
  final num id;
  final String hid;
  final String title;
  final String country;
  final num status;
  final num last_chapter;
  final num chapter_count;
  final bool hentai;
  final num follow_rank;
  final num follow_count;
  final String desc;
  final String slug;
  final num year;
  final num rating_count;
  final String? content_rating;
  final bool translation_completed;
  final List<MdCoverDto> md_covers;
  final List<ChapterDto> chapters;
  final num total;

  ComicInformationsChaptersDto({
    required this.id,
    required this.hid,
    required this.title,
    required this.country,
    required this.status,
    required this.last_chapter,
    required this.chapter_count,
    required this.hentai,
    required this.follow_rank,
    required this.follow_count,
    required this.desc,
    required this.slug,
    required this.year,
    required this.rating_count,
    required this.content_rating,
    required this.translation_completed,
    required this.md_covers,
    required this.chapters,
    required this.total,
  });

  factory ComicInformationsChaptersDto.empty() {
    return ComicInformationsChaptersDto(
      id: 0,
      hid: "",
      title: "",
      country: "",
      status: 0,
      last_chapter: 0,
      chapter_count: 0,
      hentai: false,
      follow_rank: 0,
      follow_count: 0,
      desc: "",
      slug: "",
      year: 0,
      rating_count: 0,
      content_rating: "",
      translation_completed: false,
      md_covers: [],
      chapters: [],
      total: 0,
    );
  }

  factory ComicInformationsChaptersDto.fromJson(Map<String, dynamic> json) {
    return ComicInformationsChaptersDto(
      id: json["id"],
      hid: json["hid"],
      title: json["title"],
      country: json["country"],
      status: json["status"],
      last_chapter: json["last_chapter"],
      chapter_count: json["chapter_count"],
      hentai: json["hentai"],
      follow_rank: json["follow_rank"],
      follow_count: json["follow_count"],
      desc: json["desc"],
      slug: json["slug"],
      year: json["year"],
      rating_count: json["rating_count"],
      content_rating: json["content_rating"],
      translation_completed: json["translation_completed"],
      md_covers: (json["md_covers"] as List<dynamic>)
          .map((e) => MdCoverDto.fromJson(e))
          .toList(),
      chapters: (json["chapters"] as List<dynamic>)
          .map((e) => ChapterDto.fromJson(e))
          .toList(),
      total: json["total"],
    );
  }

  int getNumberOfPages() {
    return (total / 300).ceil();
  }
}