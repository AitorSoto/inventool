class Tool {
  final int id;
  final String name;
  final int? brotherId;

  Tool({required this.id, required this.name, this.brotherId});

  // Convertir a mapa para insertar en la base de datos
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': name,
      'idPersona': brotherId,
    };
  }

  // Convertir de un mapa a objeto
  static Tool fromMap(Map<String, dynamic> map) {
    return Tool(
      id: map['id'],
      name: map['nombre'],
      brotherId: map['idPersona'],
    );
  }
}
