class DataEntry {
  final String referenceNumber; // Número de referencia
  final String client;           // Cliente
  final String location;         // Locación
  final String fseName;         // Nombre FSE
  final String customManager;    // Custom Manager
  final String activityPerformed; // Activity Performed
  final String observations;      // Observaciones

  DataEntry({
    required this.referenceNumber,
    required this.client,
    required this.location,
    required this.fseName,
    required this.customManager,
    required this.activityPerformed,
    required this.observations,
  });

  // Método para convertir la clase a un mapa (JSON)
  Map<String, dynamic> toJson() {
    return {
      'referenceNumber': referenceNumber,
      'client': client,
      'location': location,
      'fseName': fseName,
      'customManager': customManager,
      'activityPerformed': activityPerformed,
      'observations': observations,
    };
  }

  // Método para crear una instancia de la clase a partir de un mapa (JSON)
  factory DataEntry.fromJson(Map<String, dynamic> json) {
    return DataEntry(
      referenceNumber: json['referenceNumber'],
      client: json['client'],
      location: json['location'],
      fseName: json['fseName'],
      customManager: json['customManager'],
      activityPerformed: json['activityPerformed'],
      observations: json['observations'],
    );
  }
}
