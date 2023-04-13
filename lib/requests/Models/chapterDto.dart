import 'package:time_machine/time_machine.dart';
import 'package:intl/intl.dart';

class ChapterDto {
  final num? id;
  final String? chap;
  final String? title;
  final String? vol;
  final String lang;
  final DateTime created_at;
  final DateTime updated_at;
  final num? up_count;
  final num? down_count;
  final List<String>? group_name;
  final String hid;

  ChapterDto({
    required this.id,
    required this.chap,
    required this.title,
    required this.vol,
    required this.lang,
    required this.created_at,
    required this.updated_at,
    required this.up_count,
    required this.down_count,
    required this.group_name,
    required this.hid,
  });

  factory ChapterDto.fromJson(Map<String, dynamic> json) {
    DateFormat format = DateFormat("MMM dd, yyyy, h:mm:ss a");

    return ChapterDto(
      id: json["id"],
      chap: json["chap"],
      title: json["title"],
      vol: json["vol"],
      lang: json["lang"],
      created_at: format.parse(json["created_at"]),
      updated_at: format.parse(json["updated_at"]),
      up_count: json["up_count"],
      down_count: json["down_count"],
      group_name: (json["group_name"] as List<dynamic>).map((e) => e as String).toList(),
      hid: json["hid"],
    );
  }

  String getFlagCode() {
    if (lang == 'en') {
      return 'gb';
    }
    if (lang == 'es-419') {
      return 'es';
    }
    return lang.toUpperCase();
  }

  String getCreatedDate() {
    var now = LocalDate.today();
    var created = LocalDate.dateTime(created_at);
    var diff = now.periodSince(created);
    if (diff.years > 0) {
      return '${diff.years} years';
    }
    return '${diff.months} months';
  }

  String getGroupName() {
    if (group_name == null || group_name!.isEmpty) {
      return '';
    }
    return group_name!.first;
  }
}