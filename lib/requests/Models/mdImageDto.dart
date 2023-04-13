
class MdImageDto {
  final num h;
  final num w;
  final String name;
  final num s;
  final String b2key;

  MdImageDto({
    required this.h,
    required this.w,
    required this.name,
    required this.s,
    required this.b2key,
  });

  factory MdImageDto.fromJson(Map<String, dynamic> json) {
    return MdImageDto(
      h: json["h"],
      w: json["w"],
      name: json["name"],
      s: json["s"],
      b2key: json["b2key"],
    );
  }

  String getImageUrl() {
    return 'https://meo.comick.pictures/$b2key';
  }
}