class Brother {
  final int id;
  final String name;

  Brother({required this.id, required this.name});

  // Convertir a mapa para insertar en la base de datos
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': name,
    };
  }

  // Convertir de un mapa a objeto
  static Brother fromMap(Map<String, dynamic> map) {
    return Brother(
      id: map['id'],
      name: map['nombre'],
    );
  }
}
