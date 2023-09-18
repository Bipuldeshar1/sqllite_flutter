class NotesModel {
  final int? id;
  final int? age;
  final String? title;
  final String? description;

  NotesModel({
    required this.id,
    required this.title,
    required this.age,
    required this.description,
  });
  NotesModel.fromJson(Map<String, dynamic> res)
      : id = res['id'],
        age = res['age'],
        title = res['title'],
        description = res['description'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'age': age,
      'title': title,
      'descripiton': description,
    };
  }
}
