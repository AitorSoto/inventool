class Volunteer {
  final int id;
  final String name;

  Volunteer({required this.id, required this.name});

  // Convertir a mapa para insertar en la base de datos
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': name,
    };
  }

  // Convertir de un mapa a objeto
  static Volunteer fromMap(Map<String, dynamic> map) {
    return Volunteer(
      id: map['id'],
      name: map['nombre'],
    );
  }
}
