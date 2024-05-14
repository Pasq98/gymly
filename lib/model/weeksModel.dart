class WeeksModel {
  final String title;
  final int idSchedules;
  int? id;

  WeeksModel({
    required this.title,
    required this.idSchedules,
  });

  WeeksModel.fromMap(Map<String, dynamic> item)
      : id = item['id'],
        title = item['title'],
        idSchedules = item['idSchedules'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'idSchedules': idSchedules,
    };
  }

  @override
  String toString() {
    return "id : $id, title : $idSchedules, idSchedules ";
  }
}
