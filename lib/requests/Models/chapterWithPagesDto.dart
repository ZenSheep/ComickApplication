
import 'package:intl/intl.dart';

import 'mdImageDto.dart';

class ChapterWithPagesDto {
  final num id;
  final String chap;
  final String? vol;
  final String? title;
  final String hid;
  final List<String>? group_name;
  final DateTime created_at;
  final DateTime updated_at;
  final num? up_count;
  final num? down_count;
  final String? status;
  final String lang;
  final List<MdImageDto> md_images;

  ChapterWithPagesDto({
    required this.id,
    required this.chap,
    required this.vol,
    required this.title,
    required this.hid,
    required this.group_name,
    required this.created_at,
    required this.updated_at,
    required this.up_count,
    required this.down_count,
    required this.status,
    required this.lang,
    required this.md_images,
  });

  factory ChapterWithPagesDto.fromJson(Map<String, dynamic> json) {
    DateFormat format = DateFormat("MMM dd, yyyy, h:mm:ss a");

    return ChapterWithPagesDto(
      id: json["id"],
      chap: json["chap"],
      vol: json["vol"],
      title: json["title"],
      hid: json["hid"],
      group_name: json["group_name"] == null ? null : (json["group_name"] as List<dynamic>).map((e) => e as String).toList(),
      created_at: format.parse(json["created_at"]),
      updated_at: format.parse(json["updated_at"]),
      up_count: json["up_count"],
      down_count: json["down_count"],
      status: json["status"],
      lang: json["lang"],
      md_images: (json["md_images"] as List<dynamic>).map((e) => MdImageDto.fromJson(e)).toList(),
    );
  }

  String getGroupName() {
    if (group_name == null || group_name!.isEmpty) {
      return 'unknown';
    }
    return group_name!.first;
  }
}