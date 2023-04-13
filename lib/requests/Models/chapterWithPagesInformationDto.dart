
import 'OtherChapterDto.dart';
import 'chapterWithPagesDto.dart';

class ChapterWithPagesInformationDto {
  final ChapterWithPagesDto chapter;
  final OtherChapterDto? next;
  final OtherChapterDto? prev;
  final bool? matureContent;
  final String? seoTitle;
  final String? seoDescription;
  final String? chapTitle;

  ChapterWithPagesInformationDto({
    required this.chapter,
    required this.next,
    required this.prev,
    required this.matureContent,
    required this.seoTitle,
    required this.seoDescription,
    required this.chapTitle,
  });

  factory ChapterWithPagesInformationDto.fromJson(Map<String, dynamic> json) {
    return ChapterWithPagesInformationDto(
      chapter: ChapterWithPagesDto.fromJson(json["chapter"]),
      next: json["next"] == null ? null : OtherChapterDto.fromJson(json["next"]),
      prev: json["prev"] == null ? null : OtherChapterDto.fromJson(json["prev"]),
      matureContent: json["mature_content"],
      seoTitle: json["seo_title"],
      seoDescription: json["seo_description"],
      chapTitle: json["chap_title"],
    );
  }
}