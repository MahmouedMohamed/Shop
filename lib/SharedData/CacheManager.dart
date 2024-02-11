// ignore_for_file: file_names

class CacheManager {
  Map<String, dynamic> data = <String, dynamic>{};

  CacheManager._privateConstructor();
  static final CacheManager _instance = CacheManager._privateConstructor();
  factory CacheManager() {
    return _instance;
  }

  void setData(String key, dynamic value) {
    data[key] = value;
  }

  void removeData(String key) {
    data.remove(key);
  }

  void clear() {
    data = <String, dynamic>{};
  }

  bool hasData(String key) {
    return data.containsKey(key);
  }

  dynamic getData(String key) {
    return data[key];
  }
}