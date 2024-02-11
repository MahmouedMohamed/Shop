// ignore_for_file: file_names

class Helper{
  bool notNull(dynamic object){
    return object != null && object != 'null';
  }

  String getAppropriateText(dynamic object) {
    return notNull(object) ? object.toString() : 'غير متوفر';
  }

  bool isNotAvailable(String? text){
    return text == null || text == 'غير متوفر';
  }
}