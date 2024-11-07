class ScannedObject {
  final String id;
  final String name;

  ScannedObject({required this.id, required this.name});

  @override
  String toString() => 'ID: $id, Name: $name';
}
