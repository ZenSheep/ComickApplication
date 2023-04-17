
import 'package:comick_application/requests/Models/mdCoverDto.dart';

class ComicDto {
  final String slug;
  final String title;
  final num? demographic;
  final String content_rating;
  final List<num>? genres;
  final double? last_chapter;
  final List<MdCoverDto> md_covers;

  ComicDto({
    required this.slug,
    required this.title,
    required this.demographic,
    required this.content_rating,
    required this.genres,
    required this.last_chapter,
    required this.md_covers,
  });

  factory ComicDto.fromJson(Map<String, dynamic> json) {
    return ComicDto(
      slug: json["slug"],
      title: json["title"],
      demographic: json["demographic"],
      content_rating: json["content_rating"],
      genres: json["genres"] == null ? null : (json["genres"] as List<dynamic>).map((e) => e as num).toList(),
      last_chapter: json["last_chapter"],
      md_covers: (json["md_covers"] as List<dynamic>).map((e) => MdCoverDto.fromJson(e)).toList(),
    );
  }

  String getImageUrl() {
    if (md_covers.isEmpty) {
      return "";
    }
    return md_covers.first.getImageUrl();
  }
}