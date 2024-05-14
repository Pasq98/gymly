class ExcerciseModel {
  int? id;
  final int idSchedule;
  final String idDay;
  final String idWeek;
  final String nome;
  final String setsAndRep;
  final int recovery;

  ExcerciseModel(
      {this.id,
      required this.idSchedule,
      required this.idDay,
      required this.idWeek,
      required this.setsAndRep,
      required this.recovery,
      required this.nome});

  ExcerciseModel.fromMap(Map<String, dynamic> item)
      : id = item['id'],
        idSchedule = item['idSchedule'],
        idDay = item['idDay'],
        idWeek = item['idWeek'],
        setsAndRep = item['setsAndRep'],
        recovery = item['recovery'],
        nome = item['nome'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idSchedule': idSchedule,
      'idDay': idDay,
      'idWeek': idWeek,
      'setsAndRep': setsAndRep,
      'recovery': recovery,
      'nome': nome,
    };
  }

  @override
  String toString() {
    return "id : $id, idSchedule : $idSchedule, idDay : $idDay,  idWeek : $idWeek, setsAndRep: $setsAndRep, recovery : $recovery,nome : $nome";
  }
}
