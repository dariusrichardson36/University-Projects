class Exercise {
  final String name;
  final String id;
  bool isFavorite;

  Exercise({required this.name, required this.id, required this.isFavorite});

  factory Exercise.fromMap(Map<String, dynamic> json, String id, bool isFavorite) {
    return Exercise(
      name: json['name'],
      id: id,
      isFavorite: isFavorite,
    );
  }
}