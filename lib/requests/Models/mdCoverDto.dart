
class MdCoverDto {
  final num w;
  final num h;
  final String b2key;

  MdCoverDto({
    required this.w,
    required this.h,
    required this.b2key,
  });

  factory MdCoverDto.fromJson(Map<String, dynamic> json) {
    return MdCoverDto(
      w: json["w"],
      h: json["h"],
      b2key: json["b2key"],
    );
  }

  String getImageUrl() {
    return 'https://meo.comick.pictures/$b2key';
  }
}