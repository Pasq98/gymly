class RepModel {
  final int? id;
  final int idSet;
  final int idExcercise;
  final String idDay;
  final String idWeek;
  final int peso;
  final int rep;
  final int ced;

  RepModel({
    this.id,
    required this.idExcercise,
    required this.idDay,
    required this.idSet,
    required this.idWeek,
    required this.peso,
    required this.rep,
    required this.ced,
  });

  RepModel.fromMap(Map<String, dynamic> item)
      : id = item['id'],
        idExcercise = item['idExcercise'],
        idDay = item['idDay'],
        idSet = item['idSet'],
        idWeek = item['idWeek'],
        peso = item['peso'],
        rep = item['rep'],
        ced = item['ced'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idExcercise': idExcercise,
      'idDay': idDay,
      'idSet': idSet,
      'idWeek': idWeek,
      'peso': peso,
      'rep': rep,
      'ced': ced
    };
  }

  @override
  String toString() {
    return "id : $id, idExcercise: $idExcercise, idDay : $idDay, idSet : $idSet, idWeek : $idWeek, peso : $peso,  rep : $rep ced: $ced \n";
  }
}
