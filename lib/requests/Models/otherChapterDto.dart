
class OtherChapterDto {
  final String? chap;
  final String? vol;
  final String? title;
  final String hid;
  final String? lang;
  final num? id;
  final String? href;

  OtherChapterDto({
    required this.chap,
    required this.vol,
    required this.title,
    required this.hid,
    required this.lang,
    required this.id,
    required this.href,
  });

  factory OtherChapterDto.fromJson(Map<String, dynamic> json) {
    return OtherChapterDto(
      chap: json["chap"],
      vol: json["vol"],
      title: json["title"],
      hid: json["hid"],
      lang: json["lang"],
      id: json["id"],
      href: json["href"],
    );
  }
}