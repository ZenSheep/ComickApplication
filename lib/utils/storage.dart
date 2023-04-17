import 'package:localstorage/localstorage.dart';

class Storage {
  late LocalStorage storage;

  Storage(String storageName) {
    storage = LocalStorage(storageName);
  }

  Future<bool> wasChapterRead(String slug, String groupName, String? chap) async {
    return await storage.getItem('${slug}_${groupName}_$chap') != null;
  }

  Future<void> setChapterRead(String slug, String groupName, String? chap) async {
    return await storage.setItem('${slug}_${groupName}_$chap', true);
  }
}