import 'package:localstorage/localstorage.dart';

class Storage {
  late LocalStorage storage;

  Storage(String storageName) {
    storage = LocalStorage(storageName);
  }

  Future<bool> wasChapterRead(
      String slug, String groupName, String? chap) async {
    return await storage.getItem('${slug}_${groupName}_$chap') != null;
  }

  Future<void> setPageSaw(
      String slug, String groupName, String? chap, int page) async {
    return storage.ready.then((value) {
      return storage.setItem('${slug}_${groupName}_$chap', page);
    });
  }

  Future<int?> getPageRead(String slug, String groupName, String? chap) async {
    return await storage.getItem('${slug}_${groupName}_$chap');
  }

  Future<void> deleteItem(String item) async {
    return await storage.deleteItem(item);
  }
}
