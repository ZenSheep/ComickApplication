import 'package:time_machine/time_machine.dart';

class Chapters {
  List<Chapter> chapters;
  int total;

  Chapters({
    required this.chapters,
    required this.total,
  });

  factory Chapters.fromJson(Map<String, dynamic> json) {
    return Chapters(
      chapters: (json["chapters"] as List<dynamic>).map((e) => Chapter.fromJson(e)).toList(),
      total: json["total"],
    );
  }

  int getNumberOfPages() {
    return (total / 300).ceil();
  }
}

class Chapter {
  String chap;
  DateTime createdAt;
  int downCount;
  String? groupName;
  String hid;
  int id;
  String lang;
  List<MdGroup> mdGroups;
  String? slug;
  String? title;
  int upCount;
  DateTime updatedAt;
  String? vol;

  Chapter({
    required this.chap,
    required this.createdAt,
    required this.downCount,
    required this.groupName,
    required this.hid,
    required this.id,
    required this.lang,
    required this.mdGroups,
    required this.slug,
    required this.title,
    required this.upCount,
    required this.updatedAt,
    required this.vol,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    final groupNames = (json["group_name"] as List<dynamic>);
    
    return Chapter(
      chap: json["chap"],
      createdAt: DateTime.parse(json["created_at"]),
      downCount: json["down_count"],
      groupName: groupNames.isEmpty ? null : groupNames.first,
      hid: json["hid"],
      id: json["id"],
      lang: json["lang"],
      mdGroups: (json["md_groups"] as List<dynamic>).map((e) => MdGroup.fromJson(e)).toList(),
      slug: json["slug"],
      title: json["title"],
      upCount: json["up_count"],
      updatedAt: DateTime.parse(json["updated_at"]),
      vol: json["vol"],
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
    var created = LocalDate.dateTime(createdAt);
    var diff = now.periodSince(created);
    if (diff.years > 0) {
      return '${diff.years} years';
    }
    return '${diff.months} months';
  }
}

class MdGroup {
 String? slug;
 String? title;

  MdGroup({
    required this.slug,
    required this.title,
  });

  factory MdGroup.fromJson(Map<String, dynamic> json) {
    return MdGroup(
      slug: json["slug"],
      title: json["title"],
    );
  }
}